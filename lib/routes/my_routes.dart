import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:login2/index.dart';
import 'package:login2/model/activo.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/vistas/lista_funcionarios/funcionarioForm.dart';
import 'package:login2/vistas/login/LoginMOD.dart';
import 'package:login2/main.dart';
import 'package:login2/vistas/perfil/PerfilMOD/home.dart';

import '../model/usuario.dart';
import '../vistas/lista_funcionarios/lista_funcionariosFinal.dart';
import '../vistas/login/sign_in.dart';

routes() => [
      GetPage(name: "/home", page: () => PrincipalPagina()),
      GetPage(name: "/principal", page: () => InterfazPrincipalWidget()),
      GetPage(name: "/listafuncio", page: () => ListaFuncionarioss()),
      GetPage(name: "/listareportes", page: () => ListaReportesWidget()),

      GetPage(name: "/loginmod", page: () => LoginPage()),
      GetPage(name: "/loguear", page: () => SignIn()),
      GetPage(
          name: "/funcionario", page: () => FuncionarioFormWidget()),
      GetPage(name: "/perfilgen", page: () => PerfilGeneral()),
    ];
