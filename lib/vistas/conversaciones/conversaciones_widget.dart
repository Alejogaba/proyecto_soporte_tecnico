import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:logger/logger.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/backend/controlador_dependencias.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/model/usuario.dart';

import '../../backend/controlador_caso.dart';
import '../chat/chat_widget.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'conversaciones_model.dart';
export 'conversaciones_model.dart';
import 'package:badges/badges.dart' as badges;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConversacionesWidget extends StatefulWidget {
  const ConversacionesWidget({Key? key}) : super(key: key);

  @override
  _ConversacionesWidgetState createState() => _ConversacionesWidgetState();
}

class _ConversacionesWidgetState extends State<ConversacionesWidget> {
  late ConversacionesModel _model;
  bool _esAdmin = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    esAdmin();
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
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
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
      body: Stack(
        children: [
          if(!_esAdmin)
          StreamBuilder<ChatMensajes?>(
              stream: ControladorChat()
                  .obtenerPuestoEnColaById(auth.currentUser!.uid),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  log(auth.currentUser!.uid);
                  return Expanded(
                      child: Container(
                    color: FlutterFlowTheme.of(context).primary.withAlpha(70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 2, 5),
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: (snapshot.data!.turno != null &&
                                      snapshot.data!.turno == 1)
                                  ? FlutterFlowTheme.of(context).primary
                                  : Color.fromARGB(255, 43, 96, 112),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: retornarTexto(snapshot.data!.turno),
                          ),
                        ),
                      ],
                    ),
                  ));
                } else {
                  return Container();
                }
              }),
          SafeArea(
            top: true,
            child: Padding(
              padding: _esAdmin
                  ? EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0)
                  : EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
              child: StreamBuilder<List<ChatsRecord>>(
                stream: queryChatsRecord(
                  queryBuilder: (chatsRecord) => chatsRecord
                      .where('userIds', arrayContains: currentUser!.uid.trim())
                      .orderBy('createdAt', descending: true),
                ),
                builder: (context, snapshot1) {
                  log('currentUser: ' + currentUser!.uid.trim());
                  
                  // Customize what your widget looks like when it's loading.
                  if (!(snapshot1.hasData)) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }else{
                    List<ChatsRecord> listViewChatsRecordList = snapshot1.data!;
                    log('currentUser: ' + snapshot1.data!.length.toString());
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
                    
                      log('listviewChatRecord: ${listViewChatsRecord.roomUid}');
                      return StreamBuilder<Usuario>(
                        stream: Usuario()
                            .getUsuarioStreamchatRecords(listViewChatsRecord),
                        builder: (context, snapshot) {
                          final Usuario? chatInfo = snapshot.data;
                          log('chatInfo: ${chatInfo}');
                          if (chatInfo != null) {
                            return StreamBuilder<ChatMensajes?>(
                              stream: ControladorChat()
                                  .obtenerUltimoMensajeChat(
                                      listViewChatsRecord.roomUid),
                              builder: (BuildContext context,
                                  snapshotUltimoMensaje) {
                                if (snapshotUltimoMensaje.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          )),
                                    ),
                                  );
                                } else if (snapshotUltimoMensaje
                                            .connectionState !=
                                        ConnectionState.waiting &&
                                    snapshotUltimoMensaje.data == null) {
                                  return Center(
                                      child: Text(
                                          'No se han encontrado conversaciones'));
                                } else {
                                  final ChatMensajes? lastMessage =
                                      snapshotUltimoMensaje.data;
                                  return StreamBuilder<ChatMensajes?>(
                                      stream: ControladorChat().obtenerRoom(
                                          listViewChatsRecord.roomUid),
                                      builder:
                                          (BuildContext context, snaphotRoom) {
                                        if (snaphotRoom.data != null) {
                                          log('room turno: ' +
                                              snaphotRoom.data!.uidRoom
                                                  .toString());
                                          return tarjetaChat(
                                              snapshot,
                                              auth,
                                              listViewChatsRecord,
                                              lastMessage,
                                              chatInfo,
                                              room: snaphotRoom.data);
                                        } else {
                                          return tarjetaChat(
                                              snapshot,
                                              auth,
                                              listViewChatsRecord,
                                              lastMessage,
                                              chatInfo);
                                        }
                                      });
                                }
                              },
                            );
                          } else {
                            return Center(
                              child: Text(''),
                            );
                          }
                        },
                      );
                    },
                  );
                  }
                  
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<int> tarjetaChat(
      AsyncSnapshot<Usuario> snapshot,
      FirebaseAuth auth,
      ChatsRecord listViewChatsRecord,
      ChatMensajes? lastMessage,
      Usuario chatInfo,
      {ChatMensajes? room}) {
    if (room != null && room.turno != null && room.prioridad) {
      return StreamBuilder<int>(
          stream: CasosController().getTotalCasosCountSolicitante(
              snapshot.data!.uid.toString().trim()),
          builder: (context, snapshotCountCasos) {
            if (snapshotCountCasos.hasData) {
              return FutureBuilder<Dependencia?>(
                future: ControladorDependencias()
                    .cargarDependenciaUID(snapshot.data!.area!),
                builder: (BuildContext context, snapshotDependencia) {
                  if (snapshotDependencia.connectionState ==
                          ConnectionState.done &&
                      snapshotDependencia.data != null) {
                    return badges.Badge(
                      position: badges.BadgePosition.topStart(top: 3, start: 3),
                      showBadge: true,
                      ignorePointer: false,
                      onTap: () {},
                      badgeContent: Text(_esAdmin ? '#${room.turno} ¡Urgente!':'¡Urgente!',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      badgeAnimation: badges.BadgeAnimation.fade(
                        animationDuration: Duration(seconds: 2),
                        colorChangeAnimationDuration: Duration(seconds: 5),
                        loopAnimation: true,
                        curve: Curves.fastOutSlowIn,
                        colorChangeAnimationCurve: Curves.easeInCubic,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.square,
                        badgeColor: Colors.red,
                        padding: EdgeInsets.all(2),
                        borderRadius: BorderRadius.circular(2),
                        elevation: 1,
                      ),
                      child: FFChatPreview(
                        onTap: () async {
                          Usuario? usuarioActual =
                              await AuthHelper().cargarUsuarioDeFirebase();

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
                            String? token =
                                await FirebaseMessaging.instance.getToken();

                            Usuario? usuarioActual =
                                await AuthHelper().cargarUsuarioDeFirebase();
                            if (auth.currentUser != null && token != null) {
                              var docRef = FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(auth.currentUser!.uid);
                              await docRef.update({
                                'fcmToken': token,
                              });
                            }
                            Logger()
                                .i('Id Room: ' + listViewChatsRecord.roomUid);
                            if (snapshot.data != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatWidget(
                                      otroUsuario: snapshot.data!,
                                      currentUserToken: token,
                                      otherUserToken: snapshot.data!.fcmToken,
                                      nombre: (snapshot.data != null &&
                                              snapshot.data!.nombre ==
                                                  'Asistente Virtual')
                                          ? '${snapshot.data!.nombre}'
                                          : '${snapshot.data!.nombre} - ${snapshot.data!.cargo} de ${snapshotDependencia.data!.nombre}',
                                      usuarios: listViewChatsRecord.users,
                                      esAdmin: usuarioActual!.role == 'admin',
                                      uid: listViewChatsRecord.roomUid.trim()),
                                ),
                              );
                            }
                          }
                        },
                        lastChatText: (lastMessage != null)
                            ? definirUltimoMensaje(
                                lastMessage.mensaje, lastMessage.tipo)
                            : " ",
                        lastChatTime: listViewChatsRecord.lastMessageTime,
                        seen: room.finalizado,
                        title: (snapshot.data != null &&
                                snapshot.data!.nombre == 'Asistente Virtual')
                            ? '${snapshot.data!.nombre}'
                            : '${snapshot.data!.nombre} - ${snapshot.data!.cargo} de ${snapshotDependencia.data!.nombre}',
                        userProfilePic: chatInfo.urlImagen,
                        color: (room.finalizado)
                            ? FlutterFlowTheme.of(context).secondaryBackground
                            : FlutterFlowTheme.of(context).accent3,
                        unreadColor: Colors.green,
                        titleTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: (!room.finalizado)
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withAlpha(150),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        dateTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: (!room.finalizado)
                              ? FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withAlpha(200)
                              : FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                        previewTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: (!room.finalizado)
                              ? FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withAlpha(180)
                              : FlutterFlowTheme.of(context).grayIcon,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    );
                  } else {
                    return Text(
                      '',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Urbanist',
                            color: FlutterFlowTheme.of(context).tertiary,
                          ),
                    );
                  }
                },
              );
            } else {
              return Text('');
            }
          });
    } else if (_esAdmin && room != null && room.turno != null) {
      return StreamBuilder<int>(
          stream: CasosController().getTotalCasosCountSolicitante(
              snapshot.data!.uid.toString().trim()),
          builder: (context, snapshotCountCasos) {
            log('Streambuilder turno:' + room.turno.toString());
            if (snapshotCountCasos.hasData) {
              return FutureBuilder<Dependencia?>(
                future: ControladorDependencias()
                    .cargarDependenciaUID(snapshot.data!.area!),
                builder: (BuildContext context, snapshotDependencia) {
                  if (snapshotDependencia.connectionState ==
                          ConnectionState.done &&
                      snapshotDependencia.data != null) {
                    return badges.Badge(
                      position: badges.BadgePosition.topStart(top: 3, start: 3),
                      showBadge: true,
                      ignorePointer: false,
                      onTap: () {},
                      badgeContent: Text('#${room.turno}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      badgeAnimation: badges.BadgeAnimation.fade(
                        animationDuration: Duration(seconds: 2),
                        colorChangeAnimationDuration: Duration(seconds: 5),
                        loopAnimation: false,
                        curve: Curves.fastOutSlowIn,
                        colorChangeAnimationCurve: Curves.easeInCubic,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.square,
                        badgeColor: FlutterFlowTheme.of(context).primary,
                        padding: EdgeInsets.all(2),
                        borderRadius: BorderRadius.circular(2),
                        elevation: 1,
                      ),
                      child: FFChatPreview(
                        onTap: () async {
                          Usuario? usuarioActual =
                              await AuthHelper().cargarUsuarioDeFirebase();

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
                            String? token =
                                await FirebaseMessaging.instance.getToken();

                            Usuario? usuarioActual =
                                await AuthHelper().cargarUsuarioDeFirebase();
                            if (auth.currentUser != null && token != null) {
                              var docRef = FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(auth.currentUser!.uid);
                              await docRef.update({
                                'fcmToken': token,
                              });
                            }
                            Logger()
                                .i('Id Room: ' + listViewChatsRecord.roomUid);
                            if (snapshot.data != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatWidget(
                                      otroUsuario: snapshot.data!,
                                      currentUserToken: token,
                                      otherUserToken: snapshot.data!.fcmToken,
                                      nombre: (snapshot.data != null &&
                                              snapshot.data!.nombre ==
                                                  'Asistente Virtual')
                                          ? '${snapshot.data!.nombre}'
                                          : '${snapshot.data!.nombre} - ${snapshot.data!.cargo} de ${snapshotDependencia.data!.nombre}',
                                      usuarios: listViewChatsRecord.users,
                                      esAdmin: usuarioActual!.role == 'admin',
                                      uid: listViewChatsRecord.roomUid.trim()),
                                ),
                              );
                            }
                          }
                        },
                        lastChatText: (lastMessage != null)
                            ? definirUltimoMensaje(
                                lastMessage.mensaje, lastMessage.tipo)
                            : " ",
                        lastChatTime: listViewChatsRecord.lastMessageTime,
                        seen: (!room.finalizado) ? false : true,
                        title: (snapshot.data != null &&
                                snapshot.data!.nombre == 'Asistente Virtual')
                            ? '${snapshot.data!.nombre}'
                            : '${snapshot.data!.nombre} - ${snapshot.data!.cargo} de ${snapshotDependencia.data!.nombre}',
                        userProfilePic: chatInfo.urlImagen,
                        color: (!room.finalizado)
                            ? FlutterFlowTheme.of(context).secondaryBackground
                            : FlutterFlowTheme.of(context).accent3,
                        unreadColor: Colors.green,
                        titleTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: (!room.finalizado)
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withAlpha(150),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        dateTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: (!room.finalizado)
                              ? FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withAlpha(200)
                              : FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                        previewTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: (!room.finalizado)
                              ? FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withAlpha(180)
                              : FlutterFlowTheme.of(context).grayIcon,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    );
                  } else {
                    return Text(
                      '',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Urbanist',
                            color: FlutterFlowTheme.of(context).tertiary,
                          ),
                    );
                  }
                },
              );
            } else {
              return Text('');
            }
          });
    } else {
      return StreamBuilder<int>(
          stream: CasosController().getTotalCasosCountSolicitante(
              snapshot.data!.uid.toString().trim()),
          builder: (context, snapshotCountCasos) {
            if (snapshotCountCasos.hasData) {
              return FutureBuilder<Dependencia?>(
                future: ControladorDependencias()
                    .cargarDependenciaUID(snapshot.data!.area!),
                builder: (BuildContext context, snapshotDependencia) {
                  if (snapshotDependencia.connectionState ==
                          ConnectionState.done &&
                      snapshotDependencia.data != null) {
                    return FFChatPreview(
                      onTap: () async {
                        Usuario? usuarioActual =
                            await AuthHelper().cargarUsuarioDeFirebase();

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
                          String? token =
                              await FirebaseMessaging.instance.getToken();

                          Usuario? usuarioActual =
                              await AuthHelper().cargarUsuarioDeFirebase();
                          if (auth.currentUser != null && token != null) {
                            var docRef = FirebaseFirestore.instance
                                .collection("users")
                                .doc(auth.currentUser!.uid);
                            await docRef.update({
                              'fcmToken': token,
                            });
                          }
                          Logger().i('Id Room: ' + listViewChatsRecord.roomUid);
                          if (snapshot.data != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatWidget(
                                    otroUsuario: snapshot.data!,
                                    currentUserToken: token,
                                    otherUserToken: snapshot.data!.fcmToken,
                                    nombre: (snapshot.data != null &&
                                            snapshot.data!.nombre ==
                                                'Asistente Virtual')
                                        ? '${snapshot.data!.nombre}'
                                        : '${snapshot.data!.nombre} - ${snapshot.data!.cargo} de ${snapshotDependencia.data!.nombre}',
                                    usuarios: listViewChatsRecord.users,
                                    esAdmin: usuarioActual!.role == 'admin',
                                    uid: listViewChatsRecord.roomUid.trim()),
                              ),
                            );
                          }
                        }
                      },
                      lastChatText: (lastMessage != null)
                          ? definirUltimoMensaje(
                              lastMessage.mensaje, lastMessage.tipo)
                          : " ",
                      lastChatTime: listViewChatsRecord.lastMessageTime,
                      seen: (snapshotCountCasos.data! < 0) ? false : true,
                      title: (snapshot.data != null &&
                              snapshot.data!.nombre == 'Asistente Virtual')
                          ? '${snapshot.data!.nombre}'
                          : '${snapshot.data!.nombre} - ${snapshot.data!.cargo} de ${snapshotDependencia.data!.nombre}',
                      userProfilePic: chatInfo.urlImagen,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      unreadColor: Colors.green,
                      titleTextStyle: GoogleFonts.getFont(
                        'Urbanist',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      dateTextStyle: GoogleFonts.getFont(
                        'Urbanist',
                        color: FlutterFlowTheme.of(context)
                            .primaryText
                            .withAlpha(200),
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                      previewTextStyle: GoogleFonts.getFont(
                        'Urbanist',
                        color: FlutterFlowTheme.of(context)
                            .primaryText
                            .withAlpha(180),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
                      borderRadius: BorderRadius.circular(0.0),
                    );
                  } else {
                    return Text(
                      '',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Urbanist',
                            color: FlutterFlowTheme.of(context).tertiary,
                          ),
                    );
                  }
                },
              );
            } else {
              return Text('');
            }
          });
    }
  }

  Widget retornarTexto(int? result) {
    if (result != null) {
      switch (result) {
        case 1:
          return AutoSizeText(
            'Eres el primero en la fila, en un instante te atenderán.',
            style: TextStyle(
                fontSize: 14.5,
                color: const Color.fromARGB(255, 36, 105, 38),
                fontWeight: FontWeight.bold),
          );

        case 2:
          return AutoSizeText(
            'Eres el segundo en la fila, por favor, espera un momento...',
            style: TextStyle(
                fontSize: 14.5,
                color: Color.fromARGB(255, 35, 96, 107),
                fontWeight: FontWeight.bold),
          );

        case 3:
          return AutoSizeText(
            'Eres el tercero en la fila, por favor, aguarde su turno...',
            style: TextStyle(
                fontSize: 14.5,
                color: Color.fromARGB(255, 43, 96, 112),
                fontWeight: FontWeight.bold),
          );

        default:
          return AutoSizeText(
            'Eres el #$result en la fila, por favor, espera tu turno.',
            style: TextStyle(
                fontSize: 14.5,
                color: Color.fromARGB(255, 25, 62, 73),
                fontWeight: FontWeight.bold),
          );
      }
    } else {
      return Text(
        '...',
        style: TextStyle(
            fontSize: 14.5,
            color: Color.fromARGB(255, 25, 62, 73),
            fontWeight: FontWeight.bold),
      );
    }
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

  esAdmin() async {
    Usuario? usuarioActual = await AuthHelper().cargarUsuarioDeFirebase();
    if (usuarioActual != null && usuarioActual.role == 'admin') {
      setState(() {
        _esAdmin = true;
      });
    }
  }
}
