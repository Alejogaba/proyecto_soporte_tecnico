import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:login2/Widgets/snackbar.dart';
import 'package:login2/main.dart';
import 'package:translator/translator.dart';

import '../auth/firebase_auth/auth_helper.dart';
import '../model/usuario.dart';
import '../vistas/cambiar_password/cambiar_password_widget.dart';
import '../vistas/login/theme.dart';
import '../vistas/perfil/PerfilMOD/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
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
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: focusNodeEmail,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: 'Ingrese su email ',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 131, 125, 125),
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 17.0),
                          ),
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
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                            focusNode: focusNodePassword,
                            controller: _passwordController,
                            obscureText: _obscureTextPassword,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: 'Contraseña',
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 131, 125, 125),
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Por favor ingrese una contraseña';
                              if (value.length < 6) return 'Mínimo 6 digítos';
                              return null;
                            },
                            onFieldSubmitted: (value) async {
                              try {
                                Usuario? user;
                                FirebaseFirestore _db =
                                    FirebaseFirestore.instance;
                                var existe = await _db
                                    .collection("users")
                                    .doc(_emailController.text
                                        .trim()
                                        .toLowerCase())
                                    .get();
                                Logger().v(existe.exists);
                                if (existe.exists) {
                                  user = await AuthHelper.signInWithEmail(
                                      email: _emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: _passwordController.text,
                                      estaCreado: true);
                                } else {
                                  user = await AuthHelper.signInWithEmail(
                                      email: _emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: _passwordController.text);
                                }
                                if (user != null) {
                                  print("Ingreso Exitoso");
                                  bool esNuevoUsuario = await AuthHelper()
                                      .checkPasswordMatch(
                                          user.uid!, _passwordController.text);
                                  if (esNuevoUsuario) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CambiarPasswordWidget()));
                                  } else {
                                    if (user.role == 'admin') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PerfilGeneral()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NuevaNavBarFuncionario()));
                                    }
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 25, 78, 52),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(255, 16, 68, 29),
                        Color.fromARGB(255, 226, 222, 218)
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Color.fromARGB(255, 9, 85, 32),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'WorkSansBold'),
                      ),
                    ),
                    onPressed: () async {
                        try {
                                      Usuario? user =
                                          await AuthHelper.signInWithEmail(
                                              email: _emailController.text
                                                  .trim()
                                                  .toLowerCase(),
                                              password:
                                                  _passwordController.text);
                                     if (user != null) {
                                          print("Ingreso Exitoso");
                                          bool esNuevoUsuario =
                                              await AuthHelper()
                                                  .checkPasswordMatch(user.uid!,
                                                      _passwordController.text);
                                          if (esNuevoUsuario) {
                                             Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CambiarPasswordWidget()));
                                          } else {
                                            if (user.role == 'admin') {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PerfilGeneral()));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NuevaNavBarFuncionario()));
                                          }
                                          }
                                        }
                                    } on FirebaseException catch (e) {
                                      Logger().e(e.message);
                                      var errorTraducido =
                                          await traducir(e.message.toString());
                                      Get.snackbar('Error', errorTraducido,
                                          icon: Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                          colorText:
                                              Color.fromARGB(255, 114, 14, 7));
                                    } catch (e) {
                                      Logger().e(e);
                                    }
                    }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvido su contraseña?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(26, 255, 0, 0),
                          Colors.white,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Or',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansMedium'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(
                      context, const Text('Facebook button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(
                      context, const Text('Google button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSignInButton() {
    CustomSnackBar(context, const Text('Login button pressed'));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
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
