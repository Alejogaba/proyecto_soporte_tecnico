import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:login2/Widgets/snackbar.dart';
import 'package:translator/translator.dart';
import '../model/usuario.dart';
import '../vistas/login/theme.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';


File? image;
late String filename;

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late DateTime picked;
  late String cargoController;
  late String areaController;
  late String roleController;
  late String telefonoController;
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();
  String _password = '';
  double fuerzaContrasenia = 0.0;

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

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
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 360.0,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (true)
                                ? (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'No deje este campo vacio';
                                    }
                                    return null;
                                  }
                                : null,
                            focusNode: focusNodeEmail,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                              hintText: 'Ingrese el correo..',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 131, 125, 125),
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: Column(children: <Widget>[
                            TextFormField(
                              focusNode: focusNodePassword,
                              controller: _passwordController,
                              obscureText: _obscureTextPassword,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: const Icon(
                                  FontAwesomeIcons.lock,
                                  color: Colors.black,
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignup,
                                  child: Icon(
                                    _obscureTextPassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 5, 0),
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
                          ]),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeConfirmPassword,
                            controller: _confirmPasswordController,
                            obscureText: _obscureTextConfirmPassword,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText: 'Confirmation',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextConfirmPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.go,
                            validator: (String? value) {
                              if (value!.isEmpty) return 'Repita la contraseña';
                              if (value != _password)
                                return 'Las contraseñas no coinciden';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 340.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        Get.toNamed('/funcionario');
                        Get.snackbar('Registro Exitoso',
                            'Ha sido registrado de manera exitosa, por favor inicie sesión a continuación');
                        print("Usuario Creado");
                      } on FirebaseException catch (e) {
                        var errorTraducido =
                            await traducir(e.message.toString());
                        Get.snackbar('Error', errorTraducido,
                            icon: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                            colorText: Color.fromARGB(255, 114, 14, 7));
                        print(e);
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ],
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

  void _toggleSignUpButton() {
    CustomSnackBar(context, const Text('SignUp button pressed'));
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
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
