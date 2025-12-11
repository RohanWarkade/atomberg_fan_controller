import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/device.dart';
import '../repositories/device_repository.dart';

class FetchDevices {
  final DeviceRepository repository;

  FetchDevices(this.repository);

  Future<Either<Failure, List<Device>>> call() {
    return repository.getDevices();
  }
}