

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

  Future<int> getTotalCasosCountDependencia(String uidDependencia) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('dependencias').doc(uidDependencia).collection('activos')
        .where('casosPendientes',isEqualTo: true).get();
    return querySnapshot.size;
  }
}
