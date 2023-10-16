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
  int? height;
  int? width;
  int? size;
  int? turno;
  String? uri;
  int prioridad;
  String uidRoom;

  ChatMensajes(
      {required this.authorId,
      required this.updatedAt,
      this.mensaje = '',
      this.height = 0,
      this.width = 0,
      this.size = 0,
      this.uri = '',
      this.tipo = '',
      this.turno = 999,
      required this.fechaHora,
      this.prioridad = 1,
      this.uidRoom=''});

  Map<String, dynamic> toMapText() {
    return {
      'authorId': authorId,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'text': mensaje,
      'type': 'text',
      'createdAt': Timestamp.fromDate(fechaHora),
    };
  }

  Map<String, dynamic> toMapImage() {
    return {
      'authorId': authorId,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'name': mensaje,
      'type': 'image',
      'createdAt': Timestamp.fromDate(fechaHora),
      'height': height,
      'width': width,
      'size': size,
      'uri': uri,
    };
  }

  static ChatMensajes fromMap(Map<String, dynamic> map) {
    return ChatMensajes(
      authorId: map['authorId'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      mensaje: map['text'] ?? '',
      tipo: map['type'],
      fechaHora: (map['createdAt'] as Timestamp).toDate(),
      turno: map['turno'],
      prioridad: map['prioridad'] ?? 1,
      uidRoom: map['uid'],
    );
  }

  Future<void> guardarChatMensaje() async {
    await FirebaseFirestore.instance
        .collection('chat_mensajes')
        .add(toMapText());
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
