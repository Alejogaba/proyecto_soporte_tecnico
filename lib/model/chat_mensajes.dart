import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ChatMensajes {
  String authorId;
  DateTime updatedAt;
  String mensaje;
  String tipo;
  DateTime fechaHora;

  ChatMensajes({
    required this.authorId,
    required this.updatedAt,
    required this.mensaje,
    required this.tipo,
    required this.fechaHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'text': mensaje,
      'type': tipo,
      'createdAt': Timestamp.fromDate(fechaHora),
    };
  }

  static ChatMensajes fromMap(Map<String, dynamic> map) {
    return ChatMensajes(
      authorId: map['authorId']??'',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      mensaje: map['text']??'',
      tipo: map['type'],
      fechaHora: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Future<void> guardarChatMensaje() async {
    await FirebaseFirestore.instance.collection('chat_mensajes').add(toMap());
  }

  static Stream<List<ChatMensajes>> obtenerChatMensajes({required String uid}) {
    log('Obteniendo chats');
    dynamic stream = FirebaseFirestore.instance
        .collection('chats')
        .doc(uid)
        .collection('mensajes')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => fromMap(doc.data())).toList())
        .doOnError((p0, p1) {
      p0.printError();
    p1.printError();
    });

    return stream;
  }
}
