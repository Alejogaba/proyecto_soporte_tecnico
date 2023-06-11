import 'dart:developer';

import 'package:login2/auth/firebase_auth/firebase_user_provider.dart';
import 'package:login2/backend/backend.dart';

class Usuario {
  String? funcionarioImage;
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
      {this.funcionarioImage = "",
      this.fechaNacimiento = "",
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
    funcionarioImage = map['FuncionarioImage'] ?? "";
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
      'FuncionarioImage': funcionarioImage,
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

  Stream<Usuario>? getUsuarioStream(ChatsRecord? chatsrecords) {
    if (chatsrecords != null) {
      late DocumentReference? usuarioRef;
      if (getCurrentUser()!.uid.toString().trim() == chatsrecords.users[0]) {
        usuarioRef = FirebaseFirestore.instance
            .collection('users')
            .doc(chatsrecords.users[1]);
      } else {
        usuarioRef = FirebaseFirestore.instance
            .collection('users')
            .doc(chatsrecords.users[0]);
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
