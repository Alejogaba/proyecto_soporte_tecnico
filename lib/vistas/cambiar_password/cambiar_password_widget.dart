import 'package:login2/auth/firebase_auth/auth_helper.dart';

import '../perfil/PerfilMOD/home.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cambiar_password_model.dart';
export 'cambiar_password_model.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';

class CambiarPasswordWidget extends StatefulWidget {
  const CambiarPasswordWidget({
    Key? key,
  }) : super(key: key);

  @override
  _CambiarPasswordWidgetState createState() => _CambiarPasswordWidgetState();
}

class _CambiarPasswordWidgetState extends State<CambiarPasswordWidget> {
  late CambiarPasswordModel _model;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  double fuerzaContrasenia = 0.0;
  FocusNode _focusNode1 = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CambiarPasswordModel());
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
          'Cambiar Contraseña',
          style: FlutterFlowTheme.of(context).headlineMedium,
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
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: [
                        TextFormField(
                          focusNode: _focusNode1,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                            hintText: 'Ingrese su nueva contraseña...',
                            hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).lineGray,
                                width: 1.7,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.7,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.7,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.7,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 24.0, 0.0, 24.0),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty)
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
                          obscureText: !_model.passwordVisibility,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 15.0),
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
                                padding: const EdgeInsets.fromLTRB(0, 30, 5, 0),
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _focusNode2,
                        decoration: InputDecoration(
                          labelText: 'Repetir contraseña',
                          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                          hintText: 'Ingrese de nuevo su nueva contraseña...',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).lineGray,
                              width: 1.7,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.7,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.7,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.7,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => _model.passwordVisibility =
                                  !_model.passwordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              _model.passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF95A1AC),
                              size: 22.0,
                            ),
                          ),
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 24.0, 0.0, 24.0),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty)
                            return 'Repita la contraseña';
                          if (value != _password)
                            return 'Las contraseñas no coinciden';
                          return null;
                        },
                        obscureText: !_model.passwordVisibility,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      'Utiliza una combinación de letras mayúsculas y minúsculas, números y caracteres especiales para aumentar la complejidad de la contraseña, y asegúrate de que tu contraseña tenga al menos 6 caracteres de longitud para garantizar una mayor seguridad.',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String res = await AuthHelper()
                          .changePassword(_confirmPasswordController.text);
                      if (res != 'error') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PerfilGeneral()));
                      }
                    }
                  },
                  text: 'Cambiar mi contraseña',
                  options: FFButtonOptions(
                    width: 340.0,
                    height: 60.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Lexend Deca',
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                    elevation: 2.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
