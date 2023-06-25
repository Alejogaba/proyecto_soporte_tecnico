

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login2/model/dependencias.dart';

class ControladorDependencias {
  Future<List<Dependencia>> cargarDependencias() async {
    List<Dependencia> DependenciaList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('dependencias').get();

    querySnapshot.docs.forEach((doc) {
      Dependencia dependencia = Dependencia.fromMap(doc.data() as Map<String, dynamic>);
      DependenciaList.add(dependencia);
    });

    return DependenciaList;
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
