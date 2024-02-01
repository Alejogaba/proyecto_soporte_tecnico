import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login2/index.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/vistas/activo_perfil_page/activo_perfil_page_widget.dart';
import 'package:login2/vistas/login/LoginMOD.dart';

import '../../auth/firebase_auth/auth_helper.dart';
import '../../backend/controlador_activo.dart';
import '../../backend/controlador_caso.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/activo.dart';
import 'package:badges/badges.dart' as badges;

import '../../model/caso.dart';
import '../../model/usuario.dart';

class ListaActivosFuncionariosPageWidget extends StatefulWidget {
  final Dependencia? dependencia;
  final bool selectMode;

  const ListaActivosFuncionariosPageWidget({
    Key? key,
    required this.dependencia,
    this.selectMode = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaActivosFuncionariosPageWidgetState createState() =>
      _ListaActivosFuncionariosPageWidgetState(
          this.dependencia, this.selectMode);
}

class _ListaActivosFuncionariosPageWidgetState
    extends State<ListaActivosFuncionariosPageWidget> {
  late TextEditingController textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Dependencia? dependencia;
  var id = '';
  var a;
  ActivoController activoController = ActivoController();
  List<Activo> listaActivos = [];
  bool selectMode;

  _ListaActivosFuncionariosPageWidgetState(
    this.dependencia,
    this.selectMode,
  );

  @override
  void initState() {
    super.initState();
    if (dependencia == null) {
      cargarDependencia();
    }
    textControllerBusqueda = TextEditingController();
  }

  @override
  void dispose() {
    textControllerBusqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.computer),
            SizedBox(width: 8.0), // Espacio entre el icono y el texto
            Text('Equipos de cómputo'),
          ],
        ),
        actions: [],
        elevation: 0,
      ),

       floatingActionButton: FloatingActionButton(
            //speed dial child
            child: Icon(FontAwesomeIcons.barcode),
            backgroundColor: Color.fromARGB(255, 7, 133, 36),
            foregroundColor: Colors.white,
            onPressed: () async {
              await FlutterBarcodeScanner.scanBarcode(
                      '#C62828', // scanning line color
                      'Cancelar', // cancel button text
                      true, // whether to show the flash icon
                      ScanMode.BARCODE)
                  .then((value) async {
                if (value != '-1') {
                  ActivoController activoController = ActivoController();
                  Activo? activo =
                      await activoController.buscarActivoPorCodigoBarra(
                          widget.dependencia!.uid, value);
                  log('Codigo de barras leido: $value');
                  if (activo != null) {
                    if (activo
                                                  .casosPendientes) {
                                                Caso? caso =
                                                    await CasosController()
                                                        .buscarCasoPorUID(
                                                            activo
                                                                .uid);
                                                final Activo? result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetalleReporteWidget(
                                                              caso!,esAdmin:false)),
                                                ).then((value){
                                                  setState(() {});
                                                  return null;
                                                });
                                                
                                              } else {
                                                
                                                final Activo? result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivoPerfilPageWidget(
                                                      activo: activo,
                                                      dependencia: dependencia,
                                                      esadmin: false,
                                                    ),
                                                  ),
                                                );
                                                if (result != null) {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(
                                                      context, result);
                                                }
                                              }

                  } else {
                    final e = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrarEquipoWidget(
                          dependencia: widget.dependencia!,
                          barcode: value,
                        ),
                      ),
                    ).then((value) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        setState(() {});
                      });
                    });
                  }
                  setState(() {});
                }
              });
            },
      ),
      
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (dependencia != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegistrarEquipoWidget(
                        dependencia: dependencia!,
                      )),
            );
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      **/
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 270.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x39000000),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 4.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 4.0, 0.0, 0.0),
                                            child: Image.asset(
                                              'assets/images/chimichagua-removebg-preview-transformed.png',
                                              width: 71.1,
                                              height: 75.0,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 4.0, 0.0, 0.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  'Alcaldia de Chimichagua',
                                                  minFontSize: 18,
                                                  maxFontSize: 22,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Urbanist',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                ),
                                                AutoSizeText(
                                                  'Servicio técnico',
                                                  minFontSize: 14,
                                                  maxFontSize: 16,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Urbanist',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        fontSize: 27.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: IconButton(
                                              onPressed: () {
                                                
                                                Get.toNamed('/perfilgen');
                                              },
                                              icon: Icon(
                                                Icons.settings,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                size: 32,
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 26.0, 16.0, 0.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          38,
                                      height: 0.6,
                                      color: Color.fromARGB(179, 235, 229, 229),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 26.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FutureBuilder<Usuario?>(
                                      future: AuthHelper()
                                          .cargarUsuarioDeFirebase(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data != null) {
                                          return Text(
                                            '¡Bienvenid@ ${snapshot.data!.nombre}!',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 22,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                ),
                                          );
                                        } else {
                                          return Text(
                                            '¡Bienvenid@!',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  fontFamily: 'Urbanist',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 4.0, 0.0),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            controller: textControllerBusqueda,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Buscar activo...',
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Urbanist',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .grayIcon,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .grayIcon,
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Urbanist',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
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
                        if (dependencia != null)
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                            child: StreamBuilder<List<Activo?>>(
                                stream: activoController.obtenerActivosStream(
                                    dependencia!.uid,
                                    textControllerBusqueda.text),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null &&
                                      snapshot.data!.isNotEmpty) {
                                    listaActivos.clear();
                                    return Wrap(
                                      spacing:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      runSpacing: 15,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      direction: Axis.horizontal,
                                      runAlignment: WrapAlignment.start,
                                      verticalDirection: VerticalDirection.down,
                                      clipBehavior: Clip.none,
                                      children: List.generate(
                                          snapshot.data!.length, (index) {
                                        return GestureDetector(
                                            onTap: () async {
                                              Usuario usuario = await AuthHelper()
                                                        .cargarUsuarioDeFirebase() ??
                                                    Usuario();
                                                late bool esadmin;
                                                if (usuario.role != null) {
                                                  if (usuario.role == 'admin') {
                                                    esadmin = true;
                                                  } else {
                                                    esadmin = false;
                                                  }
                                                } else {
                                                  esadmin = false;
                                                }
                                              if (snapshot.data![index]!
                                                  .casosPendientes) {
                                                Caso? caso =
                                                    await CasosController()
                                                        .buscarCasoPorUID(
                                                            snapshot
                                                                .data![index]!
                                                                .uid);
                                                final Activo? result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetalleReporteWidget(
                                                              caso!,esAdmin:esadmin)),
                                                ).then((value){
                                                  setState(() {});
                                                  return null;
                                                });
                                                
                                              } else {
                                                
                                                final Activo? result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivoPerfilPageWidget(
                                                      activo: snapshot
                                                          .data![index]!,
                                                      dependencia: dependencia,
                                                      esadmin: esadmin,
                                                    ),
                                                  ),
                                                );
                                                if (result != null) {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(
                                                      context, result);
                                                }
                                              }
                                            },
                                            child: tarjetaActivo(
                                              context,
                                              snapshot.data![index]!,
                                              selectMode: selectMode,
                                            ));
                                      }),
                                    );
                                  } else {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          heightFactor: 22,
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ));
                                    } else {
                                      return Center(
                                        heightFactor: 50,
                                        child: Container(
                                          child: Text(
                                              'No se han encontrado activos registrados...'),
                                        ),
                                      );
                                    }
                                  }
                                }),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  cargarDependencia() async {
    Dependencia? result = await AuthHelper().buscarDependenciaUsuarioActual();
    if (result != null) {
      setState(() {
        dependencia = result;
      });
    }
  }
}

