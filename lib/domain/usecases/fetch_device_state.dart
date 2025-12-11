import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/device_state.dart';
import '../repositories/device_repository.dart';

class FetchDeviceState {
  final DeviceRepository repository;

  FetchDeviceState(this.repository);

  Future<Either<Failure, DeviceState>> call(String deviceId) {
    if (deviceId.trim().isEmpty) {
      return Future.value(
        const Left(ServerFailure('Device ID cannot be empty')),
      );
    }
    return repository.getDeviceState(deviceId);
  }
}