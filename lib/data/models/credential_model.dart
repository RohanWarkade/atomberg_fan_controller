class CredentialsModel {
  final String apiKey;
  final String refreshToken;
  final String? accessToken;
  final DateTime? accessTokenExpiry;

  const CredentialsModel({
    required this.apiKey,
    required this.refreshToken,
    this.accessToken,
    this.accessTokenExpiry,
  });

  bool get hasValidAccessToken {
    if (accessToken == null || accessTokenExpiry == null) return false;
    return DateTime.now().isBefore(accessTokenExpiry!);
  }

  CredentialsModel copyWith({
    String? apiKey,
    String? refreshToken,
    String? accessToken,
    DateTime? accessTokenExpiry,
  }) {
    return CredentialsModel(
      apiKey: apiKey ?? this.apiKey,
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      accessTokenExpiry: accessTokenExpiry ?? this.accessTokenExpiry,
    );
  }
}