Widget tarjetaActivo(context, Activo activo,
    {bool selectMode = false,
    bool esPrestamos = false,
    bool estaPrestado = false,
    bool estaAsignado = false}) {
  return Container(
    width: 185,
    decoration: BoxDecoration(
      color: FlutterFlowTheme.of(context).secondaryBackground,
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: FlutterFlowTheme.of(context).secondaryText,
          offset: Offset(0, 2),
        )
      ],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: FlutterFlowTheme.of(context).secondaryText,
      ),
    ),
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              activo.urlImagen!,
              width: double.infinity,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (context, exception, stacktrace) {
                log(stacktrace.toString());
                return Image.asset(
                  'assets/images/nodisponible.png',
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 6, 0, 0),
            child: Text(
              activo.nombre,
              overflow: TextOverflow.clip,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Urbanist',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          if (activo.casosPendientes)
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -10, end: -12),
                    showBadge: true,
                    ignorePointer: false,
                    onTap: () {},
                    badgeContent: Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 12,
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
                      padding: EdgeInsets.all(3),
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.redAccent, width: 1),
                      elevation: 0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(3, 3, 0, 1),
                  child: Text(
                    'Requiere soporte',
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyText2.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyText2Family,
                          color: FlutterFlowTheme.of(context).error,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyText2Family),
                        ),
                  ),
                ),
              ],
            ),
          /*
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: FaIcon(
                  FontAwesomeIcons.barcode,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 15,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(3, 3, 0, 1),
                child: Text(
                  activo.uid,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
              ),
            ],
          ),
          */
        ],
      ),
    ),
  );
}

double? defTamanoImagen(screenSize) {
  if (screenSize > 440 && screenSize < 640) {
    return 82;
  } else if (screenSize >= 640 && screenSize < 1057) {
    return 180;
  } else if (screenSize >= 1057 && screenSize < 1240) {
    return 170;
  } else if (screenSize >= 1240 && screenSize < 1370) {
    return 140;
  } else if (screenSize >= 1370 && screenSize < 1840) {
    return 135;
  } else if (screenSize >= 1840) {
    return 110;
  } else {
    return 180;
  }
}

Color? definirColorEstado(int? estado,
    {bool selectMode = false,
    bool esPrestamos = false,
    bool estaPrestado = false,
    bool estaAsignado = false}) {
  if ((selectMode && !esPrestamos && !estaAsignado) ||
      (selectMode && esPrestamos && !estaPrestado)) {
    estado = 0;
  } else if ((selectMode && !esPrestamos && estaAsignado) ||
      (selectMode && esPrestamos && estaPrestado)) {
    estado = 2;
  }
  switch (estado) {
    case 0:
      return Colors.green;

    case 1:
      return Colors.yellow;

    case 2:
      return Colors.red;

    default:
      return Colors.grey;
  }
}

String? definirEstadoActivo(int? estado,
    {bool selectMode = false,
    bool esPrestamos = false,
    bool estaPrestado = false,
    bool estaAsignado = false}) {
  if ((selectMode && !esPrestamos && !estaAsignado) ||
      (selectMode && esPrestamos && !estaPrestado)) {
    estado = 3;
  } else if ((selectMode && !esPrestamos && estaAsignado) ||
      (selectMode && esPrestamos && estaPrestado)) {
    estado = 4;
  }
  switch (estado) {
    case 0:
      return 'Bueno';

    case 1:
      return 'Regular';

    case 2:
      return 'Malo';

    case 3:
      return 'Disponible';

    case 4:
      return 'Ocupado';

    default:
      return 'No definido';
  }
}
