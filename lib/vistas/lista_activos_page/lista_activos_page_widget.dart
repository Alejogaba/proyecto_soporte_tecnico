import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/flutter_flow/chat/index.dart';
import 'package:login2/index.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/model/usuario.dart';
import 'package:login2/vistas/activo_perfil_page/activo_perfil_page_widget.dart';

import '../../backend/controlador_activo.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../model/activo.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:badges/badges.dart' as badges;

import '../../model/caso.dart';
import '../resgistrar_activo_page/resgistrar_activo_computo_page_widget.dart';

class ListaActivosPageWidget extends StatefulWidget {
  final Dependencia dependencia;
  final bool selectMode;

  const ListaActivosPageWidget({
    Key? key,
    required this.dependencia,
    this.selectMode = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaActivosPageWidgetState createState() =>
      _ListaActivosPageWidgetState(this.dependencia, this.selectMode);
}

class _ListaActivosPageWidgetState extends State<ListaActivosPageWidget> {
  late TextEditingController textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Dependencia dependencia;
  var id = '';
  var a;
  ActivoController activoController = ActivoController();
  List<Activo> listaActivos = [];
  bool selectMode;

  _ListaActivosPageWidgetState(
    this.dependencia,
    this.selectMode,
  );

  @override
  void initState() {
    super.initState();

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
      floatingActionButton: SpeedDial(
        //Speed dial menu
        //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: FlutterFlowTheme.of(context)
            .primaryColor, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor: FlutterFlowTheme.of(context)
            .primaryColor, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56.0, 56), //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'), // action when menu opens
        onClose: () => print('DIAL CLOSED'), //action when menu closes

        elevation: 8.0, //shadow elevation of button
        shape: CircleBorder(), //shape of button

        children: [
          SpeedDialChild(
            //speed dial child
            child: Icon(FontAwesomeIcons.barcode),
            backgroundColor: Color.fromARGB(255, 7, 133, 36),
            foregroundColor: Colors.white,
            label: 'Buscar por código de barras',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await FlutterBarcodeScanner.scanBarcode(
                      '#C62828', // scanning line color
                      'Cancelar', // cancel button text
                      true, // whether to show the flash icon
                      ScanMode.BARCODE)
                  .then((value) async {
                if (value != null && value != '-1') {
                  ActivoController activoController = ActivoController();
                  Activo? activo =
                      await activoController.buscarActivoPorCodigoBarra(
                          widget.dependencia.uid, value);
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
                                                              caso!,esAdmin:true)),
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
                                                      esadmin: true,
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
                          dependencia: widget.dependencia,
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
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Color.fromARGB(255, 7, 133, 107),
              foregroundColor: Colors.white,
              label: 'Registrar nuevo activo',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrarEquipoWidget(
                              dependencia: dependencia,
                            )),
                  )),
        ],
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left_rounded,
                color: FlutterFlowTheme.of(context).tertiary,
                size: 30,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            title: AutoSizeText(
              dependencia.nombre,
              style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    color: FlutterFlowTheme.of(context).tertiary,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText1Family),
                  ),
            ),
            centerTitle: false,
            elevation: 4,
          )
        ],
        body: Builder(
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
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                        child: TextFormField(
                                          controller: textControllerBusqueda,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            'textController',
                                            Duration(milliseconds: 2000),
                                            () => setState(() {}),
                                          ),
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Buscar activo...',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText2
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFF57636C),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                          .containsKey(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyText2Family),
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            prefixIcon: Icon(
                                              Icons.search_rounded,
                                              color: Color(0xFF57636C),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyText1Family),
                                              ),
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 44),
                                child: StreamBuilder<List<Activo?>>(
                                    stream:
                                        activoController.obtenerActivosStream(
                                            dependencia.uid,
                                            textControllerBusqueda.text),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null &&
                                          snapshot.data!.isNotEmpty) {
                                        listaActivos.clear();
                                        return Wrap(
                                          spacing: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                          runSpacing: 15,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          direction: Axis.horizontal,
                                          runAlignment: WrapAlignment.start,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          clipBehavior: Clip.none,
                                          children: List.generate(
                                              snapshot.data!.length, (index) {
                                            return GestureDetector(
                                                onTap: () async {
                                                  Usuario usuario =
                                                        await AuthHelper()
                                                                .cargarUsuarioDeFirebase() ??
                                                            Usuario();
                                                    log("Lista activos Usuario: ${usuario.role}");
                                                    late bool esadmin;
                                                    if (usuario.role != null) {
                                                      if (usuario.role ==
                                                          'admin') {
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
                                                                    .data![
                                                                        index]!
                                                                    .uid);
                                                    final Activo? result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetalleReporteWidget(
                                                                  caso!,esAdmin: esadmin,)),
                                                    );
                                                    if (result != null) {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(
                                                          context, result);
                                                    } else {
                                                      setState(() {});
                                                    }
                                                  } else {
                                                    
                                                    final Activo? result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ActivoPerfilPageWidget(
                                                          activo: snapshot
                                                              .data![index]!,
                                                          dependencia:
                                                              dependencia,
                                                          esadmin:
                                                              esadmin, //venaqui
                                                        ),
                                                      ),
                                                    );
                                                    if (result != null) {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(
                                                          context, result);
                                                    } else {
                                                      setState(() {});
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
                                        return Center(
                                            child: Container(
                                          child: CircularProgressIndicator(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ));
                                      }
                                    }),
                              ),
                            ],
                          ),
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
