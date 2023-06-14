import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../auth/firebase_auth/auth_helper.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../../flutter_flow/flutter_flow_animations.dart';
import '../../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'package:login2/vistas/lista_funcionarios/funcionarioForm.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';
import '../../backend/diseño_interfaz_app_theme.dart';
import 'lista_funcionarios_model.dart';
export 'lista_funcionarios_model.dart';
import '../../model/usuario.dart';
import '/backend/backend.dart';
import 'funcionario_information.dart';

class ListaFuncionariossWidget extends StatefulWidget {
  const ListaFuncionariossWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ListaFuncionariossWidgetWidgetState createState() =>
      _ListaFuncionariossWidgetWidgetState();
}

class _ListaFuncionariossWidgetWidgetState
    extends State<ListaFuncionariossWidget> with TickerProviderStateMixin {
  int tabSelected = 3;
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
  TextEditingController _textBusqueda = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _mostrarBusqueda = false;
  @override
  void initState() {
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
                        builder: (context) => FuncionarioFormWidget(Usuario())),
                  ).then((value) {
                    setState(() {});
                  });
                },
              ),
            )
          ],
        ),
      ),
      key: scaffoldKey,
      backgroundColor: Color.fromARGB(255, 223, 231, 235),
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                    Color.fromARGB(255, 214, 219, 216),
                    Color.fromARGB(255, 214, 219, 216)
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
                                EdgeInsetsDirectional.fromSTEB(4, 0, 160, 0),
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
                              color: Color.fromARGB(255, 7, 75, 24),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    SizedBox(
                      width: 60,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(_unfocusNode),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 4, 0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.94,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 24),
                                            child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 138, 135, 135),
                                                      width: 1),
                                                  color: Color.fromARGB(
                                                      255, 214, 219, 216),
                                                ),
                                                child: FutureBuilder<
                                                    List<Usuario>>(
                                                  future: UserHelper()
                                                      .obtenerUsuarios(),
                                                  builder:
                                                      (BuildContext context,
                                                          snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        snapshot.data != null) {
                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return SwipeTo(
                                                            iconOnLeftSwipe:
                                                                Icons.add,
                                                            iconOnRightSwipe:
                                                                Icons
                                                                    .text_fields,
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            onLeftSwipe:
                                                                () async {},
                                                            onRightSwipe: () {},
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16,
                                                                          8,
                                                                          16,
                                                                          0),
                                                              child: InkWell(
                                                                onTap: () =>
                                                                    _navigateToFuncionario(
                                                                        context,
                                                                        snapshot
                                                                            .data![index]),
                                                                onLongPress:
                                                                    () async {},
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            214,
                                                                            219,
                                                                            216),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            8,
                                                                        color: Color(
                                                                            0x20000000),
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            8,
                                                                            12,
                                                                            8),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          child: '${snapshot.data![index].urlImagen}' == ''
                                                                              ? Text('No image')
                                                                              : Image.network(
                                                                                  '${snapshot.data![index].urlImagen}' + '?alt=media',
                                                                                  width: 70,
                                                                                  height: 70,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                                                                child: Text(
                                                                                  snapshot.data![index].nombre.toString(),
                                                                                  style: FlutterFlowTheme.of(context).subtitle1,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16, 2, 0, 0),
                                                                                child: Text(
                                                                                  snapshot.data![index].role.toString(),
                                                                                  style: FlutterFlowTheme.of(context).bodyText2,
                                                                                ),
                                                                              ),
                                                                              /*Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              16,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: Text(
                                                                        'ACME Co.',
                                                                        style: FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyText2
                                                                            .override(
                                                                              fontFamily:
                                                                                  'Poppins',
                                                                              color:
                                                                                  FlutterFlowTheme.of(context).primaryColor,
                                                                              fontSize:
                                                                                  12,
                                                                            ),
                                                                      ),
                                                                    ),*/
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        if (snapshot.data![index].email!.toLowerCase() !=
                                                                            FirebaseAuth.instance.currentUser!.email!.toLowerCase())
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 20),
                                                                            child:
                                                                                IconButton(
                                                                              icon: Icon(
                                                                                Icons.delete_outline,
                                                                                color: Colors.red,
                                                                                size: 24,
                                                                              ),
                                                                              onPressed: () => _showDialog(snapshot.data![index], context),
                                                                            ),
                                                                          ),
                                                                        IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.mode_edit_outline,
                                                                              color: FlutterFlowTheme.of(context).primaryColor,
                                                                              size: 24,
                                                                            ),
                                                                            onPressed: () =>
                                                                                _navigateToFuncionarioInformation(context, snapshot.data![index])),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'containerOnPageLoadAnimation']!),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      return Center(
                                                          child: Container(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ));
                                                    }
                                                  },
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: InterfazAppTheme.nearlyBlack,
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
      ),
    );
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
          builder: (context) => FuncionarioInformation(
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
