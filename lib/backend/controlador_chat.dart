import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:rxdart/rxdart.dart';

class ControladorChat {
  Stream<ChatMensajes?> ObtenerUltimoMensajeChat(String uidChat) {
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
    });
  }
}
