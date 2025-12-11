class Device {
  final String deviceId;
  final String deviceName;
  final String model;
  final String series;
  final bool isOnline;

  const Device({
    required this.deviceId,
    required this.deviceName,
    required this.model,
    required this.series,
    required this.isOnline,
  });

  bool supportsFeature(DeviceFeature feature) {
    switch (feature) {
      case DeviceFeature.brightness:
        return series == 'I1' || series == 'S1' || series == 'M1';
      case DeviceFeature.colorTemperature:
        return series == 'I1';
      case DeviceFeature.power:
      case DeviceFeature.speed:
      case DeviceFeature.sleep:
      case DeviceFeature.timer:
      case DeviceFeature.led:
        return true;
    }
  }
}

enum DeviceFeature {
  power,
  speed,
  sleep,
  timer,
  led,
  brightness,
  colorTemperature,
}