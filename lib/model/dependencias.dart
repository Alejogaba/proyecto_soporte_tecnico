class Dependencia {
  String uid;
  String nombre;
  String jefeEncargado;
  String correo;
  String telefono;
  String? urlImagen;
  int casosPendientes;

  Dependencia({
    this.uid = '',
    required this.nombre,
    this.jefeEncargado = '',
    this.correo = '',
    this.telefono = '',
    this.urlImagen,
    this.casosPendientes = 0,
  });

  factory Dependencia.fromMap(Map<String, dynamic> map) {
    return Dependencia(
      uid: map['uid']??'',
      nombre: map['nombre'] ?? '',
      jefeEncargado: map['jefeEncargado'] ?? '',
      correo: map['correo'] ?? '',
      telefono: map['telefono'] ?? '',
      urlImagen: map['urlImagen'] ?? '',
      casosPendientes: map['casosPendientes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'jefeEncargado': jefeEncargado,
      'correo': correo,
      'telefono': telefono,
      'urlImagen': urlImagen,
      'casosPendientes': casosPendientes,
    };
  }
}
