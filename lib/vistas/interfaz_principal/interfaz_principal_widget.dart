import 'package:auto_size_text/auto_size_text.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_dependencias.dart';
import 'package:login2/vistas/lista_activos_page/lista_activos_page_widget.dart';
import 'package:login2/vistas/login/LoginMOD.dart';
import 'package:login2/vistas/perfil/PerfilMOD/home.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../../model/usuario.dart';

import '../../model/dependencias.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'interfaz_principal_model.dart';
export 'interfaz_principal_model.dart';
import 'package:badges/badges.dart' as badges;

class InterfazPrincipalWidget extends StatefulWidget {
  const InterfazPrincipalWidget({Key? key}) : super(key: key);

  @override
  _InterfazPrincipalWidgetState createState() =>
      _InterfazPrincipalWidgetState();
}

class _InterfazPrincipalWidgetState extends State<InterfazPrincipalWidget> {
  late InterfazPrincipalModel _model;
  final double radius = 15;
  final Color circleColor = Colors.red;
  final Color fadeColor = Colors.green;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InterfazPrincipalModel());

    _model.textController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return SafeArea(
      bottom: false,
      child: Scaffold(
        /* appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        centerTitle: true,
         title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(Icons.apartment_sharp),
      SizedBox(width: 8.0), // Espacio entre el icono y el texto
      Text('Dependencias'),
    ],
  ),
      
        actions: [],
        elevation: 0,
      ),
      **/
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 4.0, 0.0, 0.0),
                                      child: Image.asset(
                                        'assets/images/chimichagua-removebg-preview-transformed.png',
                                        width: 71.1,
                                        height: 75.0,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 4.0, 0.0, 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            'Alcaldia de Chimichagua',
                                            minFontSize: 18,
                                            maxFontSize: 22,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Urbanist',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          AutoSizeText(
                                            'Servicio técnico',
                                            minFontSize: 14,
                                            maxFontSize: 16,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Urbanist',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
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
                                  IconButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PerfilGeneral(),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.settings,
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        size: 30,
                                      )),
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
                                width: MediaQuery.of(context).size.width - 38,
                                height: 0.6,
                                color: Color.fromARGB(179, 235, 229, 229),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              18.0, 26.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder<Usuario?>(
                                future: AuthHelper().cargarUsuarioDeFirebase(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data != null) {
                                    return Text(
                                      '¡Bienvenid@ ${snapshot.data!.nombre}!',
                                      style: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                          ),
                                    );
                                  } else {
                                    return Text(
                                      '¡Bienvenido!',
                                      style: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color: FlutterFlowTheme.of(context)
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 4.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.textController,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Buscar dependencia...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Urbanist',
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .grayIcon,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                          ),
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 8.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      print('Button pressed ...');
                                    },
                                    text: 'Buscar',
                                    options: FFButtonOptions(
                                      width: 100.0,
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Urbanist',
                                            color: Colors.white,
                                          ),
                                      elevation: 2.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
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
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: StreamBuilder<List<Dependencia>>(
                      stream: FirebaseFirestore.instance
                          .collection('dependencias')
                          .snapshots()
                          .map((QuerySnapshot querySnapshot) {
                        List<Dependencia> dependencias = [];
                        querySnapshot.docs.forEach((doc) => dependencias.add(
                            Dependencia.fromMap(
                                doc.data() as Map<String, dynamic>)));
                        return dependencias;
                      }),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
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
                        List<Dependencia> listViewPropertiesRecordList =
                            snapshot.data!;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewPropertiesRecordList.length,
                          itemBuilder: (context, listViewIndex) {
                            final listDependencias =
                                listViewPropertiesRecordList[listViewIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 12.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ListaActivosPageWidget(
                                              dependencia: listDependencias),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x32000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Hero(
                                          tag: valueOrDefault<String>(
                                            listDependencias.urlImagen,
                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/jyeiyll24v90/pixasquare-4ojhpgKpS68-unsplash.jpg' +
                                                '$listViewIndex',
                                          ),
                                          transitionOnUserGestures: true,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: valueOrDefault<String>(
                                                listDependencias.urlImagen,
                                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/jyeiyll24v90/pixasquare-4ojhpgKpS68-unsplash.jpg',
                                              ),
                                              width: double.infinity,
                                              height: 190.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 12.0, 16.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  listDependencias.nombre
                                                      .maybeHandleOverflow(
                                                    maxChars: 36,
                                                    replacement: '…',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Correo. ${listDependencias.correo}'
                                                      .maybeHandleOverflow(
                                                    maxChars: 90,
                                                    replacement: '…',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                              Text(
                                                'Teléfono. ${listDependencias.telefono}'
                                                    .maybeHandleOverflow(
                                                  maxChars: 90,
                                                  replacement: '…',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder<int>(
                                            stream: ControladorDependencias()
                                                .getTotalCasosCountDependencia(
                                                    listDependencias.uid),
                                            builder: (context, snapshot) {
                                              if (
                                                  snapshot.hasData) {
                                                if (snapshot.data! > 0) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        badges.Badge(
                                                          position: badges
                                                                  .BadgePosition
                                                              .topEnd(
                                                                  top: -10,
                                                                  end: -12),
                                                          showBadge: true,
                                                          ignorePointer: false,
                                                          onTap: () {
                                                            print(
                                                                'Abrir lista reportes');
                                                          },
                                                          badgeContent: Text(
                                                              snapshot.data
                                                                  .toString(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Urbanist',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .tertiary,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                          badgeAnimation: badges
                                                                  .BadgeAnimation
                                                              .fade(
                                                            animationDuration:
                                                                Duration(
                                                                    seconds: 2),
                                                            loopAnimation: true,
                                                            curve: Curves
                                                                .fastEaseInToSlowEaseOut,
                                                            colorChangeAnimationCurve:
                                                                Curves
                                                                    .easeInCubic,
                                                          ),
                                                          badgeStyle:
                                                              badges.BadgeStyle(
                                                            shape: badges
                                                                .BadgeShape
                                                                .circle,
                                                            badgeColor: Colors
                                                                .redAccent,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .redAccent,
                                                                width: 2),
                                                            elevation: 0,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6.0),
                                                          child: Text(
                                                            'Solicitudes de soporte técnico'
                                                                .maybeHandleOverflow(
                                                              maxChars: 90,
                                                              replacement: '…',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done &&
                                                  !(snapshot.hasData)) {
                                                return Container();
                                              } else {
                                                return Center(
                                                  child: Container(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            /*GNav(
    
      haptic: true, // haptic feedback
      tabBorderRadius: 16, 
      tabActiveBorder: Border.all(color:  FlutterFlowTheme.of(context).primary, width: 1), // tab button border
      backgroundColor: FlutterFlowTheme.of(context).primary,
      tabShadow: [BoxShadow(color: FlutterFlowTheme.of(context).primary.withOpacity(0.5), blurRadius: 8)], // tab button shadow
      curve: Curves.easeOutExpo, // tab animation curves
      duration: Duration(milliseconds: 900), // tab animation duration
      gap: 8, // the tab button gap between icon and text 
      color: FlutterFlowTheme.of(context).tertiary.withOpacity(0.7), // unselected icon color
      activeColor: FlutterFlowTheme.of(context).tertiary, // selected icon and text color
      iconSize: 30, // tab button icon size
      tabBackgroundColor: FlutterFlowTheme.of(context).tertiary.withOpacity(0.1), // selected tab background color
      padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10), // navigation bar padding
      tabs: [
      GButton(
        icon: Icons.home,
        text: 'Home',
        onPressed: () async {
           await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConversacionesWidget(),
                                        ),
                                       
                                      );
        },
      ),
      GButton(
        icon: Icons.heart_broken,
        text: 'Likes',
      ),
      
      ]
    )*/
          ],
        ),
      ),
    );
  }
}
