import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_icons/line_icons.dart';
import 'package:login2/backend/controlador_activo.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/dependencias.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registrar_equipo_model.dart';
export 'registrar_equipo_model.dart';

class RegistrarEquipoWidget extends StatefulWidget {
  final Dependencia dependencia;
  final Activo? activoEdit;
  final String? barcode;
  const RegistrarEquipoWidget(
      {Key? key, required this.dependencia, this.activoEdit, this.barcode})
      : super(key: key);

  @override
  _RegistrarEquipoWidgetState createState() => _RegistrarEquipoWidgetState();
}

class _RegistrarEquipoWidgetState extends State<RegistrarEquipoWidget> {
  late RegistrarEquipoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistrarEquipoModel());

    _model.nombreController ??= TextEditingController();
    _model.marcaController ??= TextEditingController();
    _model.dependenciaController ??= TextEditingController();
    _model.barcodeController ??= TextEditingController();
    _model.detallesController ??= TextEditingController();
    _model.dependenciaController.text = widget.dependencia.nombre;
    if (widget.activoEdit != null) {
      _model.nombreController.text = widget.activoEdit!.nombre;
      _model.marcaController.text = widget.activoEdit!.marca;
      _model.detallesController.text = widget.activoEdit!.detalles;
      _model.uploadedFileUrl = widget.activoEdit!.urlImagen!;
      _model.barcodeController.text = widget.activoEdit!.barcode ?? '';
    } else {
      if (widget.barcode != null) {
        _model.barcodeController.text = widget.barcode!;
      }
    }
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Registrar equipo',
          style: FlutterFlowTheme.of(context).headlineMedium,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
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

                                downloadUrls = (await Future.wait(
                                  selectedMedia.map(
                                    (m) async => await uploadData(
                                        m.storagePath, m.bytes),
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
                            width: double.infinity,
                            height: 250.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
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
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: GestureDetector(
                              onTap: ()async => await abrirEscaner(),
                              child: Container(
                                width: double.infinity,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: GestureDetector(
                                  onTap: ()async => await abrirEscaner(),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        child: IconButton(
                                            onPressed: () async {
                                              await abrirEscaner();
                                            },
                                            icon: Icon(LineIcons.barcode)),
                                      ),
                                      GestureDetector(
                                        onTap: ()async => await abrirEscaner(),
                                        child: SizedBox(
                                          width: 300,
                                          child: GestureDetector(
                                            onTap: ()async => await abrirEscaner(),
                                            child: Container(
                                              width: 300,
                                              child: InkWell(
                                                onTap: ()async => await abrirEscaner(),
                                                child: TextFormField(
                                                  controller:
                                                      _model.barcodeController,
                                                  obscureText: false,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    hintText: 'Número de serial',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Urbanist',
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .grayIcon,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4.0),
                                                        topRight:
                                                            Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4.0),
                                                        topRight:
                                                            Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4.0),
                                                        topRight:
                                                            Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4.0),
                                                        topRight:
                                                            Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 24.0,
                                                                0.0, 24.0),
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .headlineSmall,
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(6, 16, 6, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Nombre del equipo',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 0.0, 6.0, 0.0),
                          child: TextFormField(
                            controller: _model.nombreController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Nombre del equipo',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(179, 21, 153, 61),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 21, 153, 61),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(150, 221, 11, 11),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 221, 11, 11),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 15.0, 0.0, 12.0),
                            ),
                            style: FlutterFlowTheme.of(context).headlineMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No deje este campo vacio';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 16.0, 6.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Marca',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 4.0, 6.0, 0.0),
                          child: TextFormField(
                            controller: _model.marcaController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Marca',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color:
                                        FlutterFlowTheme.of(context).grayIcon,
                                    fontWeight: FontWeight.w300,
                                  ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(179, 21, 153, 61),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 21, 153, 61),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(150, 221, 11, 11),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 221, 11, 11),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 15.0, 0.0, 12.0),
                            ),
                            style: FlutterFlowTheme.of(context).headlineMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No deje este campo vacio';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 16.0, 6.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Dependencia',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 4.0, 6.0, 0.0),
                          child: TextFormField(
                            controller: _model.dependenciaController,
                            obscureText: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Dependencia',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color:
                                        FlutterFlowTheme.of(context).grayIcon,
                                    fontWeight: FontWeight.w300,
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
                                  0.0, 15.0, 0.0, 12.0),
                            ),
                            style: FlutterFlowTheme.of(context).headlineMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No deje este campo vacio';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 16.0, 6.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Características adicionales',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 4.0, 6.0, 0.0),
                          child: TextFormField(
                            controller: _model.detallesController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText:
                                  'Ejemplo.\nPortátil VivoBook Pro 14\nCPU: Ryzen 5 5600H\nMemoria (RAM): 16GB\nTipo de memoria: DDR4\nCapacidad SSD: 512GB',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                      fontFamily: 'Urbanist',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(66, 21, 153, 61),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(169, 21, 153, 61),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(150, 221, 11, 11),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 221, 11, 11),
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.all(5),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(fontFamily: 'Urbanist', fontSize: 19),
                            minLines: 7,
                            maxLines: 16,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No deje este campo vacio';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 12.0),
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
                                  if (_formKey.currentState!.validate()) {
                                    Activo activo = Activo(
                                        uid: (widget.activoEdit != null)
                                            ? widget.activoEdit!.uid
                                            : '',
                                        nombre: _model.nombreController.text,
                                        marca: _model.marcaController.text,
                                        detalles:
                                            _model.detallesController.text,
                                        urlImagen: _model.uploadedFileUrl,
                                        casosPendientes: false);
                                    var res = await ActivoController()
                                        .addModActivo(context, activo,
                                            widget.dependencia.uid);

                                    if (res != 'error') {
                                      Get.snackbar('Equipo registrado',
                                          'Se ha registrado correctamente el activo',
                                          duration: Duration(seconds: 5),
                                          margin:
                                              EdgeInsets.fromLTRB(4, 8, 4, 0),
                                          snackStyle: SnackStyle.FLOATING,
                                          backgroundColor:
                                              Color.fromARGB(211, 28, 138, 46),
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          colorText: Color.fromARGB(
                                              255, 228, 219, 218));
                                      Navigator.of(context).pop(activo);
                                    } else {
                                      Get.snackbar('Error',
                                          'Ha ocurrido un error al momento de registrar el activo',
                                          duration: Duration(seconds: 5),
                                          margin:
                                              EdgeInsets.fromLTRB(4, 8, 4, 0),
                                          snackStyle: SnackStyle.FLOATING,
                                          backgroundColor:
                                              Color.fromARGB(220, 190, 28, 16),
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          colorText: Color.fromARGB(
                                              255, 228, 219, 218));
                                      Navigator.of(context).pop(activo);
                                    }
                                  }
                                },
                                text: 'Guardar',
                                options: FFButtonOptions(
                                  width: 120.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
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
                                  borderRadius: BorderRadius.circular(60.0),
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
          ),
        ),
      ),
    );
  }

  Future<void> abrirEscaner() async {
    await FlutterBarcodeScanner.scanBarcode(
            '#C62828', // scanning line color
            'Cancelar', // cancel button text
            true, // whether to show the flash icon
            ScanMode.BARCODE)
        .then((value) async {
      if (value.isNotEmpty &&
          value.length > 4) {
        setState(() {
          _model.barcodeController
                  .text =
              value
                  .removeAllWhitespace;
        });
      }
    });
  }
}
