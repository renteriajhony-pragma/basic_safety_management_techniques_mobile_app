class UserRecord {
  const UserRecord({
    required this.nombre,
    required this.apellido,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.usuario,
    required this.sexo,
    required this.tokenRecuperacion,
  });

  final String nombre;
  final String apellido;
  final String tipoDocumento;
  final String numeroDocumento;
  final String usuario;
  final String sexo;
  final String tokenRecuperacion;

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellido': apellido,
        'tipoDocumento': tipoDocumento,
        'numeroDocumento': numeroDocumento,
        'usuario': usuario,
        'sexo': sexo,
        'tokenRecuperacion': tokenRecuperacion,
      };

  static UserRecord fromJson(Map<String, dynamic> json) => UserRecord(
        nombre: json['nombre'] as String,
        apellido: json['apellido'] as String,
        tipoDocumento: json['tipoDocumento'] as String,
        numeroDocumento: json['numeroDocumento'] as String,
        usuario: json['usuario'] as String,
        sexo: json['sexo'] as String,
        tokenRecuperacion: json['tokenRecuperacion'] as String,
      );
}
