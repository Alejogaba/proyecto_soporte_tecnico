import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';

import 'package:login2/index.dart';
import 'package:login2/main.dart';
import 'package:login2/model/usuario.dart';
import 'package:login2/vistas/perfil/PerfilMOD/home.dart';

import '../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import '../../auth/firebase_auth/auth_util.dart';
import 'package:image_picker/image_picker.dart';

File? image;
late String filename;

class FuncionarioFormWidget extends StatefulWidget {
  const FuncionarioFormWidget(Usuario usuario, {Key? key}) : super(key: key);

  @override
  _FuncionarioFormState createState() => _FuncionarioFormState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;

class _FuncionarioFormState extends State<FuncionarioFormWidget> {
  String _password = '';
  double fuerzaContrasenia = 0.0;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  late DateTime picked;
  late String cargoController;
  late String areaController;
  late String roleController;
  late String telefonoController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
    _nombreController = new TextEditingController();
    _identificacionController = new TextEditingController();
    _cargoController = new TextEditingController();
    _areaController = new TextEditingController();
    _fechanacimientoController = new TextEditingController();

    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _confirmPasswordController = TextEditingController(text: "");
    _telefonoController = new TextEditingController();
  }

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: FlutterFlowTheme.of(context).gray600,
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
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          height: 40,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle: FlutterFlowTheme.of(context).bodyText1,
                          elevation: 2,
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
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          height: 40,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle: FlutterFlowTheme.of(context).bodyText1,
                          elevation: 2,
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.person,
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.alternate_email,
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              _obscureTextPassword
                                  ? FontAwesomeIcons.key
                                  : FontAwesomeIcons.eyeSlash,
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
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _contraseniaEsSegura(fuerzaContrasenia),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                              child: FlutterPasswordStrength(
                                backgroundColor:
                                    Color.fromARGB(71, 158, 158, 158),
                                height: 15,
                                width: 130,
                                radius: 15,
                                password: _password,
                                strengthCallback: (strength) {
                                  debugPrint(strength.toString());
                                  fuerzaContrasenia = strength;
                                },
                              )),
                        ],
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              _obscureTextPassword
                                  ? FontAwesomeIcons.key
                                  : FontAwesomeIcons.eyeSlash,
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.badge,
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
                          maxLength: 10,
                          controller: _telefonoController,
                          obscureText: false,
                          decoration: InputDecoration(
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                            prefixIcon: Icon(
                              Icons.phone,
                              size: 18,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyText1,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: FlutterFlowDropDown<String>(
                          options: ['Jefe', 'Secretario'],
                          onChanged: (value) {
                            setState(() {
                              cargoController = value;
                            });
                          },
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          textStyle:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(207, 0, 0, 0),
                                  ),
                          hintText: 'Seleccione el cargo...',
                          fillColor: Color(0xFFF1F4F8),
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
                        child: FlutterFlowDropDown<String>(
                          options: [
                            'Regimen subsidiado',
                            'Secretaria de planeacion',
                            'Comisaria de familia',
                            'Adulto mayor',
                            'Desarrollo comunitario',
                            'Oficina juridica',
                            'Sisben',
                            'Secretaria de hacienda',
                            'Secretaria de gobierno',
                            'Despacho del Alcalde',
                            'Tesoreria',
                            'Secretaría de Servicios Sociales',
                            'Secretaria de planeación',
                            'Oficina de Atención a Víctimas',
                            'Recaudo'
                          ],
                          onChanged: (value) {
                            setState(() {
                              areaController = value;
                            });
                          },
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          textStyle:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(207, 0, 0, 0),
                                  ),
                          hintText: 'Seleccione el área...',
                          fillColor: Color(0xFFF1F4F8),
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
                        child: FlutterFlowDropDown<String>(
                          options: ['funcionario'],
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
                          fillColor: Color(0xFFF1F4F8),
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
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
          cargo: cargoController,
          area: areaController,
          role: 'funcionario',
          telefono: _telefonoController.text);
      await AuthHelper.signupWithEmail(user).then((_) async {
        image = null;
        await AuthHelper.signInWithEmail(
            email: 'superadmin@gmail.com', password: '1216973345');
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
              'assets/diseño_interfaz/User2.jpg',
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
