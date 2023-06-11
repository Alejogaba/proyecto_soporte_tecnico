import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

import '../../model/usuario.dart';

class AuthHelper {

  


  static FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      print('UID del usuario actual: $uid');
      // Realiza las acciones necesarias con el UID del usuario
      return uid;
    } else {
      print('No se ha iniciado sesión');
      return null;
    }
  }

  Future<Usuario?> cargarUsuarioDeFirebase(String? email) async {
    if (email != null && email.isNotEmpty) {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (querySnapshot.data() != null && querySnapshot.data()!.isNotEmpty) {
        return Usuario.mapeo(querySnapshot.data()!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  /*static signInWithEmail(
      {required String email,
      required String password,
      bool estaCreado = false}) async {
    try {
      var res = null;
      if (estaCreado) {
        res = await signupWithEmail(
            email: email, password: password, estaRegistrado: estaCreado);
      } else {
        res = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      final User user = res.user;
      Get.snackbar('Bienvenido', ' ${user.email} Su ingreso ha sido exitoso');
      print('Ingreso Exitoso');
      Future.delayed(
        Duration(seconds: 4),
        () {},
      );
      return user;
    } on FirebaseAuthException catch (e) {
      var user = null;
      FirebaseFirestore _db = FirebaseFirestore.instance;
      var existe = await _db.collection("users").doc(email.toLowerCase()).get();
      Logger().e('Error: ' + e.message.toString() + ' - Codigo: ' + e.code);
      if (e.code == 'user-not-found' && existe.exists) {
        Logger().v(existe.exists);
        user = await signupWithEmail(
            email: email, password: password, estaRegistrado: true);
        if (user != null) {
          Logger().v(user);
          Get.toNamed('/home');
        }
      } else {
        var errorTraducido = await traducir(e.message.toString());
        Get.snackbar('Error', errorTraducido,
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            colorText: Color.fromARGB(255, 114, 14, 7));
      }
    } catch (e) {
      Logger().e(e);
    }
  }
**/
  static signInWithEmail(
      {String email = '',
      String password = '',
      bool estaCreado = false}) async {
    try {
      late UserCredential? res;
      late Usuario? usuario;
      if (estaCreado) {
        usuario = await signupWithEmail(
            email: email, password: password, estaRegistrado: estaCreado);
      } else {
        res = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        log('Respuesta Firebase:' + res.user.toString());
        usuario = await AuthHelper().cargarUsuarioDeFirebase(res.user!.uid);
      }
      log('El uid es:' + res!.user!.uid);

      log('Ya se cargo usuario de firebase: ' + usuario.toString());
      Future.delayed(
        Duration(seconds: 2),
        () {},
      );
      return usuario;
    } on FirebaseAuthException catch (e) {
    
      FirebaseFirestore _db = FirebaseFirestore.instance;
      var existe = await _db.collection("users").doc(email.toLowerCase()).get();
      log('Error: ' + e.message! + ' - Codigo: ' + e.code);
      if (e.code == 'user-not-found' && existe.exists) {
        log(existe.exists.toString());
        log('Registrando usuario en authenciator');
        Usuario? user = await signupWithEmail(
            email: email, password: password, estaRegistrado: true);
        return user;
      } else {
        late String mensajeError;
        switch (e.code) {
          case 'user-not-found':
            mensajeError = 'Este correo eléctronico no se encuentra registrado';
            break;
          case 'wrong-password':
            mensajeError = 'Contraseña incorrecta';
            break;
          default:
            mensajeError = await traducir(e.message.toString());
            break;
        }
        Get.snackbar('Error', mensajeError,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Color.fromARGB(213, 211, 31, 31),
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            colorText: Color.fromARGB(255, 228, 219, 218));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Usuario?> signupWithEmail({
    String email = '',
    String password = '',
    String rol = 'user',
    bool estaRegistrado = false,
  }) async {
    late Usuario? usuario;
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
      usuario = await AuthHelper().cargarUsuarioDeFirebase(res.user!.email);
      return usuario;
    } on FirebaseAuthException {
    } catch (e) {
      log(e.toString());
      usuario = null;
      return null;
    }
    return null;
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
  Future<List<Usuario>> loadUser([String text = '']) async {
    CollectionReference productos =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot;

    querySnapshot = await productos.get();

    var documents = querySnapshot.docs;
    List<Usuario> funcionarioList = [];
    documents.forEach(
      (element) {
        log('message');

        Usuario usuario = Usuario.mapeo(element as Map<String, dynamic>);
        if (!(usuario.role!.contains('user'))) {
          funcionarioList.add(usuario);
        }
      },
    );

    if (text.length > 0 && funcionarioList.length > 0) {
      List<Usuario> funcionarioListcopy = [];
      funcionarioList.forEach((element) {
        if (element.nombre
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            element.identificacion.toString().contains(text)) {
          if (element != null) {
            Logger().v(element.uid);
            funcionarioListcopy.add(element);
          }
        }
      });
      return funcionarioListcopy;
    } else {
      return funcionarioList;
    }
  }

  static FirebaseFirestore _db = FirebaseFirestore.instance;
 
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
    final userRef = _db.collection("users").doc(user.uid);
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

Future<String> traducir(String input) async {
  try {
    final translator = GoogleTranslator();
    var translation = await translator.translate(input, from: 'en', to: 'es');
    return translation.toString();
  } on FirebaseAuthException catch (e) {
    Logger().e('Error en el traductor: ' + e.message.toString());
    return "Ha ocurrido un error inesperado, revise su conexión a internet";
  }
}
