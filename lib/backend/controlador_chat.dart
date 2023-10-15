import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/model/chat_mensajes.dart';
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
        .doc(uidChat)
        .collection('messages').where('finalizado', isEqualTo: false)
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
}
