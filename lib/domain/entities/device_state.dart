class DeviceState {
  final bool power;
  final int speed;
  final bool sleepMode;
  final int timerHours;
  final bool led;
  final int brightness;
  final String colorMode;
  final bool isOnline;

  const DeviceState({
    required this.power,
    required this.speed,
    required this.sleepMode,
    required this.timerHours,
    required this.led,
    required this.brightness,
    required this.colorMode,
    required this.isOnline,
  });

  DeviceState copyWith({
    bool? power,
    int? speed,
    bool? sleepMode,
    int? timerHours,
    bool? led,
    int? brightness,
    String? colorMode,
    bool? isOnline,
  }) {
    return DeviceState(
      power: power ?? this.power,
      speed: speed ?? this.speed,
      sleepMode: sleepMode ?? this.sleepMode,
      timerHours: timerHours ?? this.timerHours,
      led: led ?? this.led,
      brightness: brightness ?? this.brightness,
      colorMode: colorMode ?? this.colorMode,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  static DeviceState get initial => const DeviceState(
        power: false,
        speed: 1,
        sleepMode: false,
        timerHours: 0,
        led: false,
        brightness: 50,
        colorMode: 'cool',
        isOnline: false,
      );
}
