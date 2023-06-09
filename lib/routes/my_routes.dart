

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:login2/index.dart';
import 'package:login2/lista_funcionarios/funcionarioForm.dart';
import 'package:login2/main.dart';

routes() => [
      GetPage(name: "/home", page: () => PrincipalPagina()),
      GetPage(name: "/principal", page: () => InterfazPrincipalWidget()),
      GetPage(name: "/gestionfuncio", page: () => FuncionarioFormWidget()),
    
    ];
