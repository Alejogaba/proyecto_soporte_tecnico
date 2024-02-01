import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login2/backend/controlador_activo.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/chatBot.dart';
import 'package:login2/utils/utilidades.dart';
import 'package:login2/vistas/chatbot_lista_respuestas/chatbot_Form.dart';
import 'package:login2/vistas/chatbot_lista_respuestas/chatbot_info.dart';
import 'package:login2/vistas/lista_funcionarios/Lista/views/FuncioInfo.dart';
import 'package:login2/vistas/nuevo_reporte/detalle_reporte_admin_widget.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:badges/badges.dart' as badges;

import '../../auth/firebase_auth/auth_helper.dart';
import '../../backend/controlador_dependencias.dart';
import '../../flutter_flow/flutter_flow_animations.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../model/activo.dart';
import '../../model/dependencias.dart';
import '../../model/usuario.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'choices.dart' as choices;

class ListaPanelReportesAdmin extends StatefulWidget {
  const ListaPanelReportesAdmin({
    Key? key,
  }) : super(key: key);
  @override
  _ListaPanelReportesAdminState createState() =>
      _ListaPanelReportesAdminState();
}

class _ListaPanelReportesAdminState extends State<ListaPanelReportesAdmin>
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
  String value = 'flutter';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'ion', title: 'Ionic'),
    S2Choice<String>(value: 'flu', title: 'Flutter'),
    S2Choice<String>(value: 'rea', title: 'React Native'),
  ];
  List<String> _car = [];
  String _category = 'Electronics';
  String _day = 'fri';
  List<S2Choice<String>> categories = [
    S2Choice<String>(value: 'ele', title: 'Electronics'),
    S2Choice<String>(value: 'aud', title: 'Audio & Video'),
    S2Choice<String>(value: 'acc', title: 'Accessories'),
    S2Choice<String>(value: 'ind', title: 'Industrial'),
    S2Choice<String>(value: 'wat', title: 'Smartwatch'),
    S2Choice<String>(value: 'sci', title: 'Scientific'),
    S2Choice<String>(value: 'mea', title: 'Measurement'),
    S2Choice<String>(value: 'pho', title: 'Smartphone'),
  ];

  bool blur = false;

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
        body: SafeArea(
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              SmartSelect<String>.multiple(
                title: 'Categorias',
                placeholder: 'Escoge una o varias categorias',
                selectedValue: _car,
                onChange: (selected) => setState(() {
                  if (selected != null && selected.value != null) {
                    _car = selected.value!;
                    for (var element in selected.value!) {
                      log('message1: ${element}');
                    }
                  } else {
                    setState(() {
                      _car = [];
                    });
                  }
                }),
                onSelect: (state, choice) {
                  log('message: $choice');
                  for (var element in _car) {
                    log('message2: ${element}');
                  }
                },
                choiceItems: S2Choice.listFrom<String, Map>(
                  source: choices.serviceCategories,
                  value: (index, item) => item['value'],
                  title: (index, item) => item['title'],
                  group: (index, item) => item['body'],
                ),
                choiceActiveStyle: const S2ChoiceStyle(color: Colors.teal),
                modalType: S2ModalType.bottomSheet,
                modalConfirm: true,
                modalFilter: true,
                groupEnabled: true,
                groupSortBy: S2GroupSort.byNameInAsc(),
                groupBuilder: (context, state, group) {
                  return StickyHeader(
                    header: state.groupHeader(group),
                    content: state.groupChoices(group),
                  );
                },
                groupHeaderBuilder: (context, state, group) {
                  log('group:${group.name}');
                  return Container(
                    color: FlutterFlowTheme.of(context).accent4,
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: S2Text(
                      text: group.name,
                      highlight: state.filter!.value ?? 'HIghlight',
                      highlightColor: Colors.teal,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: definirColorCategoria(group.name ?? '')),
                    ),
                  );
                },
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    hideValue: true,
                    trailing: _car.length > 0
                        ? badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -3, end: -3),
                            showBadge: true,
                            ignorePointer: false,
                            onTap: () {},
                            badgeContent: Text('${_car.length}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            badgeAnimation: badges.BadgeAnimation.fade(
                              animationDuration: Duration(seconds: 2),
                              colorChangeAnimationDuration:
                                  Duration(seconds: 5),
                              loopAnimation: false,
                              curve: Curves.fastOutSlowIn,
                              colorChangeAnimationCurve: Curves.easeInCubic,
                            ),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: FlutterFlowTheme.of(context).primary,
                              padding: EdgeInsets.all(3),
                              elevation: 1,
                            ),
                            child: Icon(
                              Icons.filter_list,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          )
                        : Icon(
                            Icons.filter_list,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                    title: Container(),
                  );
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (blur)
                setState(() {
                  blur = false;
                });
            },
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),

                      /// Tab Options ///
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4, 2, 5, 4),
                                    decoration: tabSelected == 1
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          )
                                        : BoxDecoration(),
                                    child: Icon(
                                      Icons.warning_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    )),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Casos Pendientes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //Lineas
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 0.6,
                        color: Color.fromARGB(178, 194, 185, 185),
                      ),

                      Expanded(
                        flex: 1,
                        child: StreamBuilder<List<Caso>>(
                          stream: CasosController()
                              .obtenerCasosPendientesStream(_car),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.data != null &&
                                snapshot.data!.length > 0) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FutureBuilder<Usuario?>(
                                              future: AuthHelper()
                                                  .getUsuarioFutureUID(snapshot
                                                      .data![index]
                                                      .uidSolicitante),
                                              builder: (BuildContext context,
                                                  snapshotUsuario) {
                                                if (snapshotUsuario
                                                            .connectionState ==
                                                        ConnectionState.done &&
                                                    snapshotUsuario.data !=
                                                        null) {
                                                  return tarjetaCaso(
                                                      context,
                                                      snapshot,
                                                      index,
                                                      snapshotUsuario.data!);
                                                } else {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 55,
                                                      height: 55,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              if ((snapshot.data == null ||
                                      snapshot.data!.isEmpty) &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return Center(
                                  child: Text(
                                    'No se encontraron casos',
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              } else {
                                print('Conexion: ${snapshot.connectionState}');
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: AppBar().preferredSize.height,
                      height: AppBar().preferredSize.height,
                      child: Material(
                        color: const Color.fromARGB(0, 255, 255, 255),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              AppBar().preferredSize.height),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: FlutterFlowTheme.of(context).primaryText,
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
          ),
          if (blur)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),

                      child: _cajaAdvertencia(
                        context,
                        'Describa la razón por la cual quiere reportar este caso',
                      ),
                      //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ));
  }

  Widget _cajaAdvertencia(BuildContext context, mensaje) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 5),
        child: Container(
          width: 450,
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 400,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 7,
                color: Color(0x4D000000),
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Reportar Caso',
                    style: FlutterFlowTheme.of(context).title2.override(
                          fontFamily: 'Poppins',
                          color: Color(0xBFDF2424),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).title2Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    mensaje,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyText1Family),
                        ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 8.0, 8.0),
                        child: Container(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {},
                    text: 'Reportar',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: Color(0xFFFC4253),
                      textStyle: FlutterFlowTheme.of(context)
                          .subtitle2
                          .override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).tertiary,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).subtitle2Family),
                          ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    showLoadingIndicator: false,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          setState(() {
                            blur = false;
                          });
                        },
                        text: 'No, cancelar',
                        options: FFButtonOptions(
                          width: 170,
                          height: 50,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .subtitle2Family),
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        showLoadingIndicator: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tarjetaCaso(BuildContext context, AsyncSnapshot<List<Caso>> snapshot,
      int index, Usuario funcionario) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 3, end: 20),
      showBadge: true,
      ignorePointer: false,
      onTap: () {},
      badgeContent: Text(
          definirNombreCategoria(snapshot.data![index].categoria),
          maxLines: 1,
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold)),
      badgeAnimation: badges.BadgeAnimation.size(
        animationDuration: Duration(seconds: 2),
        colorChangeAnimationDuration: Duration(seconds: 5),
        loopAnimation: false,
        curve: Curves.fastOutSlowIn,
        colorChangeAnimationCurve: Curves.easeInCubic,
      ),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.square,
        badgeColor: definirColorCategoria(snapshot.data![index].categoria),
        padding: EdgeInsets.all(2),
        borderRadius: BorderRadius.circular(4),
        elevation: 1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: '${funcionario.urlImagen}' == ''
                ? Text('No image')
                : Image.network(
                    '${funcionario.urlImagen}' + '?alt=media',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 1,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AutoSizeText(
                                  funcionario.nombre.toString(),
                                  maxLines: 1,
                                  minFontSize: 15,
                                  maxFontSize: 17,
                                  style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffD9B372),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        funcionario.cargo.toString(),
                                        style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 3),
                              child: FutureBuilder<Dependencia>(
                                  future: ControladorDependencias()
                                      .cargarDependenciaUID(
                                          snapshot.data![index].uidDependencia),
                                  builder: (BuildContext context,
                                      snapshotDependencia) {
                                    if (snapshotDependencia.connectionState ==
                                            ConnectionState.done &&
                                        snapshotDependencia.data != null) {
                                      return AutoSizeText(
                                        '${snapshotDependencia.data!.nombre}',
                                        maxLines: 1,
                                        minFontSize: 10,
                                        maxFontSize: 12,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText
                                                .withOpacity(0.5)),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    } else {
                                      return AutoSizeText(
                                        '',
                                        maxLines: 1,
                                        minFontSize: 8,
                                        maxFontSize: 10,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText
                                                .withOpacity(0.5)),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: FutureBuilder<Activo>(
                                  future: ActivoController().cargarActivoUID(
                                      snapshot.data![index].uidDependencia,
                                      snapshot.data![index].uidActivo),
                                  builder:
                                      (BuildContext context, snapshotActivo) {
                                    if (snapshotActivo.connectionState ==
                                            ConnectionState.done &&
                                        snapshotActivo.data != null) {
                                      return AutoSizeText(
                                        'Requiere servicio técnico para ${snapshotActivo.data!.nombre}.\nProblema: ${snapshot.data![index].descripcion}',
                                        maxLines: 2,
                                        minFontSize: 12,
                                        maxFontSize: 14,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    } else {
                                      return Center(
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Lineas
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 130,
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
    );
  }

  void _showDialog(Caso usuario, context) {
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
      BuildContext context, Caso caso) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalleReporteAdminWidget(caso)),
    );
  }

  Color definirColorCategoria(String categoria) {
    if (categoria.toLowerCase().contains('hardware')) {
      return Colors.blue;
    } else if (categoria.toLowerCase().contains('software')) {
      return Colors.green;
    } else if (categoria.toLowerCase().contains('redes')) {
      return Colors.orange;
    } else if (categoria.toLowerCase().contains('mantenimiento preventivo')) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  String definirNombreCategoria(String categoria) {
    var categorias = categoria.split('-');
    late var newCategoria;
    if (categorias.length > 1) {
      newCategoria = '${categorias[1]}: ${categorias[0]}';
    } else {
      newCategoria = categorias[0];
    }
    return Utilidades().capitalizarPalabras(newCategoria);
  }

  void _navigateToFuncionario(BuildContext context, Caso caso) async {
    log('Navegar a ChatBotInfo');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalleReporteAdminWidget(caso)),
    );
  }
}
