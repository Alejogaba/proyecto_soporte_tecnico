class Usuario {
  String? funcionarioImage;
  String? fechaNacimiento;
  String? area;
  String? telefono;
  String? cargo;
  String? password;
  String? identificacion;
  String? nombre;
  String? email;
  String? role;
  String? uid;

  Usuario(Usuario usuario, {
    this.funcionarioImage = "",
    this.fechaNacimiento = "",
    this.area = "",
    this.telefono = "",
    this.cargo = "",
    this.password = "",
    this.identificacion = "",
    this.nombre = "",
    this.email = "",
    this.role = "",
    this.uid = "",
  });

  Usuario.mapeo(Map<String, dynamic> map) {
    funcionarioImage = map['FuncionarioImage'] ?? "";
    fechaNacimiento = map['fechanacimiento'] ?? "";
    area = map['area'] ?? "";
    telefono = map['telefono'] ?? "";
    cargo = map['cargo'] ?? "";
    password = map['password'] ?? "";
    identificacion = map['identificacion'] ?? "";
    nombre = map['nombre'] ?? "";
    email = map['email'] ?? "";
    role = map['role'] ?? "";
    uid = map['uid'] ?? "";
  }

  Map<String, dynamic> toMap() {
    return {
      'FuncionarioImage': funcionarioImage,
      'fechanacimiento': fechaNacimiento,
      'area': area,
      'telefono': telefono,
      'cargo': cargo,
      'password': password,
      'identificacion': identificacion,
      'nombre': nombre,
      'email': email,
      'role': role,
      'uid': uid
    };
  }
}
