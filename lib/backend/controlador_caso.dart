import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';

import '../model/activo.dart';
import '../model/caso.dart';

class CasosController {
  Stream<List<Caso>> obtenerCasosStream({String uidSolicitante = ''}) {
    if (uidSolicitante.isEmpty) {
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
    } else {
      return FirebaseFirestore.instance
          .collection('casos')
          .where('uidSolicitante', isEqualTo: uidSolicitante)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Caso> casos = [];
        querySnapshot.docs.forEach((doc) =>
            casos.add(Caso.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista casos: ' + casos[0].descripcion.toString());
        return casos;
      });
    }
  }

  Stream<List<Caso>> obtenerCasosStreamSinFinalizar({String uidSolicitante = ''}) {
    if (uidSolicitante.isEmpty) {
      return FirebaseFirestore.instance
          .collection('casos')
          .where('solucionado', isEqualTo: false)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Caso> casos = [];
        querySnapshot.docs.forEach((doc) =>
            casos.add(Caso.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista casos: ' + casos[0].descripcion.toString());
        return casos;
      });
    } else {
      return FirebaseFirestore.instance
          .collection('casos')
          .where('uidSolicitante', isEqualTo: uidSolicitante)
          .where('solucionado', isEqualTo: false)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Caso> casos = [];
        querySnapshot.docs.forEach((doc) =>
            casos.add(Caso.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista casos: ' + casos[0].descripcion.toString());
        return casos;
      });
    }
  }

  Stream<List<Caso>> obtenerCasosStreamFinalizados({String uidSolicitante = ''}) {
    if (uidSolicitante.isEmpty) {
      return FirebaseFirestore.instance
          .collection('casos')
          .where('solucionado', isEqualTo: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Caso> casos = [];
        querySnapshot.docs.forEach((doc) =>
            casos.add(Caso.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista casos: ' + casos[0].descripcion.toString());
        return casos;
      });
    } else {
      return FirebaseFirestore.instance
          .collection('casos')
          .where('uidSolicitante', isEqualTo: uidSolicitante)
          .where('solucionado', isEqualTo: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<Caso> casos = [];
        querySnapshot.docs.forEach((doc) =>
            casos.add(Caso.fromMap(doc.data() as Map<String, dynamic>)));
        log('lista casos: ' + casos[0].descripcion.toString());
        return casos;
      });
    }
  }

  Stream<int> getTotalCasosCountSolicitante(String uidSolicitante) {
    // ignore: close_sinks
    StreamController<int> controller = StreamController<int>();

    FirebaseFirestore.instance
        .collection('casos')
        .where('uidSolicitante', isEqualTo: uidSolicitante)
        .where('solucionado',isEqualTo: false)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      int count = querySnapshot.size;
      controller.add(count);
    });

    return controller.stream;
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
        await _db.collection('casos').add(casoAguardar.toMap()).then((value) {
          _db.collection('casos').doc(value.id).update({'uid': value.id});
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

  marcarCasoComoresuelto(Caso caso) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      Caso casoNuevo = caso;
      casoNuevo.solucionado = true;
      await _db.collection('casos').doc(caso.uid).update(casoNuevo.toMap()).then((value) {
        _db
            .collection('dependencias')
            .doc(caso.uidDependencia)
            .collection('activos')
            .doc(caso.uidActivo)
            .update({'casosPendientes': false});
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }
}
