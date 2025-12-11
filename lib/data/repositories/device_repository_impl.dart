import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/local/credential_local_datasource.dart';
import '../datasources/remote/atomberg_api_datasource.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final AtombergApiDataSource remoteDataSource;
  final CredentialsLocalDataSource localDataSource;
  final AuthRepository authRepository;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, List<Device>>> getDevices() async {
    try {
      AppLogger.info('Fetching devices', tag: 'DeviceRepo');

      // Get valid access token
      final tokenResult = await authRepository.getValidAccessToken();

      return tokenResult.fold(
        (failure) => Left(failure),
        (accessToken) async {
          try {
            final credentials = await localDataSource.getCredentials();
            if (credentials == null) {
              return const Left(AuthFailure('No credentials found'));
            }

            final devices = await remoteDataSource.getDevices(
              apiKey: credentials.apiKey,
              accessToken: accessToken,
            );

            AppLogger.info('Fetched ${devices.length} devices',
                tag: 'DeviceRepo');
            return Right(devices);
          } on AuthException catch (e) {
            AppLogger.error('Auth error', error: e, tag: 'DeviceRepo');
            return Left(AuthFailure(e.message, code: e.code));
          } on NetworkException catch (e) {
            AppLogger.error('Network error', error: e, tag: 'DeviceRepo');
            return Left(NetworkFailure(e.message, code: e.code));
          } on ServerException catch (e) {
            AppLogger.error('Server error', error: e, tag: 'DeviceRepo');
            return Left(ServerFailure(e.message, code: e.code));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'DeviceRepo');
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DeviceState>> getDeviceState(String deviceId) async {
    try {
      AppLogger.info('Fetching device state for $deviceId', tag: 'DeviceRepo');

      // Get valid access token
      final tokenResult = await authRepository.getValidAccessToken();

      return tokenResult.fold(
        (failure) => Left(failure),
        (accessToken) async {
          try {
            final credentials = await localDataSource.getCredentials();
            if (credentials == null) {
              return const Left(AuthFailure('No credentials found'));
            }

            final deviceState = await remoteDataSource.getDeviceState(
              apiKey: credentials.apiKey,
              accessToken: accessToken,
              deviceId: deviceId,
            );

            AppLogger.debug('Fetched device state', tag: 'DeviceRepo');
            return Right(deviceState);
          } on AuthException catch (e) {
            AppLogger.error('Auth error', error: e, tag: 'DeviceRepo');
            return Left(AuthFailure(e.message, code: e.code));
          } on NetworkException catch (e) {
            AppLogger.error('Network error', error: e, tag: 'DeviceRepo');
            return Left(NetworkFailure(e.message, code: e.code));
          } on ServerException catch (e) {
            AppLogger.error('Server error', error: e, tag: 'DeviceRepo');
            return Left(ServerFailure(e.message, code: e.code));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'DeviceRepo');
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> sendCommand({
    required String deviceId,
    required Map<String, dynamic> command,
  }) async {
    try {
      AppLogger.info('Sending command to $deviceId', tag: 'DeviceRepo');

      // Get valid access token
      final tokenResult = await authRepository.getValidAccessToken();

      return tokenResult.fold(
        (failure) => Left(failure),
        (accessToken) async {
          try {
            final credentials = await localDataSource.getCredentials();
            if (credentials == null) {
              return const Left(AuthFailure('No credentials found'));
            }

            await remoteDataSource.sendCommand(
              apiKey: credentials.apiKey,
              accessToken: accessToken,
              deviceId: deviceId,
              command: command,
            );

            AppLogger.info('Command sent successfully', tag: 'DeviceRepo');
            return const Right(null);
          } on AuthException catch (e) {
            AppLogger.error('Auth error', error: e, tag: 'DeviceRepo');
            return Left(AuthFailure(e.message, code: e.code));
          } on NetworkException catch (e) {
            AppLogger.error('Network error', error: e, tag: 'DeviceRepo');
            return Left(NetworkFailure(e.message, code: e.code));
          } on ServerException catch (e) {
            AppLogger.error('Server error', error: e, tag: 'DeviceRepo');
            return Left(ServerFailure(e.message, code: e.code));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Unknown error', error: e, tag: 'DeviceRepo');
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }
}
