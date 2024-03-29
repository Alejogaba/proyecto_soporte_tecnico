import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:login2/vistas/Estadisticas/interfaz_estadisticas.dart';
import 'package:login2/vistas/lista_activos_funcionarios_page/lista_activos_funcionarios_page_widget.dart';
import 'package:login2/vistas/login/LoginMOD.dart';
import 'package:login2/vistas/perfil/PerfilMOD/home.dart';
import 'package:login2/routes/my_routes.dart';
import 'package:login2/state/homepageStateProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';

import 'package:firebase_core/firebase_core.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart';
import 'model/usuario.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();
  // Configuración de FirebaseMessaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _enablePersistence();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: RestartWidget(child: MyApp()),
  ));
}

Future<void> _enablePersistence() async {
  await FirebaseFirestore.instance.enableNetwork();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Obtener el token de registro

  // Hacer algo con el token, por ejemplo, guardarlo en Firebase o enviarlo a tu servidor

  // Procesar el mensaje recibido si es necesario
  if (message.notification != null) {
    // ...
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

Future<void> _firebaseMessagingForegroundHandler() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ));
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext csontext) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
      title: 'Alcaldia de todos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('es', 'CO'),
      ],
      locale: const Locale('es', 'CO'),
      initialRoute: '/home',
      navigatorKey: Get.key,
      getPages: routes(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {about:blank#blocked
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class PrincipalPagina extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageStateProvider())
      ],
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final userDoc = snapshot.data;
                    final user = userDoc?.data();
                    if (user == null) {
                      return LoginPage();
                    } else {
                      Usuario usuario =
                          Usuario.mapeo(user as Map<String, dynamic>);
                      if (usuario.role == 'admin') {
                        return NuevaNavBarAdmin();
                      } else if (usuario.role == 'funcionario') {
                        return NuevaNavBarFuncionario();
                      } else {
                        return LoginPage();
                      }
                    }
                  } else {
                    return Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }
            return LoginPage();
          }),
    );
  }
}

class NuevaNavBar extends StatefulWidget {
  @override
  _NuevaNavBarState createState() => _NuevaNavBarState();
}

class _NuevaNavBarState extends State<NuevaNavBar> {
  static const List<Widget> _widgetOptions = <Widget>[
    ConversacionesWidget(),
    InterfazPrincipalWidget(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primary,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: GNav(
          haptic: false, // haptic feedback
          tabBorderRadius: 6,
          tabActiveBorder: Border.all(
              color: FlutterFlowTheme.of(context).primary,
              width: 1), // tab button border
          backgroundColor: FlutterFlowTheme.of(context).primary,
          tabShadow: [
            BoxShadow(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
                blurRadius: 8)
          ], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 600), // tab animation duration
          gap: 2, // the tab button gap between icon and text
          color: FlutterFlowTheme.of(context)
              .tertiary
              .withOpacity(0.7), // unselected icon color
          activeColor: FlutterFlowTheme.of(context)
              .tertiary, // selected icon and text color
          iconSize: 30, // tab button icon size
          tabBackgroundColor: FlutterFlowTheme.of(context)
              .tertiary
              .withOpacity(0.1), // selected tab background color
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              vertical: 15), // navigation bar padding
          mainAxisAlignment: MainAxisAlignment.center,
          tabs: [
            GButton(
              icon: LineIcons.comment,
              text: 'Chat',
            ),
            GButton(
              icon: LineIcons.building,
              text: 'Equipos',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class NuevaNavBarFuncionario extends StatefulWidget {
  const NuevaNavBarFuncionario({Key? key}) : super(key: key);

  @override
  _NuevaNavBarStateFuncionario createState() => _NuevaNavBarStateFuncionario();
}

class _NuevaNavBarStateFuncionario extends State<NuevaNavBarFuncionario> {
  _NuevaNavBarStateFuncionario();

  static const List<Widget> _widgetOptions = <Widget>[
    ConversacionesWidget(),
    ListaActivosFuncionariosPageWidget(dependencia: null),
  ];

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primary,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: GNav(
          haptic: false, // haptic feedback

          tabBorderRadius: 6,
          tabActiveBorder: Border.all(
              color: FlutterFlowTheme.of(context).primary,
              width: 1), // tab button border
          backgroundColor: FlutterFlowTheme.of(context).primary,
          tabShadow: [
            BoxShadow(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
                blurRadius: 8)
          ], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 600), // tab animation duration
          gap: 2, // the tab button gap between icon and text
          color: FlutterFlowTheme.of(context)
              .tertiary
              .withOpacity(0.7), // unselected icon color
          activeColor: FlutterFlowTheme.of(context)
              .tertiary, // selected icon and text color
          iconSize: 28, // tab button icon size
          tabBackgroundColor: FlutterFlowTheme.of(context)
              .tertiary
              .withOpacity(0.1), // selected tab background color
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              vertical: 15), // navigation bar padding
          mainAxisAlignment: MainAxisAlignment.center,
          tabs: [
            GButton(
              icon: LineIcons.comment,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.computer,
              text: 'Equipos',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class NuevaNavBarAdmin extends StatefulWidget {
  const NuevaNavBarAdmin({Key? key}) : super(key: key);

  @override
  _NuevaNavBarStateAdmin createState() => _NuevaNavBarStateAdmin();
}

class _NuevaNavBarStateAdmin extends State<NuevaNavBarAdmin> {
  _NuevaNavBarStateAdmin();

  static const List<Widget> _widgetOptions = <Widget>[
    ConversacionesWidget(),
    InterfazPrincipalWidget(),
    InterfazEstadisticas()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primary,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: GNav(
          haptic: false, // haptic feedback
          tabBorderRadius: 6,
          tabActiveBorder: Border.all(
              color: FlutterFlowTheme.of(context).primary,
              width: 1), // tab button border
          backgroundColor: FlutterFlowTheme.of(context).primary,
          tabShadow: [
            BoxShadow(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
                blurRadius: 8)
          ], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 600), // tab animation duration
          gap: 2, // the tab button gap between icon and text
          color: FlutterFlowTheme.of(context)
              .tertiary
              .withOpacity(0.7), // unselected icon color
          activeColor: FlutterFlowTheme.of(context)
              .tertiary, // selected icon and text color
          iconSize: 28, // tab button icon size
          tabBackgroundColor: FlutterFlowTheme.of(context)
              .tertiary
              .withOpacity(0.1), // selected tab background color
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.0917,
              vertical: 15), // navigation bar padding
          mainAxisAlignment: MainAxisAlignment.center,
          tabs: [
            GButton(
              icon: LineIcons.comment,
              text: 'Chats',
            ),
            GButton(
              icon: LineIcons.home,
              text: 'Dependencias',
            ),
            GButton(
              icon: LineIcons.barChart,
              text: 'Estadísticas',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
