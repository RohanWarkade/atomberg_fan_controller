// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../core/errors/failure.dart';
// import '../../domain/entities/device.dart';
// import '../../domain/entities/device_state.dart';
// import '../../domain/usecases/fetch_device_state.dart';
// import '../../domain/usecases/send_device_command.dart';
// import 'repository_providers.dart';

// // Device Detail State
// class DeviceDetailState {
//   final Device device;
//   final DeviceState deviceState;
//   final bool isLoading;
//   final bool isSendingCommand;
//   final String? error;
//   final String? commandSuccess;

//   const DeviceDetailState({
//     required this.device,
//     required this.deviceState,
//     this.isLoading = false,
//     this.isSendingCommand = false,
//     this.error,
//     this.commandSuccess,
//   });

//   get lastUpdated => null;

//   DeviceDetailState copyWith({
//     Device? device,
//     DeviceState? deviceState,
//     bool? isLoading,
//     bool? isSendingCommand,
//     String? error,
//     String? commandSuccess,
//   }) {
//     return DeviceDetailState(
//       device: device ?? this.device,
//       deviceState: deviceState ?? this.deviceState,
//       isLoading: isLoading ?? this.isLoading,
//       isSendingCommand: isSendingCommand ?? this.isSendingCommand,
//       error: error,
//       commandSuccess: commandSuccess,
//     );
//   }
// }

// // Device Detail Notifier
// class DeviceDetailNotifier extends StateNotifier<DeviceDetailState> {
//   final FetchDeviceState fetchDeviceState;
//   final SendDeviceCommand sendDeviceCommand;

//   DeviceDetailNotifier({
//     required this.fetchDeviceState,
//     required this.sendDeviceCommand,
//     required Device device,
//   }) : super(DeviceDetailState(
//           device: device,
//           deviceState: DeviceState.initial,
//         ));

//   Future<void> loadDeviceState() async {
//     state = state.copyWith(isLoading: true, error: null);

//     final result = await fetchDeviceState(state.device.deviceId);

//     result.fold(
//       (failure) {
//         state = state.copyWith(
//           isLoading: false,
//           error: _mapFailureToMessage(failure),
//         );
//       },
//       (deviceState) {
//         state = state.copyWith(
//           isLoading: false,
//           deviceState: deviceState,
//           error: null,
//         );
//       },
//     );
//   }

//   Future<void> sendCommand(Map<String, dynamic> command) async {
//     state = state.copyWith(
//       isSendingCommand: true,
//       error: null,
//       commandSuccess: null,
//     );

//     final result = await sendDeviceCommand(
//       deviceId: state.device.deviceId,
//       command: command,
//     );

//     await result.fold(
//       (failure) async {
//         state = state.copyWith(
//           isSendingCommand: false,
//           error: _mapFailureToMessage(failure),
//         );
//       },
//       (_) async {
//         state = state.copyWith(
//           isSendingCommand: false,
//           commandSuccess: 'Command sent successfully',
//         );

//         // Refresh device state after a short delay
//         await Future.delayed(const Duration(seconds: 1));
//         await loadDeviceState();
//       },
//     );
//   }

//   Future<void> setPower(bool value) async {
//     // Optimistically update UI
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(power: value),
//     );
//     await sendCommand({'power': value});
//   }

//   Future<void> setSpeed(int value) async {
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(speed: value),
//     );
//     await sendCommand({'speed': value});
//   }

//   Future<void> setSleepMode(bool value) async {
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(sleepMode: value),
//     );
//     await sendCommand({'sleep': value});
//   }

//   Future<void> setTimer(int hours) async {
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(timerHours: hours),
//     );
//     await sendCommand({'timer': hours});
//   }

//   Future<void> setLed(bool value) async {
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(led: value),
//     );
//     await sendCommand({'led': value});
//   }

//   Future<void> setBrightness(int value) async {
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(brightness: value),
//     );
//     await sendCommand({'brightness': value});
//   }

//   Future<void> setColorMode(String mode) async {
//     state = state.copyWith(
//       deviceState: state.deviceState.copyWith(colorMode: mode),
//     );
//     await sendCommand({'light_mode': mode});
//   }

//   String _mapFailureToMessage(Failure failure) {
//     if (failure is NetworkFailure) {
//       return 'Network error. Please check your connection.';
//     } else if (failure is AuthFailure) {
//       return 'Authentication expired. Please login again.';
//     } else if (failure is ServerFailure) {
//       return 'Server error. Please try again later.';
//     } else {
//       return 'An error occurred.';
//     }
//   }
// }

// // Device Detail Provider Factory
// final deviceDetailProvider = StateNotifierProvider.family<
//     DeviceDetailNotifier,
//     DeviceDetailState,
//     Device
// >((ref, device) {
//   return DeviceDetailNotifier(
//     fetchDeviceState: ref.read(fetchDeviceStateProvider),
//     sendDeviceCommand: ref.read(sendDeviceCommandProvider),
//     device: device,
//   );
// });

