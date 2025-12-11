import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/credential_model.dart';

abstract class CredentialsLocalDataSource {
  Future<void> saveCredentials({
    required String apiKey,
    required String refreshToken,
  });

  Future<void> saveAccessToken({
    required String accessToken,
    required DateTime expiry,
  });

  Future<CredentialsModel?> getCredentials();

  Future<void> clearCredentials();
}

class CredentialsLocalDataSourceImpl implements CredentialsLocalDataSource {
  final SharedPreferences sharedPreferences;

  CredentialsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveCredentials({
    required String apiKey,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        sharedPreferences.setString(AppConstants.keyApiKey, apiKey),
        sharedPreferences.setString(AppConstants.keyRefreshToken, refreshToken),
      ]);
    } catch (e) {
      throw CacheException('Failed to save credentials', originalError: e);
    }
  }

  @override
  Future<void> saveAccessToken({
    required String accessToken,
    required DateTime expiry,
  }) async {
    try {
      await Future.wait([
        sharedPreferences.setString(AppConstants.keyAccessToken, accessToken),
        sharedPreferences.setInt(
          AppConstants.keyTokenExpiry,
          expiry.millisecondsSinceEpoch,
        ),
      ]);
    } catch (e) {
      throw CacheException('Failed to save access token', originalError: e);
    }
  }

  @override
  Future<CredentialsModel?> getCredentials() async {
    try {
      final apiKey = sharedPreferences.getString(AppConstants.keyApiKey);
      final refreshToken = sharedPreferences.getString(AppConstants.keyRefreshToken);

      if (apiKey == null || refreshToken == null) {
        return null;
      }

      final accessToken = sharedPreferences.getString(AppConstants.keyAccessToken);
      final expiryMillis = sharedPreferences.getInt(AppConstants.keyTokenExpiry);

      return CredentialsModel(
        apiKey: apiKey,
        refreshToken: refreshToken,
        accessToken: accessToken,
        accessTokenExpiry: expiryMillis != null
            ? DateTime.fromMillisecondsSinceEpoch(expiryMillis)
            : null,
      );
    } catch (e) {
      throw CacheException('Failed to get credentials', originalError: e);
    }
  }

  @override
  Future<void> clearCredentials() async {
    try {
      await sharedPreferences.clear();
    } catch (e) {
      throw CacheException('Failed to clear credentials', originalError: e);
    }
  }
}
