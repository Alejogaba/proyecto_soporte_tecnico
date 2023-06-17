class Caso {
  String uid;
  String uidSolicitante;
  String uidActivo;
  String descripcion;
  bool solucionado;
  String urlAdjunto;

  Caso({
    required this.uid,
    required this.uidSolicitante,
    required this.uidActivo,
    required this.descripcion,
    required this.solucionado,
    required this.urlAdjunto,
  });

  factory Caso.fromMap(Map<String, dynamic> map) {
    return Caso(
      uid: map['uid'] ?? '',
      uidSolicitante: map['uidSolicitante'] ?? '',
      uidActivo: map['uidActivo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      solucionado: map['solucionado'] ?? false,
      urlAdjunto: map['urlAdjunto'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'uidSolicitante': uidSolicitante,
      'uidActivo': uidActivo,
      'descripcion': descripcion,
      'solucionado': solucionado,
      'urlAdjunto': urlAdjunto,
    };
  }
}
