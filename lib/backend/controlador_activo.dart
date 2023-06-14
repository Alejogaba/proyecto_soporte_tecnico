import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';

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

  addModActivo(
      BuildContext context, Activo activoAguardar, String uidDpendencia) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      if (activoAguardar.uid.isEmpty) {
        await _db
            .collection("dependencias")
            .doc(uidDpendencia)
            .collection('activos')
            .add(activoAguardar.toMap()).then((value) {
              _db
            .collection("dependencias")
            .doc(uidDpendencia)
            .collection('activos').doc(value.id).update({
                                      'uid': value.id,
                                    });
            });
        return 'ok';
      } else {
        await _db
            .collection("dependencias")
            .doc(uidDpendencia)
            .collection('activos')
            .doc(activoAguardar.uid)
            .update(activoAguardar.toMap());
        return 'ok';
      }
    } catch (e) {
      return 'error';
    }
  }

  removeActivo(String idActivo, String uidDpendencia) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db
          .collection("dependencias")
          .doc(uidDpendencia)
          .collection('activos')
          .doc(idActivo)
          .delete();
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }
}
