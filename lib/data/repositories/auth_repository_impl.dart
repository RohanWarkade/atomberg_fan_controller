import 'package:dartz/dartz.dart';
import '../../core/config/api_config.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/credential_local_datasource.dart';
import '../datasources/remote/atomberg_api_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AtombergApiDataSource remoteDataSource;
  final CredentialsLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> authenticate({
    required String apiKey,
    required String refreshToken,
  }) async {
    try {
      AppLogger.info('Authenticating user', tag: 'AuthRepo');

      // Get access token from API
      final accessToken = await remoteDataSource.getAccessToken(
        apiKey: apiKey,
        refreshToken: refreshToken,
      );

      // Save access token with expiry
      final expiry = DateTime.now().add(ApiConfig.tokenExpiry);
      await localDataSource.saveAccessToken(
        accessToken: accessToken,
        expiry: expiry,
      );

      AppLogger.info('Authentication successful', tag: 'AuthRepo');
      return Right(accessToken);
    } on AuthException catch (e) {
      AppLogger.error('Auth error', error: e, tag: 'AuthRepo');
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      AppLogger.error('Network error', error: e, tag: 'AuthRepo');
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      AppLogger.error('Server error', error: e, tag: 'AuthRepo');
      return Left(ServerFailure(e.message, code: e.code));
    } on CacheException catch (e) {
      AppLogger.error('Cache error', error: e, tag: 'AuthRepo');
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'AuthRepo');
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> getValidAccessToken() async {
    try {
      AppLogger.debug('Getting valid access token', tag: 'AuthRepo');

      // Get stored credentials
      final credentials = await localDataSource.getCredentials();
      
      if (credentials == null) {
        return const Left(AuthFailure('No credentials found'));
      }

      // Check if access token is still valid
      if (credentials.hasValidAccessToken && credentials.accessToken != null) {
        AppLogger.debug('Using cached access token', tag: 'AuthRepo');
        return Right(credentials.accessToken!);
      }

      // Token expired, refresh it
      AppLogger.info('Access token expired, refreshing', tag: 'AuthRepo');
      return authenticate(
        apiKey: credentials.apiKey,
        refreshToken: credentials.refreshToken,
      );
    } on CacheException catch (e) {
      AppLogger.error('Cache error', error: e, tag: 'AuthRepo');
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'AuthRepo');
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCredentials({
    required String apiKey,
    required String refreshToken,
  }) async {
    try {
      AppLogger.debug('Saving credentials', tag: 'AuthRepo');
      await localDataSource.saveCredentials(
        apiKey: apiKey,
        refreshToken: refreshToken,
      );
      return const Right(null);
    } on CacheException catch (e) {
      AppLogger.error('Cache error', error: e, tag: 'AuthRepo');
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'AuthRepo');
      return const Left(CacheFailure('Failed to save credentials'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasValidCredentials() async {
    try {
      final credentials = await localDataSource.getCredentials();
      return Right(credentials != null);
    } on CacheException catch (e) {
      AppLogger.error('Cache error', error: e, tag: 'AuthRepo');
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'AuthRepo');
      return const Left(CacheFailure('Failed to check credentials'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCredentials() async {
    try {
      AppLogger.info('Clearing credentials', tag: 'AuthRepo');
      await localDataSource.clearCredentials();
      return const Right(null);
    } on CacheException catch (e) {
      AppLogger.error('Cache error', error: e, tag: 'AuthRepo');
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'AuthRepo');
      return const Left(CacheFailure('Failed to clear credentials'));
    }
  }
}
