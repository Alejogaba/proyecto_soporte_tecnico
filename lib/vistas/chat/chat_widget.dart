import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/chatBot.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/model/usuario.dart';
import 'package:login2/vistas/lista_reportes/lista_reportes_widget.dart';
import '../../backend/controlador_chat.dart';
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

  final Activo? activo;
  final Caso? caso;
  final DocumentReference? chatRef;
  final String? currentUserToken;
  final Dependencia? dependencia;
  final bool esAdmin;
  final ChatMensajes? mensajeImagen;
  final String? msjChatBot;
  final String nombre;
  final String? otherUserToken;
  final Usuario otroUsuario;
  final String uid;
  final List<String> usuarios;

  @override
  _ChatWidgetState createState() => _ChatWidgetState(usuarios);
}

class _ChatWidgetState extends State<ChatWidget> {
  _ChatWidgetState(this.usuarios);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> usuarios;

  late ChatModel _model;

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());
  }

  @override
  Widget build(BuildContext contextPrincipal) {
    final List<types.User> users = [
      types.User(id: usuarios[0]),
      types.User(id: usuarios[1])
    ];

    contextPrincipal.watch<FFAppState>();

    return Scaffold(
        key: scaffoldKey,
        backgroundColor:
            FlutterFlowTheme.of(contextPrincipal).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(contextPrincipal).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(contextPrincipal).tertiary,
              size: 30.0,
            ),
            onPressed: () async {
              Navigator.pop(contextPrincipal);
            },
          ),
          title: Text(
            widget.nombre,
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(contextPrincipal).titleMedium.override(
                  fontFamily: 'Urbanist',
                  color: FlutterFlowTheme.of(contextPrincipal).tertiary,
                ),
          ),
          actions: [
            StreamBuilder<int>(
                stream: widget.esAdmin
                    ? CasosController().getTotalCasosCountSolicitante(
                        widget.otroUsuario.uid!.trim())
                    : CasosController()
                        .getTotalCasosCountSolicitante(usuarios[0]),
                builder: (contextStream, snapshot) {
                  if (snapshot.hasData && snapshot.data != 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: badges.Badge(
                        position: badges.BadgePosition.topEnd(top: 0, end: 0),
                        showBadge: true,
                        ignorePointer: false,
                        onTap: () {
                          print('Abrir lista reportes');
                        },
                        badgeContent: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(snapshot.data.toString(),
                              style: FlutterFlowTheme.of(contextStream)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(contextStream)
                                        .tertiary,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w900,
                                  )),
                        ),
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
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                          elevation: 0,
                        ),
                        child: PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                              value: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ListaReportesWidget(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, bottom: 2),
                                        child: Icon(Icons.warning_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .error),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          'Ver Reportes'.maybeHandleOverflow(
                                            maxChars: 40,
                                            replacement: '…',
                                          ),
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Urbanist',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500,
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
                              enabled: false,
                              child: InkWell(
                                onTap: () {
                                  final snackBar = SnackBar(
                                    showCloseIcon: true,
                                    closeIconColor:
                                        FlutterFlowTheme.of(context).tertiary,
                                    clipBehavior: Clip.antiAlias,
                                    dismissDirection:
                                        DismissDirection.endToStart,
                                    content:
                                        Text('Todavia hay casos pendientes'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, bottom: 2),
                                        child: Icon(
                                            Icons.delete_forever_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .primary),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          'Eliminar conversación'
                                              .maybeHandleOverflow(
                                            maxChars: 40,
                                            replacement: '…',
                                          ),
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Urbanist',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data.toString() == '0') {
                    return PopupMenuButton(
                      itemBuilder: (BuildContext contextMenu) =>
                          <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                contextMenu,
                                MaterialPageRoute(
                                  builder: (context) => ListaReportesWidget(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, bottom: 2),
                                    child: Icon(Icons.warning_rounded,
                                        color: FlutterFlowTheme.of(contextMenu)
                                            .grayIcon),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(
                                      'Sin reportes pendientes'
                                          .maybeHandleOverflow(
                                        maxChars: 40,
                                        replacement: '…',
                                      ),
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(contextMenu)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color:
                                                FlutterFlowTheme.of(contextMenu)
                                                    .grayIcon,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500,
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
                          enabled: true,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(contextPrincipal);
                              Navigator.pop(contextPrincipal,2);
                            },
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, bottom: 2),
                                    child: Icon(Icons.delete_forever_outlined,
                                        color: FlutterFlowTheme.of(contextMenu)
                                            .primaryText),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(
                                      'Eliminar conversación'
                                          .maybeHandleOverflow(
                                        maxChars: 40,
                                        replacement: '…',
                                      ),
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(contextMenu)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color:
                                                FlutterFlowTheme.of(contextMenu)
                                                    .primaryText,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
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
          esAdmin: widget.esAdmin,
        ));
  }
}
