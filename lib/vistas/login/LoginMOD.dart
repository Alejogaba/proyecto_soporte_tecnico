import 'package:flutter/material.dart';
import 'package:login2/vistas/login/sign_in.dart';

import 'sign_up.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../login/theme.dart';
import '../../utils/bubble_indicator_painter.dart';
import 'login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late LoginModel _model;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late PageController _pageController;
  late String cargoController;
  late String areaController;
  late String roleController;
  late String telefonoController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController.dispose();
    _model.dispose();
    super.dispose();
  }

  late TextEditingController _nombreController;
  late TextEditingController _identificacionController;
  late TextEditingController _cargoController;
  late TextEditingController _areaController;
  late TextEditingController _fechanacimientoController;

  late TextEditingController _confirmPasswordController;
  late TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
    _nombreController = new TextEditingController();
    _identificacionController = new TextEditingController();
    _cargoController = new TextEditingController();
    _areaController = new TextEditingController();
    _fechanacimientoController = new TextEditingController();

    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _confirmPasswordController = TextEditingController(text: "");
    _telefonoController = new TextEditingController();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 8, 71, 29)
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: <double>[0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 75.0),
                child: Image(
                    height:
                        MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                    fit: BoxFit.fill,
                    image: const AssetImage('assets/img/login_logo.png')),
              ),
          Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 4.0, 0.0, 0.0),
                                    child: Image.asset(
                                      'assets/images/chimichagua-removebg-preview-transformed.png',
                                      width: 55.1,
                                      height: 55.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
              
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: _buildMenuBar(context),
              ),
               //Lineas
              Container(
                width: MediaQuery.of(context).size.width - 45,
                height: 0.4,
                color: Color.fromARGB(179, 0, 0, 0),
              ),
              Expanded(
                flex: 2,
                child: PageView(
                  controller: _pageController,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (int i) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (i == 0) {
                      setState(() {
                        right = Colors.white;
                        left = Colors.black;
                      });
                    } else if (i == 1) {
                      setState(() {
                        right = const Color.fromARGB(255, 255, 255, 255);
                        left = const Color.fromARGB(255, 0, 0, 0);
                      });
                    }
                  },
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: const SignIn(),
                    ),
                    /* ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child:  SignUp(),
                    ),
                    **/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.only(top: 6.0),
      
      child: MaterialButton(
        highlightColor: Colors.transparent,
        splashColor: Color.fromARGB(255, 9, 85, 32),
        child: const Padding(
          
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
          child: Text(
            'Soporte Técnico',
            style: TextStyle(
                color: Color.fromARGB(255, 6, 68, 25),
                fontSize: 25.0,
                fontFamily: 'WorkSansBold'),
          ),
        ),
        onPressed: () {},

        /* child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            /*Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'Crear cuenta',
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            **/
          ],
        ),

        **/
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
