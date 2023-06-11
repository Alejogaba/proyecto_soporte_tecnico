import 'package:login2/model/chat_mensajes.dart';

import '../model/usuario.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    Key? key,
    this.chatRef, required this.usuarioActual, required this.uid,
    
  }) : super(key: key);
  final Usuario usuarioActual;

  final DocumentReference? chatRef;
  final String uid;
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
 

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

   
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).dark600,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).tertiary,
            size: 30.0,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.usuarioActual.nombre!,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Urbanist',
                color: FlutterFlowTheme.of(context).tertiary,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: StreamBuilder<List<ChatMensajes>>(
          stream: ChatMensajes.obtenerChatMensajes(uid: widget.uid),
          builder: (context, snapshot) => snapshot.hasData
              ? FFChatPage(
                  currentUsuario: widget.usuarioActual,
                  allowImages: true,
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  timeDisplaySetting: TimeDisplaySetting.alwaysVisible,
                  currentUserBoxDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  otherUsersBoxDecoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  currentUserTextStyle: GoogleFonts.getFont(
                    'Lexend Deca',
                    color: Color(0xFF1E2429),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    fontStyle: FontStyle.normal,
                  ),
                  otherUsersTextStyle: GoogleFonts.getFont(
                    'Lexend Deca',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                  inputHintTextStyle: GoogleFonts.getFont(
                    'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                  inputTextStyle: GoogleFonts.getFont(
                    'Lexend Deca',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                  emptyChatWidget: Center(
                    child: Image.asset(
                      'assets/images/messagesEmpty@2x.png',
                      width: 300.0,
                    ),
                  ), chatMensajes: snapshot.data!,
                )
              : Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
