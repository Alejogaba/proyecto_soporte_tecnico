import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/model/chatBot.dart';
import 'package:login2/vistas/chatbot_lista_respuestas/chatbot_Form.dart';
import 'package:login2/vistas/chatbot_lista_respuestas/chatbot_info.dart';
import 'package:login2/vistas/lista_funcionarios/Lista/views/FuncioInfo.dart';

import '../../auth/firebase_auth/auth_helper.dart';
import '../../backend/controlador_dependencias.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/dependencias.dart';
import '../../model/usuario.dart';

class ChatBotRespuestaLista extends StatefulWidget {
  const ChatBotRespuestaLista({
    Key? key,
  }) : super(key: key);
  @override
  _ChatBotRespuestaListaState createState() => _ChatBotRespuestaListaState();
}

class _ChatBotRespuestaListaState extends State<ChatBotRespuestaLista>
    with TickerProviderStateMixin {
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: Offset(0, 20),
          end: Offset(0, 0),
        ),
      ],
    ),
  };

  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatBot?> listaChatBot = [];
  int tabSelected = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 20, 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AbsorbPointer(
                absorbing: false,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatBotForm()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                      Color.fromARGB(255, 10, 82, 28),
                      Color.fromARGB(255, 64, 82, 102)
                    ],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight)),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 90,
                  ),

                  /// Tab Options ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(4, 0, 20, 0),
                              decoration: tabSelected == 1
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      gradient: LinearGradient(
                                          colors: [
                                            const Color(0xffA2834D),
                                            const Color(0xffBC9A5F)
                                          ],
                                          begin: FractionalOffset.topRight,
                                          end: FractionalOffset.bottomLeft))
                                  : BoxDecoration(),
                              child: Image.network(
                                "https://i.ibb.co/6yvmTxG/1000000000.jpg",
                                width: 55,
                                height: 55,
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Respuestas personalizadas\nChatBot",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  //Lineas
                  Container(
                    width: MediaQuery.of(context).size.width - 136,
                    height: 0.4,
                    color: Color.fromARGB(179, 194, 185, 185),
                  ),

                  Expanded(
                    flex: 1,
                    child: FutureBuilder<List<ChatBot>>(
                      future:
                          ControladorChat().obtenerRespuestasChatBotFirebase(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => _navigateToFuncionario(
                                        context, snapshot.data![index]),
                                  child: GestureDetector(
                                    onTap: () => _navigateToFuncionario(
                                        context, snapshot.data![index]),
                                    
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 16),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40,
                                                alignment: Alignment.center,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [ snapshot
                                                                  .data![index].intent
                                                                  .toString().contains("?") ? 
                                                            AutoSizeText(
                                                              snapshot
                                                                  .data![index].intent
                                                                  .toString(),
                                                              maxLines: 1,
                                                              minFontSize: 15,
                                                              maxFontSize: 17,
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                                          overflow: TextOverflow.ellipsis,
                                                            ):AutoSizeText(
                                                              '¿${snapshot
                                                                  .data![index].intent}?',
                                                              maxLines: 1,
                                                              minFontSize: 15,
                                                              maxFontSize: 17,
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                                          overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 14.0),
                                                              child: AutoSizeText(
                                                                snapshot.data![index]
                                                                    .respuesta
                                                                    .toString(),
                                                                maxLines: 2,
                                                                minFontSize: 12,
                                                                maxFontSize: 14,
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color:
                                                                        Colors.white),
                                                                        overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.delete_outline,
                                                            color: Colors.red,
                                                            size: 24,
                                                          ),
                                                          onPressed: () =>
                                                              _showDialog(
                                                                  snapshot.data![
                                                                      index],
                                                                  context),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                
                                              //Lineas
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50,
                                                height: 0.4,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                height: 8,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  width: AppBar().preferredSize.height,
                  height: AppBar().preferredSize.height,
                  child: Material(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(AppBar().preferredSize.height),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _showDialog(ChatBot usuario, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Advertencia'),
          content: Text('¿Está seguro de que desea eliminar esta respuesta?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Si',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await ControladorChat().eliminarRespuestaChatBot(usuario.uid);
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
            new TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFuncionario(
      items, BuildContext context, Usuario usuario, int position) async {
    await UserHelper().eliminarFuncionario(usuario.uid!).then((_) {
      setState(() {
        items.removeAT(position);
        Navigator.of(context).pop();
      });
    });
  }

  void _navigateToFuncionarioInformation(
      BuildContext context, ChatBot usuario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatBotInfo(chatbot: usuario)),
    );
  }

  void _navigateToFuncionario(BuildContext context, ChatBot usuario) async {
    log('Navegar a ChatBotInfo');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatBotInfo(chatbot: usuario)),
    );
  }
}
