import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/auth/firebase_auth/firebase_user_provider.dart';
import 'package:login2/model/dependencias.dart';
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

  Future<Usuario?> cargarUsuarioDeFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Logger().i('Usuario actual funcion firebase: ${auth.currentUser!.email}');
    if (auth.currentUser!= null) {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get();
      if (querySnapshot.data() != null && querySnapshot.data()!.isNotEmpty) {
        return Usuario.mapeo(querySnapshot.data()!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static signUpWithEmail(
      {String? email,
      String? password,
      String rol = 'funcionario',
      bool estaRegistrado = false,
      BuildContext? context}) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email!.trim().toLowerCase(), password: password!.trim());
      User? user = res.user;
      String uid = user!.uid;

      var existe = await _db.collection("users").doc(uid).get();

      if (existe.exists == false && estaRegistrado == false) {
        Map<String, dynamic> userData = {
          "FuncionarioImage": "",
          "fechaNacimiento": "",
          "area": "",
          "telefono": "",
          "cargo": "",
          "password": "",
          "identificacion": "",
          "nombre": "",
          "name": "",
          "email": email.toLowerCase(),
          "last_login": "",
          "created_at": "",
          "role": rol,
          "build_number": "",
        };
        await _db.collection("users").doc(uid).set(userData);
        // Cierra la sesión del usuario
        await _auth.signOut();
        await FirebaseAuth.instance.signOut();
        Get.toNamed('/loguear');
      }

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
    } on FirebaseAuthException catch (e) {
      var errorTraducido = await traducir(e.message.toString());
      Get.snackbar('Error', errorTraducido,
          icon: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          colorText: Color.fromARGB(255, 114, 14, 7));
    } catch (e) {
      Logger().e(e);
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

//ACTUALIZAR??????????????????????????????????????
  void updateUser(Usuario? usuario) {
    String? nombre = usuario!.nombre;
    String? email = usuario.email;
    String? password = usuario.password;
    String? identificacion = usuario.identificacion;
    String? fechaNacimiento = usuario.fechaNacimiento;
    String? area = usuario.area;
    String? telefono = usuario.telefono;
    String? cargo = usuario.cargo;
    String? urlImagen = usuario.urlImagen;

    // Obtén los valores de los demás campos del formulario

    FirebaseFirestore.instance.collection('users').doc(usuario.uid).update({
      'nombre': nombre,
      'email': email,
      'password': password,
      'identificacion': identificacion,
      'fechanacimiento': fechaNacimiento,
      'area': area,
      'telefono': telefono,
      'cargo': cargo,
      'imageUrl': urlImagen
      // Actualiza los demás campos según sea necesario
    }).then((value) {
      // El usuario se actualizó correctamente
      // Puedes mostrar una notificación o redirigir a otra pantalla
    }).catchError((error) {
      // Ocurrió un error al actualizar el usuario
      // Puedes mostrar una notificación de error o manejarlo de otra manera
    });
  }

  static signInWithEmail(
      {String email = '',
      String password = '',
      bool estaCreado = false}) async {
    try {
      late UserCredential? res;
      late Usuario? usuario;
      res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log('resultado del login: ' + res.toString());
      log('Respuesta Firebase:' + res.user.toString());
      usuario = await AuthHelper().cargarUsuarioDeFirebase();
      log('El uid es:' + res.user!.uid);
      log('Ya se cargo usuario de firebase: ' + usuario.toString());
      Future.delayed(
        Duration(seconds: 2),
        () {},
      );
      return usuario;
    } on FirebaseAuthException catch (e) {
      log('Error: ' + e.message! + ' - Codigo: ' + e.code);
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
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Usuario?> signupWithEmail(Usuario usuario) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      final UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: usuario.email!.trim().toLowerCase(),
          password: usuario.password!.trim());

      log('resultado del registro: ' + res.toString());
      usuario.uid = res.user!.uid;
      await _db.collection("users").doc(res.user!.uid).set(usuario.toMap());
      return usuario;
    } on FirebaseAuthException {
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }

  //Funcion Crear usuario

  static crearUsuarioEnFormulario(Usuario usuario) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usuario.email!.trim().toLowerCase(),
              password: usuario.identificacion!.trim());

      User? user = userCredential.user;
      String uid = user!.uid;

      await _db
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(usuario.toMap());
      print('Usuario creado y guardado en Firestore correctamente');
    } catch (e) {
      print('Error al crear el usuario: $e');
    }
  }

  //Funcion Guardar Funcionario

  void guardarUsuarioEnFirestore(String uid, String nombre, String email) {
    FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'email': email,
    }).then((value) {
      print('Usuario guardado en Firestore correctamente');
    }).catchError((error) {
      print('Error al guardar el usuario en Firestore: $error');
    });
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

  Future<bool> checkPasswordMatch(String uid, String contrasena) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection(
              'users') // Reemplaza 'users' por el nombre de tu colección de usuarios
          .doc(uid)
          .get();
      log('validando si es usuario nuevo');
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final password = userData['identificacion']
            as String; // Reemplaza 'password' por el nombre del campo de contraseña en tu documento de usuario

        return password == contrasena;
      } else {
        return false;
      }
    } catch (e) {
      Logger().e('Error checking password match: $e');
      return false;
    }
  }

  Future<Dependencia?> buscarDependenciaUsuarioActual() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final userSnapshot = await FirebaseFirestore.instance
          .collection(
              'users') // Reemplaza 'users' por el nombre de tu colección de usuarios
          .doc(auth.currentUser!.uid)
          .get();

      if (userSnapshot.exists) {
        final Usuario usuario =
            Usuario.mapeo(userSnapshot.data() as Map<String, dynamic>);
        final dependenciaSnapshot = await FirebaseFirestore.instance
            .collection(
                'dependencias') // Reemplaza 'users' por el nombre de tu colección de usuarios
            .doc(usuario.area)
            .get();
        log('Buscando el usuario correspondiente a: ' +
            usuario.area.toString());
        if (dependenciaSnapshot.exists) {
          final Dependencia dependencia = Dependencia.fromMap(
              dependenciaSnapshot.data() as Map<String, dynamic>);
          log('Buscando la dependencia correspondiente a: ' +
              dependencia.uid.toString());
          return dependencia;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      Logger().e('Error al buscar la dependencia del usuario actual: $e');
      return null;
    }
  }

  Future<String> changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
        Get.snackbar('Ajuste realizado', 'Contraseña actualizada exitosamente',
            duration: Duration(seconds: 5),
            margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Color.fromARGB(211, 28, 138, 46),
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            colorText: Color.fromARGB(255, 228, 219, 218));
        return 'ok';
      } else {
        Get.snackbar('Error', 'No ha iniciado sesión',
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
      return 'error';
    } catch (e) {
      Get.snackbar('Error', 'Ocurrio un error al cambiar la contraseña',
          duration: Duration(seconds: 5),
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Color.fromARGB(213, 211, 31, 31),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          colorText: Color.fromARGB(255, 228, 219, 218));
      Logger().e('Error al cambiar la contraseña: $e');
      return 'error';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Correo de restablecimiento enviado correctamente',
          'Siga las instruciones en su correo',
          duration: Duration(seconds: 5),
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Color.fromARGB(211, 28, 138, 46),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          colorText: Color.fromARGB(255, 228, 219, 218));
    } catch (e) {
      Get.snackbar('Error',
          'Ocurrio un error, verifique que el correo este correctamente escrito',
          duration: Duration(seconds: 5),
          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Color.fromARGB(213, 211, 31, 31),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          colorText: Color.fromARGB(255, 228, 219, 218));
      Logger().e('Error resetear la contraseña: $e');
    }
  }
}

class UserHelper {
  Future<List<Usuario>> obtenerUsuarios() async {
    List<Usuario> UsuarioList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    querySnapshot.docs.forEach((doc) {
      Usuario user = Usuario.mapeo(doc.data() as Map<String, dynamic>);
      UsuarioList.add(user);
    });

    return UsuarioList;
  }

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> eliminarFuncionario(String? uid) async {
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('users');
    return usuarios
        .doc(uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> eliminarUsuarioPorUID(String uid) async {
    try {
      final usuariosQuery = FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid);
      final usuariosSnapshots = await usuariosQuery.get();

      for (final usuarioSnapshot in usuariosSnapshots.docs) {
        await usuarioSnapshot.reference.delete();
      }

      print('Usuario eliminado exitosamente');
    } catch (e) {
      print('Error al eliminar el usuario: $e');
    }
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
