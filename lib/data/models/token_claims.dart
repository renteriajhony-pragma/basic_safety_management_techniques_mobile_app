class TokenClaims {
  const TokenClaims({
    required this.token,
    required this.payload,
  });

  final String token;
  final Map<String, dynamic> payload;
}
