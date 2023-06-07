

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:login2/index.dart';
import 'package:login2/lista_funcionarios/funcionarioForm.dart';

routes() => [
      GetPage(name: "/principal", page: () => InterfazPrincipalWidget()),
      GetPage(name: "/gestionfuncio", page: () => FuncionarioFormWidget()),
    
    ];
