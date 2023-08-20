import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login2/model/dependencias.dart';

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


Stream<List<Dependencia>> getDependenciasStream(String searchString) {
  Query query = FirebaseFirestore.instance.collection('dependencias');
  
  if (searchString.isNotEmpty) {
    query = query.where('nombre', isGreaterThanOrEqualTo: searchString);
  }

  return query.snapshots().map((QuerySnapshot querySnapshot) {
    List<Dependencia> dependencias = [];
    querySnapshot.docs.forEach((doc) {
      dependencias.add(Dependencia.fromMap(doc as Map<String, dynamic>));
    });
    return dependencias;
  });
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
