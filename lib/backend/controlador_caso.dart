import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../model/activo.dart';
import '../model/caso.dart';
class CasosController {
  Stream<List<Caso>> obtenerCasosStream() {
    return FirebaseFirestore.instance
          .collection('casos')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Caso> casos = [];
        querySnapshot.docs.forEach((doc) =>
            casos.add(Caso.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista casos: ' + casos[0].descripcion.toString());
        return casos;
      });
  }

  Future<Caso?> buscarCasoPorIDactivo(String uidActivo) async { 
    try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('casos')
        .where('uidActivo', isEqualTo: uidActivo)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      final docSnapshot = querySnapshot.docs[0];
      final caso = Caso.fromMap(docSnapshot.data());
      return caso;
    } else {
      return null;
    }
  } catch (e) {
    print('Error al cargar el caso individual: $e');
    return null;
  }
  }

  addModCaso(Caso casoAguardar) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      if (casoAguardar.uid.isEmpty) {
        await _db
            .collection('casos')
            .add(casoAguardar.toMap())
            .then((value) {
          _db
              .collection('casos')
              .doc(value.id)
              .update({'uid': value.id});
        });
        return 'ok';
      } else {
        await _db
            .collection('casos')
            .doc(casoAguardar.uid)
            .update(casoAguardar.toMap());
        return 'ok';
      }
    } catch (e) {
      return 'error';
    }
  }

  removeCaso(String idCaso) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db
          .collection('casos')
          .doc(idCaso)
          .delete();
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }
}
