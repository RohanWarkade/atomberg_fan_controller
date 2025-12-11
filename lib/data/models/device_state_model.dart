import '../../domain/entities/device_state.dart';

class DeviceStateModel extends DeviceState {
  const DeviceStateModel({
    required super.power,
    required super.speed,
    required super.sleepMode,
    required super.timerHours,
    required super.led,
    required super.brightness,
    required super.colorMode,
    required super.isOnline,
  });

  factory DeviceStateModel.fromJson(Map<String, dynamic> json) {
    return DeviceStateModel(
      power: json['power'] as bool? ?? false,
      speed: json['last_recorded_speed'] as int? ?? 1,
      sleepMode: json['sleep_mode'] as bool? ?? false,
      timerHours: json['timer_hours'] as int? ?? 0,
      led: json['led'] as bool? ?? false,
      brightness: json['last_recorded_brightness'] as int? ?? 50,
      colorMode: json['last_recorded_color'] as String? ?? 'cool',
      isOnline: json['is_online'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'power': power,
      'last_recorded_speed': speed,
      'sleep_mode': sleepMode,
      'timer_hours': timerHours,
      'led': led,
      'last_recorded_brightness': brightness,
      'last_recorded_color': colorMode,
      'is_online': isOnline,
    };
  }
}
