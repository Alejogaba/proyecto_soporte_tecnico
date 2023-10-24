import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login2/utils/utilidades.dart';

import '../model/activo.dart';

class ActivoController {
  Utilidades util = Utilidades();
  Stream<List<Activo?>> obtenerActivosStream(
      String uidDependencia, String valorBusqueda) {
    log('Retornando todos los activos - uidDependencia: $uidDependencia - valorBusqueda: $valorBusqueda');
    if (valorBusqueda.isEmpty) {
      return FirebaseFirestore.instance
          .collection('dependencias')
          .doc(uidDependencia)
          .collection('activos')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Activo> dependencias = [];
        querySnapshot.docs.forEach((doc) => dependencias
            .add(Activo.fromMap(doc.data() as Map<String, dynamic>)));
        return dependencias;
      });
    } else {
      return FirebaseFirestore.instance
          .collection('dependencias')
          .doc(uidDependencia)
          .collection('activos')
          .where('nombre',
              isGreaterThanOrEqualTo: util.capitalizarPalabras(valorBusqueda))
          .where('nombre',
              isLessThanOrEqualTo:
                  util.capitalizarPalabras(valorBusqueda) + '\uf8ff')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Activo> dependencias = [];
        querySnapshot.docs.forEach((doc) => dependencias
            .add(Activo.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista dependencias: ' + dependencias[0].nombre.toString());
        return dependencias;
      });
    }
  }

  Future<Activo> cargarActivoUID(String uidDependencia,String uidActivo) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('dependencias')
        .doc(uidDependencia)
        .collection('activos')
        .doc(uidActivo)
        .get();
    if (querySnapshot.data() != null && querySnapshot.data()!.isNotEmpty) {
      return Activo.fromMap(querySnapshot.data()!);
    } else {
      return Activo(nombre: '', detalles: '', casosPendientes: false);
    }
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
            .add(activoAguardar.toMap())
            .then((value) {
          _db
              .collection("dependencias")
              .doc(uidDpendencia)
              .collection('activos')
              .doc(value.id)
              .update({
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

  Future<Activo> buscarActivo(String uidDependencia, String idSerial) async {
  Activo activoVacio = Activo(nombre: '', detalles: '', casosPendientes: false);
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('dependencias')
        .doc(uidDependencia)
        .collection('activos')
        .doc(idSerial)
        .get();

    if (!documentSnapshot.exists) {
      return activoVacio;
    } else {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return Activo.fromMap(data);
    }
  } catch (e) {
    print(e.toString());
    return activoVacio;
  }
}
Future<Activo?> buscarActivoPorCodigoBarra(String uidDependencia,String barcode) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dependencias')
        .doc(uidDependencia)
        .collection('activos')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        final docSnapshot = querySnapshot.docs[0];
        final caso = Activo.fromMap(docSnapshot.data());

        return caso;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al cargar el caso individual: $e');
      return null;
    }
  }
}
