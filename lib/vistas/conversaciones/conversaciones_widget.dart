import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:logger/logger.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/usuario.dart';

import '../chat/chat_widget.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'conversaciones_model.dart';
export 'conversaciones_model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConversacionesWidget extends StatefulWidget {
  const ConversacionesWidget({Key? key}) : super(key: key);

  @override
  _ConversacionesWidgetState createState() => _ConversacionesWidgetState();
}

class _ConversacionesWidgetState extends State<ConversacionesWidget> {
  late ConversacionesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversacionesModel());
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Todas las conversaciones',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Urbanist',
                color: FlutterFlowTheme.of(context).tertiary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
          child: StreamBuilder<List<ChatsRecord>>(
            stream: queryChatsRecord(
              queryBuilder: (chatsRecord) => chatsRecord
                  .where('userIds', arrayContains: currentUser!.uid)
                  .orderBy('updatedAt', descending: true),
            ),
            builder: (context, snapshot1) {
              Logger().i('El usuario actual es: $currentUser');
              // Customize what your widget looks like when it's loading.
              if (!snapshot1.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                );
              }
              List<ChatsRecord> listViewChatsRecordList = snapshot1.data!;

              if (listViewChatsRecordList.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/images/messagesMainEmpty@2x.png',
                    width: 300.0,
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: listViewChatsRecordList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewChatsRecord =
                      listViewChatsRecordList[listViewIndex];
                  log('listviewChatRecord: $listViewChatsRecord');
                  return StreamBuilder<Usuario>(
                    stream: Usuario().getUsuarioStream(listViewChatsRecord),
                    builder: (context, snapshot) {
                      final Usuario? chatInfo = snapshot.data;
                      log('chatInfo: ${chatInfo}');
                      if (chatInfo != null) {
                        return StreamBuilder<ChatMensajes?>(
                          stream: ControladorChat().ObtenerUltimoMensajeChat(
                              listViewChatsRecord.roomUid),
                          builder:
                              (BuildContext context, snapshotUltimoMensaje) {
                            if (snapshotUltimoMensaje.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshotUltimoMensaje.connectionState !=
                                    ConnectionState.waiting &&
                                snapshot.data == null) {
                              return Center(
                                  child: Text(
                                      'No se han encontrado conversaciones'));
                            } else {
                              final ChatMensajes? lastMessage =
                                  snapshotUltimoMensaje.data;

                              return FFChatPreview(
                                onTap: () async {
                                  Usuario? usuarioActual = await AuthHelper()
                                      .cargarUsuarioDeFirebase();

                                  if (usuarioActual != null) {
                                    try {
                                      await FlutterLocalNotificationsPlugin()
                                          .resolvePlatformSpecificImplementation<
                                              AndroidFlutterLocalNotificationsPlugin>()
                                          ?.requestPermission();
                                    } catch (e) {
                                      log('No se pudo pedir permiso de notificacion: ' +
                                          e.toString());
                                    }
                                    String? token = await FirebaseMessaging
                                        .instance
                                        .getToken();
                                    User? user = getCurrentUser();
                                    if (user != null && token != null) {
                                      var docRef = FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user.uid);
                                      await docRef.update({
                                        'fcmToken': token,
                                      });
                                    }
                                    Logger().i('Id Room: ' +
                                        listViewChatsRecord.roomUid);
                                    if (snapshot.data != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatWidget(
                                              otroUsuario: snapshot.data!,
                                              currentUserToken: token,
                                              otherUserToken:
                                                  snapshot.data!.fcmToken,
                                              nombre:
                                                  '${snapshot.data!.nombre} - ${snapshot.data!.cargo} ${snapshot.data!.area}',
                                              usuarios:
                                                  listViewChatsRecord.users,
                                              uid: listViewChatsRecord.roomUid
                                                  .trim()),
                                        ),
                                      );
                                    }
                                  }
                                },
                                lastChatText: (lastMessage != null)
                                    ? definirUltimoMensaje(
                                        lastMessage.mensaje, lastMessage.tipo)
                                    : " ",
                                lastChatTime:
                                    listViewChatsRecord.lastMessageTime,
                                seen: false,
                                title:
                                    '${snapshot.data!.nombre} - ${snapshot.data!.cargo} ${snapshot.data!.area}',
                                userProfilePic: chatInfo.urlImagen,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                unreadColor:
                                    FlutterFlowTheme.of(context).primary,
                                titleTextStyle: GoogleFonts.getFont(
                                  'Urbanist',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                dateTextStyle: GoogleFonts.getFont(
                                  'Urbanist',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                ),
                                previewTextStyle: GoogleFonts.getFont(
                                  'Urbanist',
                                  color: FlutterFlowTheme.of(context).grayIcon,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 3.0, 8.0, 3.0),
                                borderRadius: BorderRadius.circular(0.0),
                              );
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: Text('Nada que ver aqui'),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String definirUltimoMensaje(String? mensaje, String? tipo) {
    log('Tipo de mensaje es: $tipo');
    if (tipo == null) {
      return '';
    } else if (tipo == 'text') {
      return mensaje != null ? mensaje : '';
    } else if (tipo == 'image') {
      return '🖼 Imagen';
    } else if (tipo == 'file') {
      return '📎 Archivo adjunto';
    } else {
      return tipo;
    }
  }
}
