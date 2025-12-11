import 'package:dio/dio.dart';
import '../../../core/constant/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';
import '../../models/device_model.dart';
import '../../models/device_state_model.dart';

abstract class AtombergApiDataSource {
  Future<String> getAccessToken({
    required String apiKey,
    required String refreshToken,
  });

  Future<List<DeviceModel>> getDevices({
    required String apiKey,
    required String accessToken,
  });

  Future<DeviceStateModel> getDeviceState({
    required String apiKey,
    required String accessToken,
    required String deviceId,
  });

  Future<void> sendCommand({
    required String apiKey,
    required String accessToken,
    required String deviceId,
    required Map<String, dynamic> command,
  });
}

class AtombergApiDataSourceImpl implements AtombergApiDataSource {
  final Dio dio;

  AtombergApiDataSourceImpl(this.dio);

  @override
  Future<String> getAccessToken({
    required String apiKey,
    required String refreshToken,
  }) async {
    try {
      AppLogger.info('Fetching access token', tag: 'API');

      final response = await dio.get(
        AppConstants.endpointGetToken,
        options: Options(
          headers: {
            AppConstants.headerApiKey: apiKey,
            AppConstants.headerAuth: 'Bearer $refreshToken',
          },
        ),
      );

      AppLogger.debug('Access token response: ${response.statusCode}', tag: 'API');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final accessToken = data['message']['access_token'] as String;
        return accessToken;
      } else {
        throw ServerException(
          'Failed to get access token: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Dio error getting access token', error: e, tag: 'API');
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unknown error getting access token', error: e, tag: 'API');
      throw ServerException('Unexpected error: $e', originalError: e);
    }
  }

  @override
  Future<List<DeviceModel>> getDevices({
    required String apiKey,
    required String accessToken,
  }) async {
    try {
      AppLogger.info('Fetching devices', tag: 'API');

      final response = await dio.get(
        AppConstants.endpointDeviceList,
        options: Options(
          headers: {
            AppConstants.headerApiKey: apiKey,
            AppConstants.headerAuth: 'Bearer $accessToken',
          },
        ),
      );

      AppLogger.debug('Devices response: ${response.statusCode}', tag: 'API');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final devicesList = data['message']['devices_list'] as List? ?? [];
        return devicesList
            .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to get devices: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Dio error getting devices', error: e, tag: 'API');
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unknown error getting devices', error: e, tag: 'API');
      throw ServerException('Unexpected error: $e', originalError: e);
    }
  }

  @override
  Future<DeviceStateModel> getDeviceState({
    required String apiKey,
    required String accessToken,
    required String deviceId,
  }) async {
    try {
      AppLogger.info('Fetching device state for $deviceId', tag: 'API');

      final response = await dio.get(
        '${AppConstants.endpointDeviceState}?device_id=$deviceId',
        options: Options(
          headers: {
            AppConstants.headerApiKey: apiKey,
            AppConstants.headerAuth: 'Bearer $accessToken',
          },
        ),
      );

      AppLogger.debug('Device state response: ${response.statusCode}', tag: 'API');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final deviceStates = data['message']['device_state'] as List;
        
        if (deviceStates.isNotEmpty) {
          return DeviceStateModel.fromJson(
            deviceStates[0] as Map<String, dynamic>,
          );
        } else {
          throw ServerException('No state found for device');
        }
      } else {
        throw ServerException(
          'Failed to get device state: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Dio error getting device state', error: e, tag: 'API');
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unknown error getting device state', error: e, tag: 'API');
      throw ServerException('Unexpected error: $e', originalError: e);
    }
  }

  @override
  Future<void> sendCommand({
    required String apiKey,
    required String accessToken,
    required String deviceId,
    required Map<String, dynamic> command,
  }) async {
    try {
      AppLogger.info('Sending command to $deviceId: $command', tag: 'API');

      final response = await dio.post(
        AppConstants.endpointSendCommand,
        data: {
          'device_id': deviceId,
          'command': command,
        },
        options: Options(
          headers: {
            AppConstants.headerApiKey: apiKey,
            AppConstants.headerAuth: 'Bearer $accessToken',
            AppConstants.headerContentType: 'application/json',
          },
        ),
      );

      AppLogger.debug('Send command response: ${response.statusCode}', tag: 'API');

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to send command: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Dio error sending command', error: e, tag: 'API');
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unknown error sending command', error: e, tag: 'API');
      throw ServerException('Unexpected error: $e', originalError: e);
    }
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout', originalError: e);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return AuthException(
            'Authentication failed',
            code: statusCode.toString(),
            originalError: e,
          );
        }
        return ServerException(
          'Server error: $statusCode',
          code: statusCode.toString(),
          originalError: e,
        );
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled', originalError: e);
      case DioExceptionType.unknown:
        return NetworkException('Network error', originalError: e);
      default:
        return NetworkException('Unknown network error', originalError: e);
    }
  }
}