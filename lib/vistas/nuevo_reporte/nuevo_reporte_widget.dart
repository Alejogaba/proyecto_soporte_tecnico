import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/backend/controlador_chat.dart';
import 'package:login2/flutter_flow/chat/chat_page_firebase.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/chatBot.dart';
import 'package:login2/model/chat_mensajes.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/utils/utilidades.dart';
import 'package:login2/vistas/lista_reportes/lista_reportes_widget.dart';

import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/upload_data.dart';
import '../../main.dart';
import '../../model/caso.dart';
import '../../model/usuario.dart';
import '../chat/chat_widget.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'nuevo_reporte_model.dart';
export 'nuevo_reporte_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image/image.dart' as img;

class NuevoReporteWidget extends StatefulWidget {
  const NuevoReporteWidget({
    Key? key,
    this.dependencia,
    required this.activo,
  }) : super(key: key);
  final Activo activo;
  final Dependencia? dependencia;

  @override
  _NuevoReporteWidgetState createState() => _NuevoReporteWidgetState();
}

class _NuevoReporteWidgetState extends State<NuevoReporteWidget>
    with TickerProviderStateMixin {
  String _prioridadSeleccionada = 'Urgencia Crítica';

  Map<String, int> prioridadMap = {
    'Urgencias Críticas': 1,
    'Solicitudes Regulares': 2,
    'Solicitudes Generales': 3,
  };
  late NuevoReporteModel _model;
  TextEditingController dependenciaController = TextEditingController();
  TextEditingController activoController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  late FFUploadedFile archivoSubido;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _prioridad = false;

  final animationsMap = {
    'rowOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.elasticOut,
          delay: 0.ms,
          duration: 1080.ms,
          begin: Offset(41.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NuevoReporteModel());
    dependenciaController.text = widget.dependencia!.nombre;
    activoController.text = widget.activo.nombre;
    /* _model.pricePerNightController ??= TextEditingController(
        text: formatNumber(
      widget.propertyRef!.price,
      formatType: FormatType.decimal,
      decimalType: DecimalType.automatic,
    ));

    
    _model.notesController ??=
        TextEditingController(text: widget.propertyRef!.notes);
        **/
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          buttonSize: 46.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Nuevo reporte',
          style: FlutterFlowTheme.of(context).headlineSmall,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'DEPENDENCIA',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: dependenciaController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: '\ Dependencia',
                            hintStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: FlutterFlowTheme.of(context).grayIcon,
                                ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 24.0),
                            prefixIcon: Icon(
                              Icons.apartment,
                              color: Color.fromARGB(255, 12, 71, 20),
                              size: 28,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).headlineMedium,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese un valor';
                            }
                            return null;
                          },
                        ),
                      ),
                      Divider(
                        height: 32.0,
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).lineGray,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'EQUIPOS DE COMPUTO',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                        child: TextFormField(
                          controller: activoController,
                          readOnly: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: '\ equipo de computo',
                            hintStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Urbanist',
                                  color: FlutterFlowTheme.of(context).grayIcon,
                                ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 24.0),
                            prefixIcon: Icon(
                              Icons.computer,
                              color: Color.fromARGB(255, 12, 71, 20),
                              size: 28,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).headlineMedium,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese un valor';
                            }
                            return null;
                          },
                        ),
                      ),
                      Divider(
                        height: 32.0,
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).lineGray,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'DETALLES DEL PROBLEMA',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
                        child: TextFormField(
                          controller: descripcionController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Detalles',
                            hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).lineGray,
                                width: 2.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 24.0),
                          ),
                          style: FlutterFlowTheme.of(context).titleMedium,
                          maxLines: 6,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese un valor';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        'PRIORIDAD',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Urbanist',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _prioridad,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    _prioridad = value;
                                  });
                                }
                              },
                              activeColor: Color.fromARGB(220, 180, 57,
                                  55), // Color ligeramente en rojo
                            ),
                            Text(
                              'Es Urgente',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: Color.fromARGB(255, 66, 20, 18),
                                    fontWeight: FontWeight.w500,
                                  ), // Texto en rojo
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'SUBIR FOTO (OPCIONAL)',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Urbanist',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      Divider(
                        height: 20.0,
                        thickness: 2.0,
                        color: Colors.transparent,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            allowPhoto: true,
                            backgroundColor:
                                FlutterFlowTheme.of(context).tertiary,
                            textColor: FlutterFlowTheme.of(context).dark600,
                            pickerFontFamily: 'Lexend Deca',
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) =>
                                  validateFileFormat(m.storagePath, context))) {
                            setState(() => _model.isDataUploading = true);
                            var selectedUploadedFiles = <FFUploadedFile>[];
                            var downloadUrls = <String>[];
                            try {
                              showUploadMessage(
                                context,
                                'Subiendo imagen...',
                                showLoading: true,
                              );
                              selectedUploadedFiles = selectedMedia
                                  .map((m) => FFUploadedFile(
                                        name: m.storagePath.split('/').last,
                                        bytes: m.bytes,
                                        height: m.dimensions?.height,
                                        width: m.dimensions?.width,
                                        blurHash: m.blurHash,
                                      ))
                                  .toList();
                              archivoSubido = selectedUploadedFiles[0];
                              downloadUrls = (await Future.wait(
                                selectedMedia.map(
                                  (m) async =>
                                      await uploadData(m.storagePath, m.bytes),
                                ),
                              ))
                                  .where((u) => u != null)
                                  .map((u) => u!)
                                  .toList();
                            } finally {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _model.isDataUploading = false;
                            }
                            if (selectedUploadedFiles.length ==
                                    selectedMedia.length &&
                                downloadUrls.length == selectedMedia.length) {
                              setState(() {
                                _model.uploadedLocalFile =
                                    selectedUploadedFiles.first;
                                _model.uploadedFileUrl = downloadUrls.first;
                                log(_model.uploadedFileUrl);
                              });
                              showUploadMessage(
                                  context, '!Se ha subido la imagen!');
                            } else {
                              setState(() {});
                              showUploadMessage(
                                  context, 'No se pudo subir la imagen');
                              return;
                            }
                          }
                        },
                        child: Container(
                          width: 340.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 4, 58, 25),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 13, 107, 16),
                                    spreadRadius: 3)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl: valueOrDefault<String>(
                                _model.uploadedFileUrl,
                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-property-finder-834ebu/assets/lhbo8hbkycdw/addCoverImage@2x.png',
                              ),
                              width: double.infinity,
                              height: 180.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,

                          //child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          /*children: [Container()] 
                                List.generate(productProductRecordList.length,
                                    (productIndex) {
                              final productProductRecord =
                                  productProductRecordList[productIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                  ),
                                  child: Container(
                                    width: 200.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context).accent1,
                                          FlutterFlowTheme.of(context).primary
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(0.34, -1.0),
                                        end: AlignmentDirectional(-0.34, 1.0),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0.0),
                                        bottomRight: Radius.circular(30.0),
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 5.0, 5.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 14.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://cdn-icons-png.flaticon.com/512/2/2338.png',
                                                    width: 100.0,
                                                    height: 281.8,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),*/

                          //),
                        ).animateOnPageLoad(
                            animationsMap['rowOnPageLoadAnimation']!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      //Falta validar
                      FirebaseAuth auth = FirebaseAuth.instance;
                      ChatMensajes? mensaje3;
                      if (auth.currentUser != null) {
                        log('Current user: ' +
                            auth.currentUser!.uid.toString());
                        Caso casoAregistrar = Caso(
                            prioridad: _prioridad,
                            fecha: DateTime.now(),
                            uidDependencia: widget.dependencia!.uid,
                            uidSolicitante: auth.currentUser!.uid,
                            uidActivo: widget.activo.uid,
                            descripcion: descripcionController.text,
                            urlAdjunto: _model.uploadedFileUrl);
                        await CasosController().addModCaso(casoAregistrar);
                        final collectionRef = FirebaseFirestore.instance
                            .collection('dependencias')
                            .doc(widget.dependencia!.uid)
                            .collection('activos')
                            .doc(widget.activo.uid);
                        await collectionRef.update({'casosPendientes': true});

                        List<Usuario> usuariosObtenidos =
                            await UserHelper().obtenerUsuarios();
                        log('lista tecnicos: ' + usuariosObtenidos.toString());
                        ChatBot botRespuesta = await ChatBot()
                            .handleMessageChatBot(
                                descripcionController.text, widget.activo);
                        if (botRespuesta.id != 0) {
                          types.User otheruser =
                              types.User(id: "PaAQ6DjhL1Yl45h1bloNerwPFt82");
                          types.Room room = await FirebaseChatCore.instance
                              .createRoom(otheruser);
                          String? tieneChatFinalizado = await ControladorChat()
                              .buscarChatFinalizado(
                                  "PaAQ6DjhL1Yl45h1bloNerwPFt82",
                                  auth.currentUser!.uid);
                          await FirebaseChatCore.instance.deleteRoom(room.id);
                          room = await FirebaseChatCore.instance
                              .createRoom(otheruser);
                                                  if (usuariosObtenidos.length > 0) {
                            final collectionRef = FirebaseFirestore.instance
                                .collection('rooms')
                                .doc(room.id);
                            ChatMensajes mensaje1 = ChatMensajes(
                                authorId: auth.currentUser!.uid.trim(),
                                updatedAt: DateTime.now(),
                                mensaje:
                                    'Requiero servicio técnico para ${widget.activo.nombre}',
                                tipo: 'text',
                                fechaHora: DateTime.now());
                            await FirebaseFirestore.instance
                                .collection('rooms')
                                .doc(room.id)
                                .collection('messages')
                                .add(mensaje1.toMapText());
                            if (descripcionController.text.isNotEmpty) {
                              ChatMensajes mensaje2 = ChatMensajes(
                                  authorId: auth.currentUser!.uid.trim(),
                                  updatedAt:
                                      DateTime.now().add(Duration(seconds: 1)),
                                  mensaje: '${descripcionController.text}',
                                  tipo: 'text',
                                  fechaHora:
                                      DateTime.now().add(Duration(seconds: 1)));
                              await FirebaseFirestore.instance
                                  .collection('rooms')
                                  .doc(room.id)
                                  .collection('messages')
                                  .add(mensaje2.toMapText());
                            }

                            if (_model.uploadedFileUrl.isNotEmpty) {
                              img.Image? image =
                                  img.decodeImage(archivoSubido.bytes!);
                              int width = image!.width;
                              int height = image!.height;
                              mensaje3 = ChatMensajes(
                                  height: height,
                                  width: width,
                                  size: archivoSubido.bytes!.length,
                                  uri: _model.uploadedFileUrl,
                                  authorId: auth.currentUser!.uid.trim(),
                                  updatedAt:
                                      DateTime.now().add(Duration(seconds: 2)),
                                  mensaje: (archivoSubido.name != null &&
                                          archivoSubido.name!.isNotEmpty)
                                      ? archivoSubido.name!
                                      : 'Archivo_adjunto.jpg',
                                  fechaHora:
                                      DateTime.now().add(Duration(seconds: 2)));
                              await FirebaseFirestore.instance
                                  .collection('rooms')
                                  .doc(room.id)
                                  .collection('messages')
                                  .add(mensaje3.toMapImage());
                            }

                            if (otheruser.id !=
                                "PaAQ6DjhL1Yl45h1bloNerwPFt82") {
                              if (_prioridad) {
                                ChatMensajes? chatTurno =
                                    await ControladorChat()
                                        .obtenerUltimoEnColaUrgente(room.id);
                                await ControladorChat().aumentarTurno();
                                List<ChatMensajes> listaRooms =
                                    await ControladorChat()
                                        .obetnerRoomsSinFinalizar();
                                for (var element in listaRooms) {
                                  await chatBotAdvertencia(element.uidRoom);
                                }

                                if (chatTurno == null) {
                                  await collectionRef.update({
                                    'uid': room.id,
                                    'sinRespuesta': true,
                                    'finalizado': false,
                                    'turno': 1,
                                    'prioridad': _prioridad
                                  });
                                } else {
                                  await collectionRef.update({
                                    'uid': room.id,
                                    'sinRespuesta': true,
                                    'finalizado': false,
                                    'turno': chatTurno.turno! + 1,
                                    'prioridad': _prioridad
                                  });
                                }
                              } else {
                                ChatMensajes? chatTurno =
                                    await ControladorChat()
                                        .obtenerUltimoEnCola(room.id);

                                if (chatTurno == null) {
                                  await collectionRef.update({
                                    'uid': room.id,
                                    'sinRespuesta': true,
                                    'finalizado': false,
                                    'turno': 1,
                                    'prioridad': _prioridad
                                  });
                                } else {
                                  await collectionRef.update({
                                    'uid': room.id,
                                    'sinRespuesta': true,
                                    'finalizado': false,
                                    'turno': chatTurno.turno! + 1,
                                    'prioridad': _prioridadSeleccionada
                                  });
                                }
                              }
                            } else {
                              await collectionRef.update({
                                'uid': room.id,
                                'sinRespuesta': true,
                                'finalizado': false,
                              });
                            }
                          }
                          List<String> usuarios = [
                            auth.currentUser!.uid,
                            'PaAQ6DjhL1Yl45h1bloNerwPFt82',
                          ];
                          String? token =
                              await FirebaseMessaging.instance.getToken();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatWidget(
                                  currentUserToken: token,
                                  otherUserToken: null,
                                  nombre: 'Asistente Virtual',
                                  msjChatBot: descripcionController.text,
                                  usuarios: usuarios,
                                  uid: room.id.trim(),
                                  otroUsuario: Usuario(
                                      nombre: 'Asistente Virtual',
                                      uid: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
                                      urlImagen:
                                          'https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/Funcionarios%2F1000000000.jpg?alt=media&token=39c258f1-feae-43fa-b89e-de16b9513ffc1000000000.jpg'),
                                  caso: casoAregistrar,
                                  mensajeImagen: mensaje3,
                                  activo: widget.activo,
                                  dependencia: widget.dependencia),
                            ),
                          );
                        } else {
                          if (_model.uploadedFileUrl.isNotEmpty) {
                            img.Image? image =
                                img.decodeImage(archivoSubido.bytes!);
                            int width = image!.width;
                            int height = image!.height;
                            mensaje3 = ChatMensajes(
                                height: height,
                                width: width,
                                size: archivoSubido.bytes!.length,
                                uri: _model.uploadedFileUrl,
                                authorId: auth.currentUser!.uid.trim(),
                                updatedAt:
                                    DateTime.now().add(Duration(seconds: 2)),
                                mensaje: (archivoSubido.name != null &&
                                        archivoSubido.name!.isNotEmpty)
                                    ? archivoSubido.name!
                                    : 'Archivo_adjunto.jpg',
                                fechaHora:
                                    DateTime.now().add(Duration(seconds: 2)));
                            ChatBot().abrirConversacionesTecnicos(
                                auth,
                                casoAregistrar,
                                widget.activo.uid,
                                widget.dependencia!.uid,imagen: mensaje3);
                          }else{
                            ChatBot().abrirConversacionesTecnicos(
                                auth,
                                casoAregistrar,
                                widget.activo.uid,
                                widget.dependencia!.uid,imagen: mensaje3);
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NuevaNavBarFuncionario(),
                            ),
                          );
                        }
                      }
                    },
                    text: 'Enviar',
                    options: FFButtonOptions(
                      width: 200.0,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color.fromARGB(255, 17, 78, 32),
                      textStyle:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Urbanist',
                                color: FlutterFlowTheme.of(context).tertiary,
                              ),
                      elevation: 2.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chatBotAdvertencia(String room) async {
    ChatMensajes mensaje1 = ChatMensajes(
        //Pregunta si soluciono su problema
        authorId: 'PaAQ6DjhL1Yl45h1bloNerwPFt82',
        updatedAt: DateTime.now().add(Duration(seconds: 1)),
        mensaje:
            'Disculpa el retraso de 1 turno, este se debe a que surgio un caso urgente. Estamos trabajando para resolverlo lo antes posible. Gracias por tu paciencia',
        tipo: 'text',
        fechaHora: DateTime.now().add(Duration(seconds: 1)));
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(room)
        .collection('messages')
        .add(mensaje1.toMapText());
  }
}
