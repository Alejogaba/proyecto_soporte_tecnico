import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/model/usuario.dart';

import '/chat/chat_widget.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'conversaciones_model.dart';
export 'conversaciones_model.dart';

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
                  .where('users', arrayContains: currentUserReference)
                  .orderBy('last_message_time', descending: true),
            ),
            builder: (context, snapshot1) {
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
                  return StreamBuilder<Usuario>(
                    stream: Usuario().getUsuarioStream(listViewChatsRecord),
                    builder: (context, snapshot) {
                      final Usuario chatInfo = snapshot.data ?? Usuario();

                      return FFChatPreview(
                        onTap: () async {
                          Usuario? usuarioActual = await AuthHelper()
                              .cargarUsuarioDeFirebase(getCurrentUser()!.email);
                          if (usuarioActual != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatWidget(usuarioActual: usuarioActual, uid: 'rEzfeft8TxbyObmY4XLb'
                                ),
                              ),
                            );
                          }
                        },
                        lastChatText: listViewChatsRecord.lastMessage,
                        lastChatTime: listViewChatsRecord.lastMessageTime,
                        seen: listViewChatsRecord.lastMessageSeenBy.contains(currentUserReference),
                        title: '${chatInfo.nombre} - ${chatInfo.area}',
                        userProfilePic: chatInfo.urlImagen,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        unreadColor: FlutterFlowTheme.of(context).primary,
                        titleTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        dateTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                        previewTextStyle: GoogleFonts.getFont(
                          'Urbanist',
                          color: FlutterFlowTheme.of(context).grayIcon,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
                        borderRadius: BorderRadius.circular(0.0),
                      );
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
}
