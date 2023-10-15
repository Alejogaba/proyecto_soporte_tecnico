import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login2/model/dependencias.dart';

import '../utils/utilidades.dart';

class ControladorDependencias {
  Future<List<Dependencia>> cargarDependencias() async {
    List<Dependencia> DependenciaList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('dependencias').get();

    querySnapshot.docs.forEach((doc) {
      Dependencia dependencia =
          Dependencia.fromMap(doc.data() as Map<String, dynamic>);
      DependenciaList.add(dependencia);
    });

    return DependenciaList;
  }

  Future<Dependencia> cargarDependenciaUID(String uidDependencia) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('dependencias')
        .doc(uidDependencia)
        .get();
    if (querySnapshot.data() != null && querySnapshot.data()!.isNotEmpty) {
      return Dependencia.fromMap(querySnapshot.data()!);
    } else {
      log('No se encontro la dependencia');
      return Dependencia(nombre: 'No encontrado');
    }
  }

  Utilidades util = Utilidades();
  Stream<List<Dependencia?>> getDependenciasStream(String valorBusqueda) {
  
    if (valorBusqueda.length<3) {
      log('Retornando todos las depedencncias - valorBusqueda: $valorBusqueda');
      return FirebaseFirestore.instance
          .collection('dependencias')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Dependencia> dependencias = [];
        querySnapshot.docs.forEach((doc) => dependencias
            .add(Dependencia.fromMap(doc.data() as Map<String, dynamic>)));
        return dependencias;
      });
    } else {
      log('busqueda dependencia: ' +
          util.capitalizarPalabras(valorBusqueda) +
          '\uf8ff');
      return FirebaseFirestore.instance
          .collection('dependencias')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Dependencia> dependencias = [];
        querySnapshot.docs.forEach((doc) => dependencias
            .add(Dependencia.fromMap(doc.data() as Map<String, dynamic>)));
        dependencias = dependencias.where((dependencia) {
          return dependencia.nombre.toLowerCase().contains(valorBusqueda.toLowerCase());
        }).toList();
        log('lista dependencias: ' + dependencias[0].nombre.toString());
        return dependencias;
      });
    }
  }

  Stream<int> getTotalCasosCountDependencia(String uidDependencia) {
    // ignore: close_sinks
    StreamController<int> controller = StreamController<int>();

    FirebaseFirestore.instance
        .collection('dependencias')
        .doc(uidDependencia)
        .collection('activos')
        .where('casosPendientes', isEqualTo: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      int count = querySnapshot.size;
      controller.add(count);
    });

    return controller.stream;
  }
}
