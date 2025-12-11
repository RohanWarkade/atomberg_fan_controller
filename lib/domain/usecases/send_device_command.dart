import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../repositories/device_repository.dart';

class SendDeviceCommand {
  final DeviceRepository repository;

  SendDeviceCommand(this.repository);

  Future<Either<Failure, void>> call({
    required String deviceId,
    required Map<String, dynamic> command,
  }) {
    if (deviceId.trim().isEmpty) {
      return Future.value(
        const Left(ServerFailure('Device ID cannot be empty')),
      );
    }
    if (command.isEmpty) {
      return Future.value(
        const Left(ServerFailure('Command cannot be empty')),
      );
    }
    return repository.sendCommand(deviceId: deviceId, command: command);
  }
}