// ============================================================================
// lib/presentation/providers/device_detail_provider.dart
// FIXED VERSION - Works with your custom UI, prevents state reset
// ============================================================================
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_state.dart';
import '../../domain/usecases/fetch_device_state.dart';
import '../../domain/usecases/send_device_command.dart';
import 'repository_providers.dart';

// Device Detail State
class DeviceDetailState {
  final Device device;
  final DeviceState deviceState;
  final bool isLoading;
  final bool isSendingCommand;
  final String? error;
  final String? commandSuccess;

  const DeviceDetailState({
    required this.device,
    required this.deviceState,
    this.isLoading = false,
    this.isSendingCommand = false,
    this.error,
    this.commandSuccess,
  });

  DeviceDetailState copyWith({
    Device? device,
    DeviceState? deviceState,
    bool? isLoading,
    bool? isSendingCommand,
    String? error,
    String? commandSuccess,
  }) {
    return DeviceDetailState(
      device: device ?? this.device,
      deviceState: deviceState ?? this.deviceState,
      isLoading: isLoading ?? this.isLoading,
      isSendingCommand: isSendingCommand ?? this.isSendingCommand,
      error: error,
      commandSuccess: commandSuccess,
    );
  }
}

// Device Detail Notifier
class DeviceDetailNotifier extends StateNotifier<DeviceDetailState> {
  final FetchDeviceState fetchDeviceState;
  final SendDeviceCommand sendDeviceCommand;

  DeviceDetailNotifier({
    required this.fetchDeviceState,
    required this.sendDeviceCommand,
    required Device device,
  }) : super(DeviceDetailState(
          device: device,
          deviceState: DeviceState.initial,
        ));

  Future<void> loadDeviceState() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await fetchDeviceState(state.device.deviceId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: _mapFailureToMessage(failure),
        );
      },
      (deviceState) {
        state = state.copyWith(
          isLoading: false,
          deviceState: deviceState,
          error: null,
        );
      },
    );
  }

  // FIXED: Send command WITHOUT automatic refresh
  Future<void> sendCommand(Map<String, dynamic> command) async {
    state = state.copyWith(
      isSendingCommand: true,
      error: null,
      commandSuccess: null,
    );

    final result = await sendDeviceCommand(
      deviceId: state.device.deviceId,
      command: command,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isSendingCommand: false,
          error: _mapFailureToMessage(failure),
        );
      },
      (_) {
        // SUCCESS - Keep the optimistic update, DON'T reload
        state = state.copyWith(
          isSendingCommand: false,
          commandSuccess: 'Command sent successfully',
        );

        // REMOVED: Auto-refresh that was causing the reset
        // The UI already shows the correct value from optimistic update
      },
    );
  }

  // Control methods with OPTIMISTIC UPDATES (update UI first, then send)
  Future<void> setPower(bool value) async {
    // 1. Update UI immediately (optimistic)
    final updatedState = state.deviceState.copyWith(power: value);
    state = state.copyWith(deviceState: updatedState);

    // 2. Send command in background (no reload after)
    await sendCommand({'power': value});
  }

  Future<void> setSpeed(int value) async {
    // 1. Update UI immediately
    final updatedState = state.deviceState.copyWith(speed: value);
    state = state.copyWith(deviceState: updatedState);

    // 2. Send command
    await sendCommand({'speed': value});
  }

  Future<void> setSleepMode(bool value) async {
    final updatedState = state.deviceState.copyWith(sleepMode: value);
    state = state.copyWith(deviceState: updatedState);
    await sendCommand({'sleep': value});
  }

  Future<void> setTimer(int hours) async {
    final updatedState = state.deviceState.copyWith(timerHours: hours);
    state = state.copyWith(deviceState: updatedState);
    await sendCommand({'timer': hours});
  }

  Future<void> setLed(bool value) async {
    final updatedState = state.deviceState.copyWith(led: value);
    state = state.copyWith(deviceState: updatedState);
    await sendCommand({'led': value});
  }

  Future<void> setBrightness(int value) async {
    final updatedState = state.deviceState.copyWith(brightness: value);
    state = state.copyWith(deviceState: updatedState);
    await sendCommand({'brightness': value});
  }

  Future<void> setColorMode(String mode) async {
    final updatedState = state.deviceState.copyWith(colorMode: mode);
    state = state.copyWith(deviceState: updatedState);
    await sendCommand({'light_mode': mode});
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    } else if (failure is AuthFailure) {
      return 'Authentication expired. Please login again.';
    } else if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else {
      return 'An error occurred.';
    }
  }
}

// Device Detail Provider Factory
final deviceDetailProvider = StateNotifierProvider.family<DeviceDetailNotifier,
    DeviceDetailState, Device>((ref, device) {
  return DeviceDetailNotifier(
    fetchDeviceState: ref.read(fetchDeviceStateProvider),
    sendDeviceCommand: ref.read(sendDeviceCommandProvider),
    device: device,
  );
});
