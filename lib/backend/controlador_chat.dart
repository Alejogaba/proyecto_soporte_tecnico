import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/usuario.dart';
import 'package:rxdart/rxdart.dart';

class ControladorChat {
  Stream<ChatMensajes?> obtenerUltimoMensajeChat(String uidChat) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(uidChat)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.docs[0].data();
      final result = ChatMensajes.fromMap(data);
      log('ultimo mensaje: $result');
      return result;
    }).doOnError((p0, p1) {
      p0.printError();
      return null;
    });
  }

  Future<ChatMensajes?> obtenerUltimoEnCola(String uidChat) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('finalizado', isEqualTo: false)
          .orderBy('turno', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        final result = ChatMensajes.fromMap(data);
        log('ultimo mensaje: $result');
        return result;
      } else {
        return null; // No se encontraron mensajes
      }
    } catch (e) {
      log('Error al obtener el último mensaje: $e');
      return null;
    }
  }
  
  Future<ChatMensajes?> obtenerUltimoEnColaUrgente(String uidChat) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('finalizado', isEqualTo: false)
          .where('prioridad', isEqualTo: 'Urgencia Crítica')
          .orderBy('turno', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        final result = ChatMensajes.fromMap(data);
        log('ultimo mensaje: $result');
        return result;
      } else {
        return null; // No se encontraron mensajes
      }
    } catch (e) {
      log('Error al obtener el último mensaje: $e');
      return null;
    }
  }

  Future<int> primerMensaje(String roomUID) async {
    Usuario? usuarioActual = await AuthHelper().cargarUsuarioDeFirebase();
    if (usuarioActual != null && usuarioActual.role == 'admin') {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomUID)
            .collection('messages')
            .where('authorId', isEqualTo: usuarioActual.uid.toString().trim())
            .get();

        int count = querySnapshot.size;
        return count;
      } catch (e) {
        // Maneja aquí los errores según sea necesario
        print('error al contar mensajes: ' + e.toString());
        return 1;
      }
    } else {
      return 1;
    }
  }

  Stream<ChatMensajes?> obtenerPuestoEnColaById(String uidUsuario) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContains: uidUsuario.trim())
        .orderBy('turno', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.docs[0].data();
      final result = ChatMensajes.fromMap(data);
      log('ultimo mensaje: $result');
      return result;
    }).doOnError((p0, p1) {
      p0.printError();
      return null;
    });
  }
  Future<ChatMensajes?> obtenerPuestoEnColaByIdFuture(String uidUsuario) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContains: uidUsuario.trim())
        .orderBy('turno', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs[0].data();
      final result = ChatMensajes.fromMap(data);
      debugPrint('ultimo mensaje: $result'); // Utiliza debugPrint en lugar de log para imprimir mensajes en la consola durante el desarrollo
      return result;
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Error: $e'); // Utiliza debugPrint en lugar de log para imprimir mensajes en la consola durante el desarrollo
    return null;
  }
}

  Future<void> disminuirTurno() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('resuelto', isEqualTo: false)
        .get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      int turno = document.get('turno') ?? 0;
      await document.reference.update({'turno': turno - 1});
    }
  }

  Future<void> aumentarTurno() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('resuelto', isEqualTo: false)
        .where('prioridad', isNotEqualTo: 'Urgencia Crítica')
        .get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      int turno = document.get('turno') ?? 0;
      await document.reference.update({'turno': turno + 1});
    }
  }

  Future<String?> buscarChat(
      String uidusuarioAdmin, String uidOtroUsuario) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('userIds', isEqualTo: [uidOtroUsuario, uidusuarioAdmin])
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        final docSnapshot = querySnapshot.docs[0];
        final uid = docSnapshot.data()['uid'];
        Logger().i('uid de la Room: $uid');
        return uid;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar room: $e');
      return null;
    }
  }

  Future<List<ChatMensajes>> obetnerRoomsSinFinalizar({String uidSolicitante = ''}) async {
    QuerySnapshot querySnapshot;

    if (uidSolicitante.isEmpty) {
      querySnapshot =
          await FirebaseFirestore.instance.collection('casos').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('casos')
          .where('finalizado', isEqualTo: false)
          .where('prioridad', isNotEqualTo: 'Urgencia Crítica')
          .get();
    }

    List<ChatMensajes> rooms = querySnapshot.docs
        .map((doc) => ChatMensajes.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return rooms;
  }

  Future<String> removerConversacionesRepetidas(String roomUID, String userUID) async {
  try {
    ChatMensajes? chatMensajes = await obtenerUltimoEnCola(userUID);
    if (chatMensajes != null) {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db
          .collection("rooms")
          .where('uid', isNotEqualTo: roomUID)
          .where('turno', isEqualTo: chatMensajes.turno)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      return 'ok';
    } else {
      return 'No chatMensajes found';
    }
  } catch (e) {
    // Aquí puedes manejar el error según sea necesario
    return 'error';
  }
}

}
