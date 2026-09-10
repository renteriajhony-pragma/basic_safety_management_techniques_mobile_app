enum DocumentType {
  cedulaCiudadania,
  tarjetaIdentidad,
  cedulaExtranjeria,
  pasaporte;

  String get label => switch (this) {
        DocumentType.cedulaCiudadania => 'Cédula de ciudadanía',
        DocumentType.tarjetaIdentidad => 'Tarjeta de identidad',
        DocumentType.cedulaExtranjeria => 'Cédula de extranjería',
        DocumentType.pasaporte => 'Pasaporte',
      };
}
