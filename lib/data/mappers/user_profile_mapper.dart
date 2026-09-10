import '../../domain/entities/document_type.dart';
import '../../domain/entities/sex.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_record.dart';

class UserProfileMapper {
  const UserProfileMapper();

  UserRecord toRecord(UserProfile profile) => UserRecord(
        nombre: profile.nombre,
        apellido: profile.apellido,
        tipoDocumento: profile.tipoDocumento.name,
        numeroDocumento: profile.numeroDocumento,
        usuario: profile.usuario,
        sexo: profile.sexo.name,
        tokenRecuperacion: profile.tokenRecuperacion,
      );

  UserProfile toEntity(UserRecord record) => UserProfile(
        nombre: record.nombre,
        apellido: record.apellido,
        tipoDocumento: DocumentType.values.byName(record.tipoDocumento),
        numeroDocumento: record.numeroDocumento,
        usuario: record.usuario,
        sexo: Sex.values.byName(record.sexo),
        tokenRecuperacion: record.tokenRecuperacion,
      );
}
