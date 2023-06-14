import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:login2/vistas/login/LoginMOD.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/top_bar.dart';
import '../../../app_state.dart';
import '../../../auth/firebase_auth/auth_helper.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../backend/schema/util/custom_clipper.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_model.dart';
import '../../../model/usuario.dart';
import '../perfil_model.dart';
import 'ProfileMenuWidget.dart';

class PerfilGeneral extends StatefulWidget {
  Usuario? usuario;
  @override
  _PerfilAdminState createState() => _PerfilAdminState();
}

class _PerfilAdminState extends State<PerfilGeneral> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserCredential? userCredential;
  Usuario? usuario;
  late PerfilModel _model;

  var hasContainerTriggered = false;
  final animationsMap = {
    'containerOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: false,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 350.ms,
          begin: Offset(-40.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());
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
      backgroundColor: Color.fromARGB(255, 229, 234, 238),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300.0,
              child: Stack(
                children: <Widget>[
                  Container(),
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.asset(
                            'assets/image/ban11.jpg',
                          ).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<Usuario?>(
                    future: AuthHelper().cargarUsuarioDeFirebase(
                        FirebaseAuth.instance.currentUser?.uid),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                          child: Align(
                            alignment: Alignment(0, 1),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 120,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF94CCF9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 13, 107, 16),
                                            spreadRadius: 4)
                                      ]),
                                  child: (snapshot.data!.urlImagen != null ||
                                          FirebaseAuth.instance.currentUser!
                                                  .photoURL !=
                                              null)
                                      ? Image.network(
                                          (snapshot.data!.urlImagen.isNotEmpty)
                                              ? snapshot.data!.urlImagen
                                              : (FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .photoURL !=
                                                      null)
                                                  ? FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .photoURL as String
                                                  : 'https://firebasestorage.googleapis.com/v0/b/proyecto-soporte-tecnico.appspot.com/o/Funcionarios%2FSinFoto%2Fuser.png?alt=media&token=c66046fc-1a49-4f0e-8136-d59d90500e4d',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/diseño_interfaz/User2.jpg',
                                          fit: BoxFit.fitHeight,
                                        ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  snapshot.data!.nombre!,
                                  style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                Text(
                                  snapshot.data!.role!,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  TopBar(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            /// -- MENU
            ProfileMenuWidget(
                title: "Gestión de dependencias",
                icon: LineAwesomeIcons.info,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Gestión de reportes",
                icon: LineAwesomeIcons.wallet,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Gestión de funcionarios",
                icon: LineAwesomeIcons.user_check,
                onPress: () {
                  //Get.toNamed('/gestionfuncio');
                  Get.toNamed('/listafuncio');
                }),
            const Divider(),
            const SizedBox(height: 10),
            ProfileMenuWidget(
                title: "Editar perfil",
                icon: LineAwesomeIcons.cog,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Cerrar sesión",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  Get.defaultDialog(
                    title: "Cerrar sesión",
                    titleStyle: const TextStyle(fontSize: 20),
                    content: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("¿Estás seguro, quieres cerrar sesión?"),
                    ),
                    confirm: Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await authManager.signOut();
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (r) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            side: BorderSide.none),
                        child: const Text("Si, a la vrga"),
                      ),
                    ),
                    cancel: OutlinedButton(
                        onPressed: () => Get.back(), child: const Text("No")),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
