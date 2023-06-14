class Activo {
  final String uid;
  final String nombre;
  final String detalles;
  final String urlImagen;
  final int countCasosPendientes;

  Activo({
    required this.uid,
    required this.nombre,
    required this.detalles,
    required this.urlImagen,
    required this.countCasosPendientes,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'detalles': detalles,
      'urlImagen': urlImagen,
      'countCasosPendientes': countCasosPendientes,
    };
  }

  factory Activo.fromMap(Map<String, dynamic> map) {
    return Activo(
      uid: map['uid']??'',
      nombre: map['nombre']??'',
      detalles: map['detalles']??'',
      urlImagen: map['urlImagen']??'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Imagen_no_disponible.svg/2048px-Imagen_no_disponible.svg.png',
      countCasosPendientes: map['countCasosPendientes']??0,
    );
  }
}
