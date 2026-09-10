abstract interface class SecretsDatasource {
  /// Returns the persisted value for [key], generating and persisting a new
  /// random one on first access.
  Future<String> getOrCreate(String key);
}
