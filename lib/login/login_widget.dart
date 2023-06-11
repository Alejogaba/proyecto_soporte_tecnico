
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/index.dart';
import 'package:login2/lista_funcionarios/funcionarioForm.dart';
import 'package:login2/model/usuario.dart';
import 'package:login2/perfil/PerfilMOD/home.dart';
import 'package:translator/translator.dart';
import '../backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF4B39EF),
        body: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).tertiary,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: Image.asset(
                'assets/images/createAccount_BG@3x.jpg',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 432.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7.0,
                      color: Color(0x4D090F13),
                      offset: Offset(0.0, 3.0),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: Padding(
                  
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 30.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                'assets/images/chimichagua-removebg-preview-transformed.png',
                                width: 78.0,
                                height: 85.0,
                                fit: BoxFit.fitHeight,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'Alcaldia de Chimichagua',
                                    minFontSize: 18,
                                    maxFontSize: 25,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  AutoSizeText(
                                    'Servicio técnico',
                                    minFontSize: 14,
                                    maxFontSize: 18,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Iniciar sesión',
                                style:
                                    FlutterFlowTheme.of(context).displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Correo electró',
                                    labelStyle:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    hintText:
                                        'Ingrese su correo electrónico....',
                                    hintStyle:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .lineGray,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 24.0, 0.0, 24.0),
                                  ),
                                  style:
                                      FlutterFlowTheme.of(context).titleSmall,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor ingrese un correo eléctronico';
                                    }
                                    if (!RegExp(
                                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(value)) {
                                      return 'Por favor ingrese un correo válido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_model.passwordVisibility,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      hintText: 'Ingrese su contraseña',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .lineGray,
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
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 24.0, 24.0, 24.0),
                                      suffixIcon: InkWell(
                                        onTap: () => setState(
                                          () => _model.passwordVisibility =
                                              !_model.passwordVisibility,
                                        ),
                                        focusNode:
                                            FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Color(0xFF95A1AC),
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).titleSmall,
                                         validator: ( value) { 
                                    if (value!.isEmpty)
                                      return 'Por favor ingrese una contraseña';
                                    if (value.length < 6)
                                      return 'Mínimo 6 digítos';
                                    return null;
                                  },
                                    onFieldSubmitted: (value) async {
                                      try {
                                        var user;
                                        FirebaseFirestore _db =
                                            FirebaseFirestore.instance;
                                        var existe = await _db
                                            .collection("users")
                                            .doc(_emailController.text.trim()
                                                .toLowerCase())
                                            .get();
                                        Logger().v(existe.exists);
                                        if (existe.exists) {
                                          user =
                                              await AuthHelper.signInWithEmail(
                                                  email: _emailController.text.trim()
                                                      .toLowerCase(),
                                                  password:
                                                      _passwordController.text,
                                                  estaCreado: true);
                                        } else {
                                          user =
                                              await AuthHelper.signInWithEmail(
                                                  email: _emailController.text.trim()
                                                      .toLowerCase(),
                                                  password:
                                                      _passwordController.text);
                                        }
                                        if (user != null) {
                                          print("Ingreso Exitoso");
                                         if(user.role=='admin'){
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PerfilGeneral()));  
                                          }else{
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       PerfilGeneral()));  
                                          }                                }
                                      } catch (e) {
                                        print(e);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FFButtonWidget(
                                onPressed: () {
                                  print('Button-ForgotPassword pressed ...');
                                },
                                text: '¿Olvidó su contraseña?',
                                options: FFButtonOptions(
                                  width: 170.0,
                                  height: 30.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0x00FFFFFF),
                                  textStyle:
                                      FlutterFlowTheme.of(context).titleSmall,
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 4.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                   
                                      try {
                                        Usuario? user =
                                            await AuthHelper.signInWithEmail(
                                                email:
                                                    _emailController
                                                        .text.trim()
                                                        .toLowerCase(),
                                                password:
                                                    _passwordController.text);
                                        if (user != null) {
                                          print("Ingreso Exitoso");
                                          if(user.role=='admin'){
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       PerfilGeneral()));  
                                          }else{
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       PerfilGeneral()));  
                                          }
                                          
                                        }
                                      } on FirebaseException catch (e) {
                                        Logger().e(e.message);
                                        var errorTraducido = await traducir(
                                            e.message.toString());
                                        Get.snackbar('Error', errorTraducido,
                                            icon: Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                            colorText: Color.fromARGB(
                                                255, 114, 14, 7));
                                      } catch (e) {
                                        Logger().e(e);
                                      }
                                    
                                  },
                                  text: 'Iniciar Sesión',
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<String> traducir(String input) async {
    try {
      final translator = GoogleTranslator();
      var translation = await translator.translate(input, from: 'en', to: 'es');
      return translation.toString();
    } on FirebaseAuthException catch (e) {
      Logger().e('Error en el traductor: ' + e.message.toString());
      return "Ha ocurrido un error inesperado, revise su conexión a internet";
    }
  }
}
