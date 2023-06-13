

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:login2/Widgets/sign_in.dart';
import 'package:login2/index.dart';
import 'package:login2/vistas/lista_funcionarios/funcionarioForm.dart';
import 'package:login2/vistas/login/LoginMOD.dart';
import 'package:login2/main.dart';
import 'package:login2/vistas/perfil/PerfilMOD/home.dart';

import '../model/usuario.dart';





routes() => [
      GetPage(name: "/home", page: () => PrincipalPagina()),
      GetPage(name: "/principal", page: () => NuevaNavBar()),
      GetPage(name: "/listafuncio", page: () => ListaFuncionariosWidget()),
      GetPage(name: "/loginmod", page: () => LoginPage()),
      GetPage(name: "/loguear", page: () => SignIn()),
      GetPage(name: "/funcionario", page: () => FuncionarioFormWidget(Usuario())),
      
      GetPage(name: "/perfilgen", page: () => PerfilGeneral()),
    
    
    ];
