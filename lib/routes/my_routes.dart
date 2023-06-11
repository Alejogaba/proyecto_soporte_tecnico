

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:login2/index.dart';
import 'package:login2/vistas/lista_funcionarios/funcionarioForm.dart';
import 'package:login2/vistas/login/LoginMOD.dart';
import 'package:login2/main.dart';



routes() => [
      GetPage(name: "/home", page: () => PrincipalPagina()),
      GetPage(name: "/principal", page: () => NuevaNavBar()),
      //GetPage(name: "/gestionfuncio", page: () => FuncionarioFormWidget()),
      GetPage(name: "/listafuncio", page: () => ListaFuncionariosWidget()),
      GetPage(name: "/loginmod", page: () => LoginPage()),
    
    ];
