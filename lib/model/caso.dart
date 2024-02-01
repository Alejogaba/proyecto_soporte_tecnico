import 'package:cloud_firestore/cloud_firestore.dart';

class Caso {
  String uid;
  String uidSolicitante;
  String? uidTecnico;
  String uidActivo;
  String uidDependencia;
  String descripcion;
  String categoria;
  bool solucionado = false;
  String urlAdjunto;
  DateTime fecha;
  bool prioridad;
  DateTime? fechaFinalizado;
  String? finalizadoPor;
  bool asignado;
  int turno = 0;

  Caso(
      {this.uid = '',
      required this.fecha,
      required this.uidSolicitante,
      required this.uidActivo,
      required this.uidDependencia,
      required this.descripcion,
      this.uidTecnico,
      this.solucionado = false,
      required this.urlAdjunto,
      this.prioridad = false,
      this.categoria='Otros',
      this.fechaFinalizado,
      this.finalizadoPor,
      this.asignado = false,
      turno = 0});

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
        prioridad: map['prioridad'] ?? false,
        fechaFinalizado: (map['fechaFinalizado'] as Timestamp).toDate(),
        asignado: map['asignado'] ?? false,
        finalizadoPor: map['finalizadoPor'] ?? '',
        uidTecnico: map['uidTecnico'],
        categoria: map['categoria']??'Otros',
        turno: map['turno'] ?? 0);
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
      'asignado': asignado,
      'fechaFinalizado': fechaFinalizado != null
          ? Timestamp.fromDate(fechaFinalizado!)
          : Timestamp.fromDate(DateTime.now()),
      'finalizadoPor': finalizadoPor,
      'uidTecnico': uidTecnico,
      'categoria': categoria,
      'turno': turno
    };
  }
}
