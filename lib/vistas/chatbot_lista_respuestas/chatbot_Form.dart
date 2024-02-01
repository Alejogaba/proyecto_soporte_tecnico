import 'package:flutter/material.dart';
import 'package:login2/backend/controlador_chat.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/chatBot.dart';

class ChatBotForm extends StatefulWidget {
  const ChatBotForm({Key? key, this.chatbot}) : super(key: key);

  final ChatBot? chatbot;
  @override
  State<ChatBotForm> createState() => _ChatBotFormState();
}

class _ChatBotFormState extends State<ChatBotForm> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _intentController = TextEditingController();
  final TextEditingController _respuestaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ChatBot chatbot = ChatBot();

  @override
  void initState() {
    super.initState();
    if (widget.chatbot != null) {
      _intentController.text = widget.chatbot!.intent;
      _respuestaController.text = widget.chatbot!.respuesta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text('Crear respuesta personalizada'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            
            if (widget.chatbot != null) {
            chatbot = ChatBot(
                uid: widget.chatbot!.uid,
                intent: _intentController.text,
                respuesta: _respuestaController.text,
              );
            } else {
              chatbot = ChatBot(
                intent: _intentController.text,
                respuesta: _respuestaController.text,
              );
            }

            await ControladorChat().addModChatBotRespuesta(chatbot);
            // Cierra la ventana
            Navigator.of(context).pop(chatbot);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Intent

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: TextFormField(
                          onChanged: (value) async {},
                          controller: _intentController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Pregunta',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
                                ),
                            hintText:
                                'Escriba la pregunta o palabra clave a la que respondera el ChatBot',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                      fontSize: 16.0,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                  ),
                          maxLines: 3,
                          minLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No deje este campo vacio';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Respuesta
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: TextFormField(
                          onChanged: (value) async {},
                          controller: _respuestaController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Respuesta',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
                                ),
                            hintText: 'Respuesta',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                      fontSize: 16.0,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          textAlignVertical: TextAlignVertical.top,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                  ),
                          maxLines: 10,
                          minLines: 6,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No deje este campo vacio';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
