abstract interface class EncryptionDatasource {
  Future<String> encrypt(String plainText);

  Future<String> decrypt(String cipherText);
}
