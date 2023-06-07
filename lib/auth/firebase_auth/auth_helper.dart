import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../model/usuario.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Usuario?> cargarUsuarioDeFirebase(String? uid) async {
    if (uid != null && uid.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return Usuario.fromMap(data);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static signInWithEmail(
      {String email = '',
      String password = '',
      bool estaCreado = false}) async {
    try {
      var res;
      if (estaCreado) {
        res = await signupWithEmail(
            email: email, password: password, estaRegistrado: estaCreado);
      } else {
        res = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        log('Respuesta Firebase:' + res);
      }
      final User firebaseUser = res;

      final Usuario? usuario =
          await AuthHelper().cargarUsuarioDeFirebase(firebaseUser.uid);
      Future.delayed(
        Duration(seconds: 2),
        () {},
      );
      return usuario;
    } on FirebaseAuthException catch (e) {
      var user;
      FirebaseFirestore _db = FirebaseFirestore.instance;
      var existe = await _db.collection("users").doc(email.toLowerCase()).get();
      log('Error: ' + e.message! + ' - Codigo: ' + e.code);
      if (e.code == 'user-not-found' && existe.exists) {
        log(existe.exists.toString());
        user = await signupWithEmail(
            email: email, password: password, estaRegistrado: true);
        if (user != null) {
          log(user);
        }
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  static signupWithEmail({
    String email = '',
    String password = '',
    String rol = 'user',
    bool estaRegistrado = false,
  }) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;

      var existe = await _db.collection("users").doc(email).get();
      if (existe.exists == false && estaRegistrado == false) {
        Map<String, dynamic> userData = {
          "FuncionarioImage": "",
          "fechanacimiento": "",
          "area": "",
          "telefono": "",
          "cargo": "",
          "password": "",
          "identificacion": "",
          "nombre": "",
          "email": email.toLowerCase(),
          "role": rol,
        };
        await _db.collection("users").doc(email).set(userData);
      }
      final UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (res.user != null) {
        if (!estaRegistrado) {
          UserHelper.saveUser(res.user!, rol: rol);
        }
      }
      Future.delayed(
        Duration(seconds: 2),
        () {},
      );
      return res.user;
    } on FirebaseAuthException {
    } catch (e) {
      log(e.toString());
    }
  }

  static estaLogeado() {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  static handleSignOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static var _dbRT = FirebaseDatabase.instance.reference();

  Future<void> eliminarFuncionario(String email) async {
    CollectionReference funcionarios =
        FirebaseFirestore.instance.collection('users');

    return funcionarios
        .doc(email)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  static saveUser(User user, {String rol = 'user'}) async {
    Map<String, dynamic> userData = {
      "FuncionarioImage": "",
      "fechanacimiento": "",
      "area": "",
      "telefono": "",
      "cargo": "",
      "password": "",
      "identificacion": "",
      "nombre": user.displayName,
      "email": user.email,
      "role": rol,
    };
    final userRef = _db.collection("users").doc(user.email);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      });
    } else {
      await _db.collection("users").doc(user.email).set(userData);
    }
  }

  static saveUserAdmin(User user) async {
    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
      "role": "admin",
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
  }
}
