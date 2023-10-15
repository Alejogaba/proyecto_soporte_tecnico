class ChatBot {
  int id;
  String respuesta;

  ChatBot({required this.id, required this.respuesta});

  factory ChatBot.fromJson(Map<String, dynamic> json) {
    return ChatBot(
      id: json['id'] as int,
      respuesta: json['respuesta'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['respuesta'] = this.respuesta;
    return data;
  }
}
