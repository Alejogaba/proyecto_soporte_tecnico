import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/model/usuario.dart';
import 'package:login2/vistas/lista_reportes/lista_reportes_widget.dart';
import '../../flutter_flow/chat/chat_page_firebase.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';
import 'package:badges/badges.dart' as badges;

class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {Key? key,
      this.chatRef,
      required this.usuarios,
      required this.uid,
      required this.nombre,
      required,
      this.esAdmin = false,
      this.currentUserToken,
      this.otherUserToken,
      required this.otroUsuario,
      this.msjChatBot,
      this.caso,
      this.mensajeImagen,
      this.activo,
      this.dependencia})
      : super(key: key);
  final List<String> usuarios;
  final String? currentUserToken;
  final String? otherUserToken;
  final DocumentReference? chatRef;
  final String uid;
  final String nombre;
  final bool esAdmin;
  final Usuario otroUsuario;
  final String? msjChatBot;
  final Caso? caso;
  final ChatMensajes? mensajeImagen;
  final Activo? activo;
  final Dependencia? dependencia;
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
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Urbanist',
                  color: FlutterFlowTheme.of(context).tertiary,
                ),
          ),
          actions: [
            if (widget.esAdmin)
              StreamBuilder<int>(
                  stream: CasosController().getTotalCasosCountSolicitante(
                      widget.otroUsuario.uid!.trim()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != 0) {
                      return PopupMenuButton(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 0,
                            child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaReportesWidget(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              badges.Badge(
                                position: badges.BadgePosition.topEnd(
                                    top: -10, end: -12),
                                showBadge: true,
                                ignorePointer: false,
                                onTap: () {
                                  print('Abrir lista reportes');
                                },
                                badgeContent: Text(snapshot.data.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        )),
                                badgeAnimation: badges.BadgeAnimation.fade(
                                  animationDuration: Duration(seconds: 2),
                                  loopAnimation: true,
                                  curve: Curves.fastEaseInToSlowEaseOut,
                                  colorChangeAnimationCurve: Curves.easeInCubic,
                                ),
                                badgeStyle: badges.BadgeStyle(
                                  shape: badges.BadgeShape.circle,
                                  badgeColor: Colors.redAccent,
                                  padding: EdgeInsets.all(5),
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Colors.redAccent, width: 2),
                                  elevation: 0,
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Reportes'.maybeHandleOverflow(
                                      maxChars: 90,
                                      replacement: '…',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: Text('Option 2'),
                          ),
                        ],
                      );
                      
                    } else if (snapshot.hasData &&
                        snapshot.data.toString() == '0') {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            'Sin reportes pendientes'.maybeHandleOverflow(
                              maxChars: 90,
                              replacement: '…',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: FlutterFlowTheme.of(context).grayIcon,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        !(snapshot.hasData)) {
                      return Container();
                    } else {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: ChatPageFirebase(
          nombre: widget.nombre,
          currentUserToken: widget.currentUserToken,
          otherUserToken: widget.otherUserToken,
          chatUid: widget.uid,
          room: types.Room(
              id: widget.uid, type: types.RoomType.direct, users: users),
          msjChatBot: widget.msjChatBot,
          otroUsuario: widget.otroUsuario,
          caso: widget.caso,
          mensajeImagen: widget.mensajeImagen,
          activo: widget.activo,
          dependencia: widget.dependencia,
        ));
  }
}
