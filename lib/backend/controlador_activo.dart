import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/activo.dart';

class ActivoController {
  Stream<List<Activo?>> obtenerActivosStream(String uidDependencia) {
    return FirebaseFirestore.instance
        .collection('dependencias')
        .doc(uidDependencia)
        .collection('activos')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Activo> dependencias = [];
      querySnapshot.docs.forEach((doc) =>
          dependencias.add(Activo.fromMap(doc.data() as Map<String, dynamic>)));
      log('lista dependencias: ' + dependencias[0].nombre.toString());
      return dependencias;
    });
  }
}
