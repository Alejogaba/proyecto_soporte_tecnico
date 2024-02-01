import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_activo.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/main.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/chatBot.dart';
import 'package:login2/vistas/lista_funcionarios/Lista/views/FuncioInfo.dart';
import 'package:login2/vistas/lista_funcionarios/funcionario_information.dart';

import '../../backend/controlador_dependencias.dart';
import '../../model/chat_mensajes.dart';
import '../../model/dependencias.dart';
import '../../model/room.dart';
import '../../model/usuario.dart';
import '../activo_perfil_page/activo_perfil_page_widget.dart';
import '../chat/chat_widget.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable_container/selectable_container.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetalleReporteAdminWidget extends StatefulWidget {
  const DetalleReporteAdminWidget(
    this.caso, {
    this.esAdmin = true,
    Key? key,
  }) : super(key: key);

  final Caso caso;
  final bool esAdmin;

  @override
  _DetalleReporteAdminWidgetState createState() =>
      _DetalleReporteAdminWidgetState();
}

class _DetalleReporteAdminWidgetState extends State<DetalleReporteAdminWidget> {
  bool blur = false;
  bool blurEliminarCaso = false;
  Usuario? _selectedUser;
  bool _buttonsEnabled = false;
  bool _buscar = false;
  List<Usuario> _listaTecnicos = [];
  FocusNode _focusBusqueda = FocusNode();
  TextEditingController buscarTecnicoController = TextEditingController();
  TextEditingController textControllerDescripcionReporte =
      TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    Dependencia? estaDepedencia;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            for (var element in _listaTecnicos) {
              if (element.seleccionado) {
                element.seleccionado = false;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(element.uid)
                    .update(element.toMap());
              }
            }
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detalle del reporte',
          style: FlutterFlowTheme.of(context).headlineSmall,
        ),
        actions: [
          Visibility(
            visible: false,
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.more_vert_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 30.0,
              ),
              onPressed: () async {},
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (blur || blurEliminarCaso)
                setState(() {
                  blur = false;
                  blurEliminarCaso = false;
                });
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Fecha',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).gray600,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 4.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                DateFormat('MMMM dd, yyyy', 'es')
                                    .format(widget.caso.fecha),
                                style:
                                    FlutterFlowTheme.of(context).displaySmall,
                              ),
                              Text(
                                ' - ',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color:
                                          FlutterFlowTheme.of(context).darkText,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                DateFormat('h:mm a').format(widget.caso.fecha),
                                style:
                                    FlutterFlowTheme.of(context).displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 8.0, 24.0, 4.0),
                          child: Text(
                            'Dependencia',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).gray600,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        FutureBuilder<Dependencia?>(
                          future: ControladorDependencias()
                              .cargarDependenciaUID(widget.caso.uidDependencia),
                          builder: (BuildContext context, snapshotDependencia) {
                            if (snapshotDependencia.hasData) {
                              estaDepedencia = snapshotDependencia.data;
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Text(
                                  snapshotDependencia.data!.nombre
                                      .maybeHandleOverflow(
                                    maxChars: 90,
                                    replacement: '…',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium,
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 8.0, 24.0, 4.0),
                          child: Text(
                            'Detalles del problema',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  color: FlutterFlowTheme.of(context).gray600,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Text(
                            widget.caso.descripcion.maybeHandleOverflow(
                              maxChars: 90,
                              replacement: '…',
                            ),
                            style: FlutterFlowTheme.of(context).headlineMedium,
                          ),
                        ),
                        if (widget.caso.urlAdjunto.isNotEmpty)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 8.0, 24.0, 4.0),
                            child: Text(
                              'Imagen adjunta',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Lexend Deca',
                                    color: FlutterFlowTheme.of(context).gray600,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        if (widget.caso.urlAdjunto.isNotEmpty)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 340.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDBE2E7),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: CachedNetworkImage(
                                                imageUrl:
                                                    valueOrDefault<String>(
                                                  widget.caso.urlAdjunto,
                                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/st1jx3t60926/r-architecture-TRCJ-87Yoh0-unsplash.jpg',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: false,
                                              tag: valueOrDefault<String>(
                                                widget.caso.urlAdjunto,
                                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/st1jx3t60926/r-architecture-TRCJ-87Yoh0-unsplash.jpg',
                                              ),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: valueOrDefault<String>(
                                          widget.caso.urlAdjunto,
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/st1jx3t60926/r-architecture-TRCJ-87Yoh0-unsplash.jpg',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: CachedNetworkImage(
                                            imageUrl: valueOrDefault<String>(
                                              widget.caso.urlAdjunto,
                                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/st1jx3t60926/r-architecture-TRCJ-87Yoh0-unsplash.jpg',
                                            ),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        FutureBuilder<Activo?>(
                          future: ActivoController().cargarActivoUID(
                              widget.caso.uidDependencia,
                              widget.caso.uidActivo),
                          builder: (BuildContext context, snapshotActivo) {
                            if (snapshotActivo.hasData) {
                              return InkWell(
                                onTap: () async {
                                  if (estaDepedencia != null) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ActivoPerfilPageWidget(
                                          activo: snapshotActivo.data!,
                                          dependencia: estaDepedencia,
                                          esadmin: widget.esAdmin,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 20.0, 0.0, 0.0),
                                      child: Text(
                                        'Activo afectado',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Lexend Deca',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .gray600,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 4.0, 0.0, 0.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child:
                                                '${snapshotActivo.data!.urlImagen}' ==
                                                        ''
                                                    ? Text('No image')
                                                    : Image.network(
                                                        '${snapshotActivo.data!.urlImagen}' +
                                                            '?alt=media',
                                                        width: 30,
                                                        height: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            '${snapshotActivo.data!.nombre} marca ${snapshotActivo.data!.marca}',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 4.0, 24.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Toca aquí para obtener más información de este activo',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Lexend Deca',
                                                  color: Color(0xFF8B97A2),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .grayIcon,
                                            size: 24.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 20.0, 0.0, 0.0),
                              child: Text(
                                'Técnico a asignar',
                                style:
                                    FlutterFlowTheme.of(context).headlineSmall,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 20.0, 15.0, 0.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_buscar) {
                                      _buscar = false;
                                      buscarTecnicoController.text = '';
                                    } else {
                                      _buscar = true;
                                      _focusBusqueda.requestFocus();
                                    }
                                  });
                                },
                                icon: Icon(Icons.search_rounded),
                              ),
                            )
                          ],
                        ),
                        if (_buscar)
                          Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 20.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextField(
                                    focusNode: _focusBusqueda,
                                    controller: buscarTecnicoController,
                                    decoration: InputDecoration(
                                      hintText: 'Buscar...',
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.search,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        Container(
                          height: 400,
                          child: StreamBuilder<List<Usuario>>(
                            stream: UserHelper().obtenerTecnicoStreams(
                                buscarTecnicoController.text),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.data != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return SelectableContainer(
                                        selectedBorderColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        selectedBorderColorIcon:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        unselectedBorderColor:
                                            FlutterFlowTheme.of(context)
                                                .primary
                                                .withOpacity(0.6),
                                        selectedBackgroundColorIcon:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        borderRadius: 12,
                                        padding: 3,
                                        selected:
                                            snapshot.data![index].seleccionado,
                                        onValueChanged: (newValue) async {
                                          _listaTecnicos = snapshot.data!;
                                          for (var element in snapshot.data!) {
                                            if (element.seleccionado) {
                                              element.seleccionado = false;
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(element.uid)
                                                  .update(element.toMap());
                                            }
                                          }
                                          snapshot.data![index].seleccionado =
                                              true;
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(snapshot.data![index].uid)
                                              .update(snapshot.data![index]
                                                  .toMap());

                                          setState(() {
                                            _selectedUser =
                                                snapshot.data![index];
                                            _buttonsEnabled = true;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(7),
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
                                                            width: 50,
                                                            height: 50,
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
                                                          snapshot.data![index]
                                                              .nombre
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primaryText,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        StreamBuilder<int?>(
                                                            stream: CasosController()
                                                                .getTotalCasosCountTecnico(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .uid!),
                                                            builder: (BuildContext
                                                                    context,
                                                                snapshotCasosPendientes) {
                                                              if (snapshotCasosPendientes
                                                                      .data !=
                                                                  null) {
                                                                return Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      width: 6,
                                                                      height: 6,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: snapshotCasosPendientes.data! >
                                                                                0
                                                                            ? Color.fromARGB(
                                                                                255,
                                                                                204,
                                                                                15,
                                                                                15)
                                                                            : Color.fromARGB(
                                                                                255,
                                                                                15,
                                                                                204,
                                                                                88),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    Text(
                                                                      snapshotCasosPendientes.data! >
                                                                              0
                                                                          ? 'Ocupado'
                                                                          : 'Disponible',
                                                                      style: TextStyle(
                                                                          color: FlutterFlowTheme.of(context)
                                                                              .primaryText,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return Text('');
                                                              }
                                                            }),
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
                                                                    right: 20),
                                                          ),
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
                                                        child: StreamBuilder<
                                                                int?>(
                                                            stream: CasosController()
                                                                .getTotalCasosCountTecnico(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .uid!),
                                                            builder: (BuildContext
                                                                    context,
                                                                snapshotCasosPendientes) {
                                                              if (snapshotCasosPendientes
                                                                          .data !=
                                                                      null &&
                                                                  snapshotCasosPendientes
                                                                          .data! >
                                                                      0) {
                                                                return Text(
                                                                  snapshotCasosPendientes
                                                                              .data ==
                                                                          1
                                                                      ? '1 Caso Pendiente'
                                                                      : '${snapshotCasosPendientes.data} Casos Pendientes'
                                                                          .toString(),
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText),
                                                                );
                                                              } else {
                                                                return Text(
                                                                    'Ningún Caso Pendiente'
                                                                        .toString(),
                                                                    maxLines: 3,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                    ));
                                                              }
                                                            }),
                                                      ),
                                                    ],
                                                  ),

                                                  //Lineas
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 12.0, 8, 24.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_buttonsEnabled) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FuncioInfo(
                                                usuario: _selectedUser!,
                                              )),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.info,
                                  color: FlutterFlowTheme.of(context).tertiary,
                                ),
                                text: 'Información Técnico',
                                options: FFButtonOptions(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: _buttonsEnabled
                                      ? FlutterFlowTheme.of(context).info
                                      : FlutterFlowTheme.of(context).accent2,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 12.0, 15.0, 24.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_buttonsEnabled &&
                                      _selectedUser != null) {
                                    _selectedUser!.seleccionado = false;
                                    _selectedUser!.ocupado = true;
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(_selectedUser!.uid)
                                        .update(_selectedUser!.toMap());
                                    Caso caso = widget.caso;
                                    caso.uidTecnico =
                                        _selectedUser!.uid.toString().trim();
                                    caso.asignado = true;
                                    await FirebaseFirestore.instance
                                        .collection('casos')
                                        .doc(caso.uid.trim())
                                        .update(caso.toMap());
                                    ChatMensajes? imagenAdjunta =
                                        await ControladorChat()
                                            .obtenerImagenCaso(caso.uidActivo
                                                .toString()
                                                .trim());
                                    Activo? activo = await ActivoController()
                                        .cargarActivoUID(
                                            caso.uidDependencia
                                                .toString()
                                                .trim(),
                                            caso.uidActivo.toString().trim());
                                    Dependencia? dependencia =
                                        await ControladorDependencias()
                                            .cargarDependenciaUID(caso
                                                .uidDependencia
                                                .toString()
                                                .trim());
                                    await ChatBot().abrirConversacionTecnico(
                                        caso,
                                        activo.nombre,
                                        dependencia.nombre,imagen: imagenAdjunta);
                                    Room room1 = Room(
                                        createdAt: DateTime.now(),
                                        updatedAt: DateTime.now(),
                                        userIds: [
                                          'S4AhLGE5jlVQHF020eqwhJeu1R72',
                                          'BsgabMF49ifIXBBqN9lXlgAyxPL2'
                                        ]);
                                   

                                    int cantidadCasos = await CasosController()
                                        .getTotalCasosCountSinAsignarFuture();
                                    if (cantidadCasos==0) {
                                      await FirebaseFirestore.instance
                                        .collection('rooms')
                                        .doc(room1.uid)
                                        .set(room1.toMap());

                                    ChatMensajes mensaje1 = ChatMensajes(
                                        authorId:
                                            'BsgabMF49ifIXBBqN9lXlgAyxPL2',
                                        updatedAt: DateTime.now(),
                                        mensaje:
                                            'No quedan casos pendientes',
                                        tipo: 'text',
                                        fechaHora: DateTime.now());
                                    await FirebaseFirestore.instance
                                        .collection('rooms')
                                        .doc(room1.uid)
                                        .collection('messages')
                                        .add(mensaje1.toMapText());
                                    }else{
                                      
                                      await FirebaseFirestore.instance
                                        .collection('rooms')
                                        .doc(room1.uid)
                                        .set(room1.toMap());

                                    ChatMensajes mensaje1 = ChatMensajes(
                                        authorId:
                                            'BsgabMF49ifIXBBqN9lXlgAyxPL2',
                                        updatedAt: DateTime.now(),
                                        mensaje:
                                            'Hay $cantidadCasos pendientes de asignar',
                                        tipo: 'text',
                                        fechaHora: DateTime.now());
                                    await FirebaseFirestore.instance
                                        .collection('rooms')
                                        .doc(room1.uid)
                                        .collection('messages')
                                        .add(mensaje1.toMapText());
                                    }
                                    
                                    Navigator.pop(context);
                                  }
                                },
                                icon: Icon(
                                  Icons.check_rounded,
                                  color: FlutterFlowTheme.of(context).tertiary,
                                ),
                                text: 'Asignar Técnico',
                                options: FFButtonOptions(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: _buttonsEnabled
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).accent2,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x55000000),
                        offset: Offset(0.0, 2.0),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child:
                      Container() /* Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 40.0),
                    child: FutureBuilder<List<Usuario?>>(
                      future: UserHelper().obtenerUsuariosadmin(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FuncionarioInformation(usuario: snapshot.data![index]!),
                          ),
                        );
                                },
                                child: tarjetaTecnico(snapshot.data![index]!));
                            },
                          );
                        }else{
                        return Container();
                      }
                      },
                    ),
                  )*/
                  ,
                ),
                if (widget.caso.solucionado)
                  FutureBuilder<Usuario?>(
                      future: AuthHelper()
                          .getUsuarioFutureUID(widget.caso.finalizadoPor!),
                      builder: (context, AsyncSnapshot<Usuario?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryText,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x55000000),
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 40.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              'Este caso lo atendió',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF8B97A2),
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                  child: Image.network(
                                                    valueOrDefault<String>(
                                                      snapshot.data!.urlImagen,
                                                      'https://images.unsplash.com/photo-1654537736400-bfae7cd99bac?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNXx8fGVufDB8fHx8&auto=format&fit=crop&w=900&q=60',
                                                    ),
                                                    width: 40.0,
                                                    height: 40.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 0.0, 12.0, 0.0),
                                                  child: Text(
                                                    snapshot.data!.nombre ??
                                                        ''.maybeHandleOverflow(
                                                          maxChars: 90,
                                                          replacement: '…',
                                                        ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Urbanist',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryText,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x55000000),
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 40.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              'Este caso lo atendió',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'Lexend Deca',
                                                    color: Color(0xFF8B97A2),
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                          Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      })
              ],
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
                        widget.caso,
                      ),
                      //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                    ),
                  ],
                ),
              ),
            ),
          if (blurEliminarCaso)
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

                      child: _cajaEliminarCaso(
                        context,
                        '¿Esta seguro que desea eliminar este caso?, una vez hecho ya no atenderan tu solicitud',
                        'activo',
                        widget.caso.uid.toString(),
                      ),
                      //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cajaAdvertencia(BuildContext context, mensaje, objetoaEliminar) {
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
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.47,
                          child: TextFormField(
                            onChanged: (value) async {},
                            controller: textControllerDescripcionReporte,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Escriba sus razones',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
                                ),
                            maxLines: 7,
                            minLines: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      if (auth.currentUser != null) {
                        log('Current user: ' +
                            auth.currentUser!.uid.toString());
                        Caso casoAregistrar = widget.caso;

                        types.User otheruser =
                            types.User(id: "S4AhLGE5jlVQHF020eqwhJeu1R72");
                        types.Room room = await FirebaseChatCore.instance
                            .createRoom(otheruser);
                        ChatMensajes mensaje1 = ChatMensajes(
                            authorId: auth.currentUser!.uid.trim(),
                            updatedAt: DateTime.now(),
                            mensaje: 'Nuevo reporte',
                            tipo: 'text',
                            fechaHora: DateTime.now());
                        await FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(room.id)
                            .collection('messages')
                            .add(mensaje1.toMapText())
                            .then((value) async {
                          Usuario tecnico = await AuthHelper()
                                  .getUsuarioFutureUID(
                                      casoAregistrar.finalizadoPor!) ??
                              Usuario();

                          ChatMensajes mensaje2 = ChatMensajes(
                              authorId: auth.currentUser!.uid.trim(),
                              updatedAt: DateTime.now(),
                              mensaje:
                                  'Detalles del caso reportado: \n-Fecha: ${DateFormat('dd MMM', 'es_CO').format(casoAregistrar.fecha)}\n-Hora: ${DateFormat('hh:mm a', 'es_CO').format(casoAregistrar.fecha)}\n-Era urgente: ${(casoAregistrar.prioridad ? 'Sí' : 'No')}\n-Técnico que cerro el caso: ${tecnico.nombre}\n-Descripción del problema: ${casoAregistrar.descripcion}',
                              tipo: 'text',
                              fechaHora: DateTime.now());
                          await FirebaseFirestore.instance
                              .collection('rooms')
                              .doc(room.id)
                              .collection('messages')
                              .add(mensaje2.toMapText())
                              .then((value) async {
                            ChatMensajes mensaje3 = ChatMensajes(
                                authorId: auth.currentUser!.uid.trim(),
                                updatedAt: DateTime.now(),
                                mensaje:
                                    'Razón: ${textControllerDescripcionReporte.text}',
                                tipo: 'text',
                                fechaHora: DateTime.now());
                            await FirebaseFirestore.instance
                                .collection('rooms')
                                .doc(room.id)
                                .collection('messages')
                                .add(mensaje3.toMapText());
                          });
                        });

                        String? token =
                            await FirebaseMessaging.instance.getToken();
                        List<String> usuarios = [
                          auth.currentUser!.uid,
                          'S4AhLGE5jlVQHF020eqwhJeu1R72',
                        ];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatWidget(
                              currentUserToken: token,
                              otherUserToken: null,
                              nombre: 'Jefe de la Oficina de las TIC',
                              usuarios: usuarios,
                              uid: room.id.trim(),
                              otroUsuario: Usuario(
                                  nombre: 'Jefe de la Oficina de las TIC',
                                  uid: 'S4AhLGE5jlVQHF020eqwhJeu1R72',
                                  urlImagen:
                                      'https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/Funcionarios%2F1216973345.jpg?alt=media&token=39c258f1-feae-43fa-b89e-de16b9513ffc1216973345.jpg'),
                              caso: casoAregistrar,
                            ),
                          ),
                        );
                      }
                    },
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

  Widget _cajaEliminarCaso(BuildContext context, mensaje, objetoaEliminar, id) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 300,
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
                    'Advertencia',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      var res = await eliminarObjeto(id);
                      if (res.contains('ok')) {
                        Navigator.pop(context);
                      }
                    },
                    text: 'Sí, deseo eliminar este caso',
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
                            blurEliminarCaso = false;
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

  Future<String> eliminarObjeto(String id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    int countMensajes = await ControladorChat()
        .primerMensaje(auth.currentUser!.uid.toString().trim());
    if (countMensajes == 0) {
      ControladorChat().removerConversacionesRepetidas(
          auth.currentUser!.uid, widget.caso.uidSolicitante);
    }
    widget.caso.finalizadoPor = 'PaAQ6DjhL1Yl45h1bloNerwPFt82';
    await CasosController()
        .marcarCasoComoresuelto(widget.caso, 'PaAQ6DjhL1Yl45h1bloNerwPFt82');
    int totalCasos = await CasosController()
        .getTotalCasosCountSolicitanteFuture(widget.caso.uidSolicitante.trim());
    log('eliminarObjeto: totalCasos: ' + totalCasos.toString());
    log('eliminarObjeto: current user uid: ' + auth.currentUser!.uid.trim());
    List<ChatMensajes> rooms = await ControladorChat()
        .obetnerRoomsPorUID(auth.currentUser!.uid.trim());
    log('rooms lenght:' + rooms.length.toString());
    if (totalCasos == 0) {
      for (var room in rooms) {
        log('rooms uid:' + room.uidRoom);
        ChatMensajes mensaje0 = ChatMensajes(
            authorId: auth.currentUser!.uid.trim(),
            updatedAt: DateTime.now(),
            mensaje: 'He cerrado el ultimo caso pendiente',
            tipo: 'text',
            fechaHora: DateTime.now());
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(room.uidRoom)
            .collection('messages')
            .add(mensaje0.toMapText());
        ChatMensajes mensaje1 = ChatMensajes(
            authorId: auth.currentUser!.uid.trim(),
            updatedAt: DateTime.now(),
            mensaje:
                'No se han encontrado más casos abiertos, el chat se cerrara a continuación',
            tipo: 'text',
            fechaHora: DateTime.now());
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(room.uidRoom)
            .collection('messages')
            .add(mensaje1.toMapText());
        await ControladorChat().disminuirTurno();
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(room.uidRoom)
            .update({
          'uid': room.uidRoom,
          'sinRespuesta': false,
          'finalizado': true,
        });
      }
    }

    var res = await CasosController().removeCaso(widget.caso.uid);

    return res;
  }
}

class tarjetaTecnico extends StatelessWidget {
  const tarjetaTecnico(
    this.tecnico, {
    Key? key,
  }) : super(key: key);
  final Usuario tecnico;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Text(
                    'Información del solicitante',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF8B97A2),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.network(
                          valueOrDefault<String>(
                            tecnico.urlImagen,
                            'https://images.unsplash.com/photo-1654537736400-bfae7cd99bac?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNXx8fGVufDB8fHx8&auto=format&fit=crop&w=900&q=60',
                          ),
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 12.0, 0.0),
                        child: Text(
                          tecnico.nombre.toString().maybeHandleOverflow(
                                maxChars: 90,
                                replacement: '…',
                              ),
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {},
                text: 'Chat',
                icon: Icon(
                  Icons.forum_outlined,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  width: 110.0,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
