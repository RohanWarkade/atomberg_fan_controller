import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/device.dart';
import '../entities/device_state.dart';

abstract class DeviceRepository {
  Future<Either<Failure, List<Device>>> getDevices();

  Future<Either<Failure, DeviceState>> getDeviceState(String deviceId);

  Future<Either<Failure, void>> sendCommand({
    required String deviceId,
    required Map<String, dynamic> command,
  });
}