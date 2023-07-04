import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:login2/vistas/lista_funcionarios/Lista/views/FuncioInfo.dart';

import '../../auth/firebase_auth/auth_helper.dart';
import '../../backend/diseño_interfaz_app_theme.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/usuario.dart';
import 'funcionarioForm.dart';
import 'funcionario_information.dart';

class ListaFuncionarioss extends StatefulWidget {
  const ListaFuncionarioss({
    Key? key,
  }) : super(key: key);
  @override
  _ListaFuncionariossState createState() => _ListaFuncionariossState();
}

class _ListaFuncionariossState extends State<ListaFuncionarioss>
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
  List<Usuario?> listaFuncionarios = [];
  FocusNode _focusNode = FocusNode();
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
                      MaterialPageRoute(
                          builder: (context) =>
                              FuncionarioFormWidget(Usuario())),
                    ).then((value) {
                      setState(() {});
                    });
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
                              child: Image.asset(
                                "assets/images/perfil1.png",
                                width: 55,
                                height: 55,
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Todos los funcionarios",
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
                    child: FutureBuilder<List<Usuario>>(
                      future: UserHelper().obtenerUsuarios(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    
                                            onTap: () => _navigateToFuncionario(
                                                context, snapshot.data![index]),
                                            onLongPress: () async {},
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 16),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                    child:
                                                        '${snapshot.data![index].urlImagen}' ==
                                                                ''
                                                            ? Text('No image')
                                                            : Image.network(
                                                                '${snapshot.data![index].urlImagen}' +
                                                                    '?alt=media',
                                                                width: 70,
                                                                height: 70,
                                                                fit: BoxFit.cover,
                                                              ),
                                                  ),
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
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                136,
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .nombre
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            /*Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  width: 6,
                                                                  height: 6,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xffD9B372),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .cargo
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                              
                                                            ),
                                                            **/
                                                            if (snapshot
                                                                    .data![index]
                                                                    .uid!
                                                                    .toLowerCase() !=
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                                    .toLowerCase())
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            20),
                                                              ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: Colors.red,
                                                                size: 24,
                                                              ),
                                                              onPressed: () =>
                                                                  _showDialog(
                                                                      snapshot.data![
                                                                          index],
                                                                      context),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .mode_edit_outline,
                                                                  color:
                                                                      Colors.red,
                                                                  size: 24,
                                                                ),
                                                                onPressed: () =>
                                                                    _navigateToFuncionarioInformation(
                                                                        context,
                                                                        snapshot.data![
                                                                            index])),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                158,
                                                            child: Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .area
                                                                  .toString(),
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                          
                                                      //Lineas
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                136,
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

  void _showDialog(Usuario usuario, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Advertencia'),
          content: Text('¿Está seguro de que desea eliminar este funcionario?'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                await UserHelper().eliminarFuncionario(usuario.uid!);
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
            new TextButton(
              child: Text('Cancelar'),
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
      BuildContext context, Usuario usuario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FuncionarioFormWidget(usuario)),
    );
  }

  void _navigateToFuncionario(BuildContext context, Usuario usuario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FuncioInfo(
                usuario: usuario,
              )),
    );
  }

  void _createNewFuncionario(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FuncionarioFormWidget(Usuario())),
    );
  }
}
