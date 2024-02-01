import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:intl/intl.dart';
import 'package:login2/index.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../auth/firebase_auth/auth_helper.dart';
import '../../../../backend/controlador_activo.dart';
import '../../../../backend/controlador_caso.dart';
import '../../../../backend/controlador_dependencias.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../model/activo.dart';
import '../../../../model/caso.dart';
import '../../../../model/dependencias.dart';
import '../../../../model/usuario.dart';

class FuncioInfo extends StatefulWidget {
  const FuncioInfo({Key? key, required this.usuario}) : super(key: key);
  final Usuario usuario;
  @override
  _FuncioInfoState createState() => _FuncioInfoState();
}

final funcionarioReference =
    FirebaseDatabase.instance.reference().child('funcionario');

class _FuncioInfoState extends State<FuncioInfo> {
  late List<Usuario> items;
  bool isMediaUploading1 = false;
  String uploadedFileUrl1 = '';

  bool isMediaUploading2 = false;
  String uploadedFileUrl2 = '';

  late String companySizeValue;

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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 229, 230),
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Detalles del Funcionario',
          style: FlutterFlowTheme.of(context)
              .titleLarge
              .override(fontFamily: 'Poppins', fontSize: 22),
        ),
        backgroundColor: Color.fromARGB(255, 219, 229, 230),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent, // Navigation bar
          statusBarColor: Color.fromARGB(255, 219, 229, 230), // Status bar
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      "${widget.usuario.urlImagen}",
                      width: 135,
                      height: 135,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 220,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                "${widget.usuario.nombre}",
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                        fontFamily: 'Poppins', fontSize: 30),
                              ),
                            ),
                            Text(
                              "${widget.usuario.cargo}",
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                      fontFamily: 'Poppins', fontSize: 18),
                            ),
                            FutureBuilder<Dependencia?>(
                                future: ControladorDependencias()
                                    .cargarDependenciaUID(widget.usuario.area!),
                                builder: (BuildContext context,
                                    snapshotDependencia) {
                                  if (snapshotDependencia.connectionState ==
                                          ConnectionState.done &&
                                      snapshotDependencia.data != null) {
                                    return Text(
                                      snapshotDependencia.data!.nombre
                                          .toString(),
                                      maxLines: 3,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 19),
                                    );
                                  } else {
                                    return Text(
                                      '',
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    );
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      await launchUrl(Uri(
                                          scheme: 'mailto',
                                          path: widget.usuario.email,
                                          query: {
                                            'subject': 'Asunto',
                                            'body': ' ',
                                          }
                                              .entries
                                              .map((MapEntry<String, String>
                                                      e) =>
                                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                              .join('&')));
                                    },
                                    child: IconTile(
                                      backColor: Color.fromARGB(255, 9, 92, 53),
                                      imgAssetPath: "assets/email.png",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await launchUrl(Uri(
                                        scheme: 'tel',
                                        path: widget.usuario.telefono,
                                      ));
                                    },
                                    child: IconTile(
                                      backColor: Color.fromARGB(255, 9, 92, 53),
                                      imgAssetPath: "assets/call.png",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Lineas
                Container(
                  width: MediaQuery.of(context).size.width - 58,
                  height: 0.4,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 2, 5, 2),
                                        child: Icon(
                                          Icons.email,
                                          color: Color.fromARGB(216, 9, 39, 25),
                                          size: 24,
                                        ),
                                      ),
                                      Text(
                                        "Datos personales",
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 10, 5, 5),
                                    child: SizedBox(
                                      child: Text(
                                        "Correo electrónico: \n${widget.usuario.email}",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 5, 5, 5),
                                    child: Text(
                                      "Teléfono: \n${widget.usuario.telefono}",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Lineas
                Container(
                  width: MediaQuery.of(context).size.width - 58,
                  height: 0.4,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 2, 5, 2),
                                        child: Icon(
                                          Icons.warning_rounded,
                                          color: Color.fromARGB(216, 9, 39, 25),
                                          size: 24,
                                        ),
                                      ),
                                      Text(
                                        "Casos Pendientes",
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: FutureBuilder<List<Caso>>(
                                      future: CasosController()
                                          .obtenerCasosPendientesFuture(
                                              uidTecnico: widget.usuario.uid
                                                  .toString()
                                                  .trim()),
                                      builder:
                                          (BuildContext context, snapshotCaso) {
                                        if (snapshotCaso.connectionState ==
                                                ConnectionState.done &&
                                            snapshotCaso.data != null &&
                                            snapshotCaso.data!.length > 0) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: ListView.builder(
                                              itemCount:
                                                  snapshotCaso.data!.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () =>
                                                      _navigateToFuncionario(
                                                          context,
                                                          snapshotCaso
                                                              .data![index]),
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        _navigateToFuncionario(
                                                            context,
                                                            snapshotCaso
                                                                .data![index]),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 16),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: FutureBuilder<
                                                              Usuario?>(
                                                          future: AuthHelper()
                                                              .getUsuarioFutureUID(
                                                                  snapshotCaso
                                                                      .data![
                                                                          index]
                                                                      .uidSolicitante),
                                                          builder: (BuildContext
                                                                  context,
                                                              snapshotUsuario) {
                                                            if (snapshotUsuario
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .done &&
                                                                snapshotUsuario
                                                                        .data !=
                                                                    null) {
                                                              return tarjetaCaso(
                                                                  context,
                                                                  snapshotCaso,
                                                                  index,
                                                                  snapshotUsuario
                                                                      .data!);
                                                            } else {
                                                              return Center(
                                                                child: SizedBox(
                                                                  width: 55,
                                                                  height: 55,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        3,
                                                                    color: FlutterFlowTheme.of(
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
                                          if (snapshotCaso.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: SizedBox(
                                                width: 55,
                                                height: 55,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                              child: Text(
                                                'No  hay casos asignados',
                                                style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Lineas
                Container(
                  width: MediaQuery.of(context).size.width - 58,
                  height: 0.4,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                /*
                Text(
                  "Galeria",
                  style: TextStyle(
                      color: Color(0xff242424),
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Color(0xffA5A5A5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color.fromARGB(255, 119, 119, 119))),
                        child: Image.asset(
                          "assets/interfaz/banner.png",
                          width: 135,
                          height: 135,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatearFecha(DateTime fecha) {
    final formateador = DateFormat('dd MMMM yyyy', 'es_CO');
    return formateador.format(fecha);
  }

  void _navigateToFuncionario(BuildContext context, Caso caso) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetalleReporteWidget(
                caso,
                esAdmin: true,
              )),
    );
  }

  Container tarjetaCaso(BuildContext context,
      AsyncSnapshot<List<Caso>> snapshot, int index, Usuario funcionario) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
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
                width: MediaQuery.of(context).size.width * 0.6,
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
                width: MediaQuery.of(context).size.width * 0.61,
                height: 0.4,
                color: const Color.fromARGB(160, 255, 255, 255),
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
}

class IconTile extends StatelessWidget {
  final String? imgAssetPath;
  final Color? backColor;

  IconTile({this.imgAssetPath, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Image.asset(
          imgAssetPath!,
          width: 20,
        ),
      ),
    );
  }
}
