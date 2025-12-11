import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  const DeviceModel({
    required super.deviceId,
    required super.deviceName,
    required super.model,
    required super.series,
    required super.isOnline,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['device_id'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? 'Unnamed Fan',
      model: json['model'] as String? ?? 'Unknown',
      series: json['series'] as String? ?? '',
      isOnline: json['is_online'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      'model': model,
      'series': series,
      'is_online': isOnline,
    };
  }
}
