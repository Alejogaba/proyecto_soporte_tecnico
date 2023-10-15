import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:login2/auth/firebase_auth/firebase_user_provider.dart';
import 'package:login2/backend/backend.dart';

class Usuario {
  String? fechaNacimiento;
  String? area;
  String? telefono;
  String? cargo;
  String? password;
  String? identificacion;
  String? nombre;
  String? email;
  String? role;
  String? uid;
  String urlImagen =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Empty_set_symbol.svg/640px-Empty_set_symbol.svg.png";
  String? fcmToken;
  Usuario(
      {this.fechaNacimiento = "",
      this.area = "",
      this.telefono = "",
      this.cargo = "",
      this.password = "",
      this.identificacion = "",
      this.nombre = "",
      this.email = "",
      this.role = "",
      this.uid = "",
      this.urlImagen =
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Empty_set_symbol.svg/640px-Empty_set_symbol.svg.png"});

  Usuario.mapeo(Map<String, dynamic> map) {
    fechaNacimiento = map['fechanacimiento'] ?? "";
    area = map['area'] ?? "";
    telefono = map['telefono'] ?? "";
    cargo = map['cargo'] ?? "";
    password = map['password'] ?? "";
    identificacion = map['identificacion'] ?? "";
    nombre = map['nombre'] ?? "";
    email = map['email'] ?? "";
    role = map['role'] ?? "";
    uid = map['uid'] ?? "";
    fcmToken = map['fcmToken'] ?? "";
    urlImagen = map['imageUrl'] ??
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Empty_set_symbol.svg/640px-Empty_set_symbol.svg.png";
  }

  Map<String, dynamic> toMap() {
    return {
      'fechanacimiento': fechaNacimiento,
      'area': area,
      'telefono': telefono,
      'cargo': cargo,
      'password': password,
      'identificacion': identificacion,
      'nombre': nombre,
      'email': email,
      'role': role,
      'uid': uid,
      'imageUrl': urlImagen
    };
  }

  Stream<Usuario>? getUsuarioStreamchatRecords(ChatsRecord? chatsrecords) {
    if (chatsrecords != null) {
      FirebaseAuth auth = FirebaseAuth.instance;
      log('GetUsuarioStream: chatsrecord encontrado');
      log('GetUsuarioStream: usuario actual: ' +
          auth.currentUser!.uid.toString().trim());
      log('GetUsuarioStream: usuario 0: ' + chatsrecords.users[0].trim());
      log('GetUsuarioStream: usuario 1: ' + chatsrecords.users[1].trim());
      late DocumentReference? usuarioRef;
      if (auth.currentUser!.uid.toString().trim() ==
          chatsrecords.users[0].trim()) {
        usuarioRef = FirebaseFirestore.instance
            .collection('users')
            .doc(chatsrecords.users[1].trim());
      } else {
        usuarioRef = FirebaseFirestore.instance
            .collection('users')
            .doc(chatsrecords.users[0].trim());
      }
      log('Usuario escogido: ' + usuarioRef.toString());
      return usuarioRef.snapshots().map((snapshot) {
        if (!snapshot.exists) {
          throw Exception('Usuario no encontrado');
        }
        final data = snapshot.data();
        return Usuario.mapeo(data as Map<String, dynamic>);
      });
    } else {
      return null;
    }
  }
}
