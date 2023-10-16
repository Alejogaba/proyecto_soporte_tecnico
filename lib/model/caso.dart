import 'package:cloud_firestore/cloud_firestore.dart';

class Caso {
  String uid;
  String uidSolicitante;
  String uidActivo;
  String uidDependencia;
  String descripcion;
  bool solucionado;
  String urlAdjunto;
  DateTime fecha;
  int prioridad;
  DateTime? fechaFinalizado;

  Caso({
    this.uid = '',
    required this.fecha,
    required this.uidSolicitante,
    required this.uidActivo,
    required this.uidDependencia,
    required this.descripcion,
    this.solucionado = false,
    required this.urlAdjunto,
    required this.prioridad,
    this.fechaFinalizado,
  });

  factory Caso.fromMap(Map<String, dynamic> map) {
    return Caso(
      fecha: (map['fecha'] as Timestamp).toDate(),
      uid: map['uid'] ?? '',
      uidSolicitante: map['uidSolicitante'] ?? '',
      uidActivo: map['uidActivo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      solucionado: map['solucionado'] ?? false,
      urlAdjunto: map['urlAdjunto'] ?? '',
      uidDependencia: map['uidDependencia'] ?? '', 
      prioridad: map['prioridad'] ?? 3,
      fechaFinalizado: (map['fechaFinalizado'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fecha': Timestamp.fromDate(fecha),
      'uidSolicitante': uidSolicitante,
      'uidActivo': uidActivo,
      'descripcion': descripcion,
      'solucionado': solucionado,
      'urlAdjunto': urlAdjunto,
      'uidDependencia': uidDependencia,
      'prioridad': prioridad,
      'fechaFinalizado': fechaFinalizado
    };
  }
}
