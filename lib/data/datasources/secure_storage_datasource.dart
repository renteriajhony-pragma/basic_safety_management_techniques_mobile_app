abstract interface class SecureStorageDatasource {
  Future<void> save(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);
}
