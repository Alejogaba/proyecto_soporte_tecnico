import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../flutter_flow/chat/chat_page_firebase.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {Key? key,
      this.chatRef,
      required this.usuarios,
      required this.uid,
      required this.nombre,
      required,
      this.currentUserToken, this.otherUserToken})
      : super(key: key);
  final List<String> usuarios;
  final String? currentUserToken;
  final String? otherUserToken;
  final DocumentReference? chatRef;
  final String uid;
  final String nombre;
  @override
  _ChatWidgetState createState() => _ChatWidgetState(usuarios);
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;
  List<String> usuarios;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _ChatWidgetState(this.usuarios);

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
    final List<types.User> users = [
      types.User(id: usuarios[0]),
      types.User(id: usuarios[1])
    ];

    context.watch<FFAppState>();

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
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
            widget.nombre,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Urbanist',
                  color: FlutterFlowTheme.of(context).tertiary,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: ChatPageFirebase(
          nombre: widget.nombre,
          currentUserToken: widget.currentUserToken,
          otherUserToken: widget.otherUserToken,
            chatUid: widget.uid,
            room: types.Room(
                id: widget.uid, type: types.RoomType.direct, users: users)));
  }
}
