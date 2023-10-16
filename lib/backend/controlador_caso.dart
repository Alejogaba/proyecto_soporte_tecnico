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

  Future<List<Caso>> obtenerCasosFuture({String uidSolicitante = ''}) async {
    QuerySnapshot querySnapshot;

    if (uidSolicitante.isEmpty) {
      querySnapshot =
          await FirebaseFirestore.instance.collection('casos').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('casos')
          .where('uidSolicitante', isEqualTo: uidSolicitante)
          .get();
    }

    List<Caso> casos = querySnapshot.docs
        .map((doc) => Caso.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return casos;
  }

  Future<Duration> calcularTiempoPromedio() async {
  List<Caso> casos = await obtenerCasosFuture();
  List<Duration> tiempos = [];

  casos.where((caso) => caso.solucionado).forEach((caso) {
    if (caso.fechaFinalizado != null) {
      tiempos.add(caso.fechaFinalizado!.difference(caso.fecha));
    }
  });

  if (tiempos.isEmpty) {
    return Duration.zero;
  }

  Duration sumTiempos = tiempos.reduce((value, element) => value + element);
  return Duration(milliseconds: sumTiempos.inMilliseconds ~/ tiempos.length);
}

  Stream<List<Caso>> obtenerCasosStreamSinFinalizar(
      {String uidSolicitante = ''}) {
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

  Stream<List<Caso>> obtenerCasosStreamFinalizados(
      {String uidSolicitante = ''}) {
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
        .where('uidSolicitante', isEqualTo: uidSolicitante.trim())
        .where('solucionado', isEqualTo: false)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      int count = querySnapshot.size;
      controller.add(count);
    });

    return controller.stream;
  }

  Future<int> contarCasosPorDependencia(String miUidDependencia) async {
    // Obtén una referencia a la colección 'casos' en Firestore
    final CollectionReference casosCollection =
        FirebaseFirestore.instance.collection('casos');

    try {
      // Realiza una consulta para contar los casos que cumplan con la condición
      QuerySnapshot querySnapshot = await casosCollection
          .where('uidDependencia', isEqualTo: miUidDependencia)
          .get();

      // El número de casos se obtiene del tamaño de la lista de documentos
      int cantidadCasos = querySnapshot.docs.length;

      return cantidadCasos;
    } catch (e) {
      print('Error al contar casos: $e');
      return 0; // Manejo de errores, puedes cambiar esto según tus necesidades
    }
  }

  Future<int> getTotalCasosCountSolicitanteFuture(String uidSolicitante) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('casos')
          .where('uidSolicitante', isEqualTo: uidSolicitante)
          .where('solucionado', isEqualTo: false)
          .get();

      int count = querySnapshot.size;
      return count;
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la lectura de Firestore.
      print('Error al obtener el total de casos para el solicitante: $e');
      return 0; // o cualquier valor predeterminado que desees devolver en caso de error.
    }
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

  marcarCasoComoresuelto(Caso caso, String usuario) async {
    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      Caso casoNuevo = caso;
      casoNuevo.solucionado = true;
      DateTime tiempoResolucion = DateTime.fromMicrosecondsSinceEpoch(
          (DateTime.now().millisecondsSinceEpoch) -
              (caso.fecha.millisecondsSinceEpoch));

      await _db
          .collection('casos')
          .doc(caso.uid)
          .update(casoNuevo.toMap())
          .then((value) {
        _db
            .collection('dependencias')
            .doc(caso.uidDependencia)
            .collection('activos')
            .doc(caso.uidActivo)
            .update({'casosPendientes': false, 'finalizadoPor': usuario,'fechaFinalizado': Timestamp.fromDate(DateTime.now())});
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }
}
