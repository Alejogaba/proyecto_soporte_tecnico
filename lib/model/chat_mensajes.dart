import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMensajes {
  String usuarioA;
  String usuarioB;
  String mensaje;
  String tipo;
  DateTime fechaHora;

  ChatMensajes({
    required this.usuarioA,
    required this.usuarioB,
    required this.mensaje,
    required this.tipo,
    required this.fechaHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario_a': usuarioA,
      'usuario_b': usuarioB,
      'mensaje': mensaje,
      'tipo': tipo,
      'fecha_hora': Timestamp.fromDate(fechaHora),
    };
  }

  static ChatMensajes fromMap(Map<String, dynamic> map) {
    return ChatMensajes(
      usuarioA: map['usuario_a'],
      usuarioB: map['usuario_b'],
      mensaje: map['mensaje'],
      tipo: map['tipo'],
      fechaHora: (map['fecha_hora'] as Timestamp).toDate(),
    );
  }

  Future<void> guardarChatMensaje() async {
    await FirebaseFirestore.instance
        .collection('chat_mensajes')
        .add(toMap());
  }

  static Stream<List<ChatMensajes>> obtenerChatMensajes({required String uid}) {
    return FirebaseFirestore.instance
        .collection('chats').doc(uid).collection('mensajes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => fromMap(doc.data())).toList());
  }
}
