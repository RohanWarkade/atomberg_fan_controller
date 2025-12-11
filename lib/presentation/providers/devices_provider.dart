import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/device.dart';
import '../../domain/usecases/fetch_devices.dart';
import 'repository_providers.dart';

// Devices State
class DevicesState {
  final List<Device> devices;
  final bool isLoading;
  final String? error;

  const DevicesState({
    this.devices = const [],
    this.isLoading = false,
    this.error,
  });

  DevicesState copyWith({
    List<Device>? devices,
    bool? isLoading,
    String? error,
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Devices Notifier
class DevicesNotifier extends StateNotifier<DevicesState> {
  final FetchDevices fetchDevices;

  DevicesNotifier({required this.fetchDevices}) : super(const DevicesState());

  Future<void> loadDevices() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await fetchDevices();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: _mapFailureToMessage(failure),
        );
      },
      (devices) {
        state = state.copyWith(
          isLoading: false,
          devices: devices,
          error: null,
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    } else if (failure is AuthFailure) {
      return 'Authentication expired. Please login again.';
    } else if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else {
      return 'Failed to load devices.';
    }
  }
}

// Devices Provider
final devicesProvider = StateNotifierProvider<DevicesNotifier, DevicesState>((ref) {
  return DevicesNotifier(
    fetchDevices: ref.read(fetchDevicesProvider),
  );
});