class Dependencia {
  String nombre;
  String jefeEncargado;
  String correo;
  String telefono;
  String? urlImagen;
  bool tieneCasosPendientes;

  Dependencia({
    required this.nombre,
    this.jefeEncargado = '',
    this.correo = '',
    this.telefono = '',
    this.urlImagen,
    this.tieneCasosPendientes = false,
  });

  factory Dependencia.fromMap(Map<String, dynamic> map) {
    return Dependencia(
      nombre: map['nombre'] ?? '',
      jefeEncargado: map['jefeEncargado'] ?? '',
      correo: map['correo'] ?? '',
      telefono: map['telefono'] ?? '',
      urlImagen: map['urlImagen'] ?? '',
      tieneCasosPendientes: map['tieneCasosPendientes'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'jefeEncargado': jefeEncargado,
      'correo': correo,
      'telefono': telefono,
      'urlImagen': urlImagen,
      'tieneCasosPendientes': tieneCasosPendientes,
    };
  }
}
