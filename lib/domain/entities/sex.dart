enum Sex {
  masculino,
  femenino,
  otro;

  String get label => switch (this) {
        Sex.masculino => 'Masculino',
        Sex.femenino => 'Femenino',
        Sex.otro => 'Otro',
      };
}
