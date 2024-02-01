import 'package:flutter/material.dart';
import 'package:login2/flutter_flow/flutter_flow_theme.dart';
import 'package:login2/vistas/chatbot_lista_respuestas/chatbot_Form.dart';
import '../../model/chatBot.dart';

class ChatBotInfo extends StatefulWidget {
  ChatBotInfo({Key? key, required this.chatbot}) : super(key: key);

  final ChatBot chatbot;

  @override
  State<ChatBotInfo> createState() => _ChatBotInfoState(chatbot);
}

class _ChatBotInfoState extends State<ChatBotInfo> {
  _ChatBotInfoState(this.chatbot);

  ChatBot chatbot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text('Respuesta personalizada'),
        actions: [
          IconButton(
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotForm(chatbot: chatbot,)),
                ).then((value) {
                  if (value != null) {
                  setState(() {
                    chatbot = value;
                  });
                }
                });
                
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Intent
              Card(
                elevation: 5.0,
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Pregunta',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Text(
                    chatbot.intent,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),

              // Respuesta
              Card(
                elevation: 5.0,
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Respuesta',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Text(
                    chatbot.respuesta,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
