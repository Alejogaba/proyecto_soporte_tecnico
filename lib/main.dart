import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:login2/lista_funcionarios/funcionarioForm.dart';
import 'package:login2/perfil/PerfilMOD/home.dart';
import 'package:login2/routes/my_routes.dart';
import 'package:login2/state/homepageStateProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';


import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'index.dart';
import 'model/usuario.dart';

void main() async {
  Locale _local = Locale('es', 'CO');
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();
  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
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
      home: Example(),
      navigatorKey: Get.key,
      getPages: routes(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
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
                    .doc(snapshot.data?.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final userDoc = snapshot.data;
                    final user = userDoc?.data();
                    Usuario usuario =
                        Usuario.mapeo(user as Map<String, dynamic>);
                    if (usuario.role == 'admin') {
                      return HomeView();
                    } else if (usuario.role == 'funcionario') {
                      return InterfazPrincipalWidget();
                    } else {
                      return LoginWidget();
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
            return LoginWidget();
          }),
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'interfazPrincipal';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Conversaciones': ConversacionesWidget(),
      'interfazPrincipal': InterfazPrincipalWidget(),
      'Perfil': HomeView(),
      'gestionfuncionario': FuncionarioFormWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: Colors.white,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).grayIcon,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              size: 24.0,
            ),
            activeIcon: Icon(
              Icons.chat_bubble_rounded,
              size: 24.0,
            ),
            label: 'Chats',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 24.0,
            ),
            activeIcon: Icon(
              Icons.home_rounded,
              size: 24.0,
            ),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: 24.0,
            ),
            activeIcon: Icon(
              Icons.account_circle,
              size: 24.0,
            ),
            label: 'Profile',
            tooltip: '',
          )
        ],
      ),
    );
  }
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    ConversacionesWidget(),
    InterfazPrincipalWidget(),
  ];

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
          haptic: true, // haptic feedback
          tabBorderRadius: 16,
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
          duration: Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
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
              horizontal: 140, vertical: 10), // navigation bar padding
          tabs: [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.heart,
              text: 'Likes',
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
