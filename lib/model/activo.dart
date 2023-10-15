class Activo {
  String uid = '';
  final String nombre;
  final String marca;
  final String detalles;
  final String? urlImagen;
  bool casosPendientes;

  Activo({
    this.uid = '',
    required this.nombre,
    this.marca = 'Generico',
    required this.detalles,
    this.urlImagen='https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Imagen_no_disponible.svg/2048px-Imagen_no_disponible.svg.png',
    required this.casosPendientes,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'marca':marca,
      'detalles': detalles,
      'urlImagen': urlImagen,
      'casosPendientes': casosPendientes,
    };
  }

  factory Activo.fromMap(Map<String, dynamic> map) {
    return Activo(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      marca: map['marca'] ?? 'Generico',
      detalles: map['detalles'] ?? '',
      urlImagen: map['urlImagen'] ??
          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Imagen_no_disponible.svg/2048px-Imagen_no_disponible.svg.png',
      casosPendientes: map['casosPendientes'] ?? false,
    );
  }
}
