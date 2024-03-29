import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_dependencias.dart';
import 'package:login2/model/dependencias.dart';

import 'package:login2/model/usuario.dart';
import 'package:login2/vistas/perfil/PerfilMOD/home.dart';

import '../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../flutter_flow/flutter_flow_drop_down2.dart';

File? image;
late String filename;

class FuncionarioFormWidget extends StatefulWidget {
  final Usuario? usuario;
  FuncionarioFormWidget({this.usuario});

  @override
  _FuncionarioFormState createState() => _FuncionarioFormState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;

class _FuncionarioFormState extends State<FuncionarioFormWidget> {
  String _password = '';
  bool _dropdownErrorColor = false;
  double fuerzaContrasenia = 0.0;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  late DateTime picked;
  late String cargoController;
  Dependencia? areaController;
  late String roleController;
  late String telefonoController;
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  int posicionArea = 0;
  void _pickDateDialog() async {
    picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.utc(2000, 1, 1),
      firstDate: DateTime(1600),
      lastDate: DateTime(2100),
    ))!;

    setState(() {
      _fechanacimientoController.text =
          '${picked.year} - ${picked.month} - ${picked.day}';
    });
  }

  late List<Usuario> items;

  late TextEditingController _nombreController;
  late TextEditingController _identificacionController;
  late TextEditingController _cargoController;
  late TextEditingController _areaController;
  late TextEditingController _fechanacimientoController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _telefonoController;
  int anchominimo = 640;

  double iconSize = 20;
  String? _urlImagen;
  final _formKey = GlobalKey<FormState>();

  //nuevo imagen
  String? funcionarioImage;

  pickerCam() async {
    var img = await ImagePicker().pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = File(img.path);
      setState(() {});
    }
  }

  pickerGallery() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }
  //fin nuevo imagen

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.usuario == null) {
      _nombreController = new TextEditingController();
      _identificacionController = new TextEditingController();
      _cargoController = new TextEditingController();
      _areaController = new TextEditingController();
      _fechanacimientoController = new TextEditingController();

      _emailController = new TextEditingController();
      _passwordController = new TextEditingController();
      _confirmPasswordController = TextEditingController(text: "");
      _telefonoController = new TextEditingController();
    }else{
      _nombreController = new TextEditingController(text: widget.usuario!.nombre);
      _identificacionController = new TextEditingController(text: widget.usuario!.identificacion);
      _cargoController = new TextEditingController(text: widget.usuario!.cargo);
      _areaController = new TextEditingController(text: widget.usuario!.area);
      _fechanacimientoController = new TextEditingController(text: widget.usuario!.fechaNacimiento);

      _emailController = new TextEditingController(text: widget.usuario!.email);
      _passwordController = new TextEditingController(text: widget.usuario!.password);
      _confirmPasswordController = TextEditingController(text: widget.usuario!.password);
      _telefonoController = new TextEditingController(text: widget.usuario!.telefono);
    }
  }

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic tamanio_padding = (MediaQuery.of(context).size.width < anchominimo)
        ? EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10)
        : EdgeInsetsDirectional.fromSTEB(80, 10, 80, 10);

    dynamic anchoColumnaWrap = MediaQuery.of(context).size.width * 0.95;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 199, 209, 216),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 209, 216),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Color.fromARGB(255, 43, 45, 46),
            size: 32,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).primaryColor),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _decidirImagen()),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          pickerGallery();
                        },
                        text: 'Subir Imagen',
                        icon: Icon(
                          Icons.photo,
                          color: FlutterFlowTheme.of(context).primaryColor,
                          size: 20,
                        ),
                        options: FFButtonOptions(
                          height: 40,
                          color: Color.fromARGB(255, 241, 245, 242),
                          textStyle: FlutterFlowTheme.of(context).bodyText1,
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          pickerCam();
                        },
                        text: 'Tomar Foto   ',
                        icon: Icon(
                          Icons.photo_camera,
                          color: FlutterFlowTheme.of(context).primaryColor,
                          size: 20,
                        ),
                        options: FFButtonOptions(
                          height: 40,
                          color: Color.fromARGB(255, 241, 245, 242),
                          textStyle: FlutterFlowTheme.of(context).bodyText1,
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          validator: (true)
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                }
                              : null,
                          controller: _nombreController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Ingresa el nombre....',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 12, 88, 28),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          validator: (true)
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                }
                              : null,
                          controller: _emailController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Ingrese el correo  electrónico...',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: Color.fromARGB(255, 12, 88, 28),
                              size: 21,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          focusNode: focusNodePassword,
                          controller: _passwordController,
                          obscureText: _obscureTextPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Ingrese su contraseña...',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              _obscureTextPassword
                                  ? FontAwesomeIcons.key
                                  : FontAwesomeIcons.eyeSlash,
                              color: Color.fromARGB(255, 12, 88, 28),
                              size: 21,
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty)
                              return 'Por favor ingrese una contraseña';
                            if (value.length < 6)
                              return 'Por favor ingrese una contraseña de por lo menos 6 digítos';
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          focusNode: focusNodeConfirmPassword,
                          controller: _confirmPasswordController,
                          obscureText: _obscureTextConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Confirme su contraseña...',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              _obscureTextPassword
                                  ? FontAwesomeIcons.key
                                  : FontAwesomeIcons.eyeSlash,
                              color: Color.fromARGB(255, 12, 88, 28),
                              size: 21,
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Repita la contraseña';
                            if (value != _password)
                              return 'Las contraseñas no coinciden';
                            return null;
                          },
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          validator: (true)
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                }
                              : null,
                          maxLength: 10,
                          controller: _identificacionController,
                          obscureText: false,
                          decoration: InputDecoration(
                            counterStyle: TextStyle(color: Colors.black),
                            labelText: 'Identificación',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Ingrese el número de identidad',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.badge,
                              size: 22,
                              color: Color.fromARGB(255, 12, 88, 28),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          validator: (true)
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                }
                              : null,
                          maxLength: 10,
                          controller: _telefonoController,
                          obscureText: false,
                          decoration: InputDecoration(
                            counterStyle: TextStyle(color: Colors.black),
                            labelText: 'Teléfono',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Ingrese el número de Teléfono',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Color.fromARGB(255, 12, 88, 28),
                              size: 22,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          validator: (true)
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                }
                              : null,
                          controller: _cargoController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Cargo',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Ingrese cargo del funcionario...',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 12, 88, 28),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                      
                      FutureBuilder<List<Dependencia>>(
                        future: ControladorDependencias().cargarDependencias(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Container(
                              width: anchoColumnaWrap,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 30, 10, 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 5, 0, 20),
                                                child: FlutterFlowDropDown<
                                                    Dependencia>(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 45,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Color.fromARGB(
                                                            207, 0, 0, 0),
                                                      ),
                                                  hintText: 'Area...',
                                                  fillColor:Color.fromARGB(255, 214, 219, 216),
                                                  elevation: 2,
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderWidth: 0,
                                                  borderRadius: 8,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(12, 4, 12, 4),
                                                  hidesUnderline: true,
                                                  value: snapshot
                                                      .data![posicionArea],
                                                  initialOption: snapshot
                                                      .data![posicionArea],
                                                  options: List.generate(
                                                      snapshot.data!.length,
                                                      (index) =>
                                                          DropdownMenuItem(
                                                              value: snapshot
                                                                  .data![index],
                                                              child: Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .nombre
                                                                    .toString(),
                                                              ))),
                                                  onChanged: (val) {
                                                    if (val != null) {
                                                      setState(() {
                                                        posicionArea = snapshot
                                                            .data!
                                                            .indexOf(val);
                                                        areaController = val;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: FlutterFlowDropDown2<String>(
                          options: ['Funcionario','Técnico'],
                          onChanged: (value) {
                            setState(() {
                              roleController = value;
                            });
                          },
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          textStyle:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(207, 0, 0, 0),
                                  ),
                          hintText: 'Rol y permiso...',
                          fillColor:Color.fromARGB(255, 214, 219, 216),
                          elevation: 2,
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          borderRadius: 8,
                          margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                          hidesUnderline: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: TextFormField(
                          validator: (true)
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                }
                              : null,
                          controller: _fechanacimientoController,
                          readOnly: true,
                          obscureText: false,
                          onTap: () {
                            _pickDateDialog();
                          },
                          decoration: InputDecoration(
                            labelText: 'Fecha de nacimiento',
                            labelStyle: FlutterFlowTheme.of(context).bodyText2,
                            hintText: 'Selecione la fecha de Nacimiento...',
                            hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 219, 216),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      //nuevo imagen
                      if (_formKey.currentState!.validate()) {
                        final funcionarioReference = FirebaseFirestore.instance
                            .collection('users')
                            .doc(_emailController.text.toLowerCase());

                        _registrarFuncionario(funcionarioReference);
                        Get.snackbar('Registro Exitoso', 'Bienvenido');
                      }
                    },
                    text: 'REGISTRARME',
                    icon: Icon(
                      Icons.person_add,
                      size: 22,
                    ),
                    options: FFButtonOptions(
                      width: 160,
                      height: 45,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryBtnText),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
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

  _registrarFuncionario(DocumentReference funcionarioReference) async {
    var fullPathImage;
    try {
      var fullImageName = '${_identificacionController.text}' + '.jpg';

      final Reference ref =
          FirebaseStorage.instance.ref().child('/Funcionarios/$fullImageName');
      final UploadTask task = ref.putFile(image!);

      var part1 =
          'https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/Funcionarios%2F${_identificacionController.text}.jpg?alt=media&token=39c258f1-feae-43fa-b89e-de16b9513ffc';

      fullPathImage = part1 + fullImageName;
    } catch (e) {
      fullPathImage =
          'https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/Funcionarios%2FSinFoto%2Fuser.png?alt=media&token=c66046fc-1a49-4f0e-8136-d59d90500e4d';
    }

    if (_emailController.text.isNotEmpty) {
      Usuario user = Usuario(
          urlImagen: fullPathImage,
          nombre: _nombreController.text,
          identificacion: _identificacionController.text,
          email: _emailController.text.toLowerCase(),
          password: _passwordController.text,
          cargo: _cargoController.text,
          area: areaController!.uid,
          role: roleController=='Técnico'?"admin":"funcionario",
          telefono: _telefonoController.text);
      await AuthHelper.signupWithEmail(user).then((_) async {
        image = null;
        await AuthHelper.signInWithEmail(
            email: 'superadmin@gmail.com', password: '921025Admon');
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilGeneral(),
          ),
          (r) => false,
        );
      });
    }
  }

  Widget _decidirImagen() {
    if (_urlImagen != null && _urlImagen!.isNotEmpty && image == null) {
      return Image.network(
        _urlImagen!,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      );
    } else {
      return image == null
          ? Image.asset(
              'assets/diseño_interfaz/useruser.png',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            )
          : Image.file(
              image!,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            );
    }
  }

  Widget _contraseniaEsSegura(double valor) {
    if (valor > 0.0 && valor <= 0.25) {
      return Text("Insegura",
          style: TextStyle(
              color: Colors.red, fontFamily: "Poppins-Medium", fontSize: 17));
    } else if (valor > 0.25 && valor <= 0.5) {
      return Text("Poco Segura",
          style: TextStyle(
              color: Color.fromARGB(255, 163, 151, 39),
              fontFamily: "Poppins-Medium",
              fontSize: 17));
    } else if (valor > 0.5 && valor <= 0.75) {
      return Text("Segura",
          style: TextStyle(
              color: Colors.blue, fontFamily: "Poppins-Medium", fontSize: 17));
    } else if (valor > 0.75 && valor <= 1) {
      return Text("Muy segura",
          style: TextStyle(
              color: Color.fromARGB(255, 31, 153, 35),
              fontFamily: "Poppins-Medium",
              fontSize: 17));
    } else {
      return Text("",
          style: TextStyle(
              color: Colors.transparent,
              fontFamily: "Poppins-Medium",
              fontSize: 17));
    }
  }
}
