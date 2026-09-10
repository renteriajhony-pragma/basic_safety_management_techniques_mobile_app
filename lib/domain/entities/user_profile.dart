import 'document_type.dart';
import 'sex.dart';

class UserProfile {
  const UserProfile({
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
  final DocumentType tipoDocumento;
  final String numeroDocumento;
  final String usuario;
  final Sex sexo;
  final String tokenRecuperacion;
}
