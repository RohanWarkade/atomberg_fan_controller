import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/api_config.dart';
import '../../data/datasources/local/credential_local_datasource.dart';
import '../../data/datasources/remote/atomberg_api_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/authenticate_user.dart';
import '../../domain/usecases/fetch_device_state.dart';
import '../../domain/usecases/fetch_devices.dart';
import '../../domain/usecases/send_device_command.dart';

// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
    ),
  );
  return dio;
});

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

// DataSources
final credentialsLocalDataSourceProvider = Provider<CredentialsLocalDataSource>((ref) {
  return CredentialsLocalDataSourceImpl(
    ref.read(sharedPreferencesProvider),
  );
});

final atombergApiDataSourceProvider = Provider<AtombergApiDataSource>((ref) {
  return AtombergApiDataSourceImpl(ref.read(dioProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(atombergApiDataSourceProvider),
    localDataSource: ref.read(credentialsLocalDataSourceProvider),
  );
});

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepositoryImpl(
    remoteDataSource: ref.read(atombergApiDataSourceProvider),
    localDataSource: ref.read(credentialsLocalDataSourceProvider),
    authRepository: ref.read(authRepositoryProvider),
  );
});

// UseCases
final authenticateUserProvider = Provider<AuthenticateUser>((ref) {
  return AuthenticateUser(ref.read(authRepositoryProvider));
});

final fetchDevicesProvider = Provider<FetchDevices>((ref) {
  return FetchDevices(ref.read(deviceRepositoryProvider));
});

final fetchDeviceStateProvider = Provider<FetchDeviceState>((ref) {
  return FetchDeviceState(ref.read(deviceRepositoryProvider));
});

final sendDeviceCommandProvider = Provider<SendDeviceCommand>((ref) {
  return SendDeviceCommand(ref.read(deviceRepositoryProvider));
});