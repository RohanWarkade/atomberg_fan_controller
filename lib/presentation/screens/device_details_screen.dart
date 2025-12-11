import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constant/app_constants.dart';
import '../../domain/entities/device.dart';
import '../providers/device_detail_provider.dart';
import '../widgets/control_card.dart';

class DeviceDetailScreen extends ConsumerStatefulWidget {
  final Device device;

  const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

  @override
  ConsumerState<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceDetailProvider(widget.device).notifier).loadDeviceState();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(deviceDetailProvider(widget.device).notifier).loadDeviceState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deviceDetailProvider(widget.device));

    // Show error snackbar
    ref.listen<DeviceDetailState>(
      deviceDetailProvider(widget.device),
      (previous, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (next.commandSuccess != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.commandSuccess!),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.deviceName),
        actions: [
          IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.isLoading && !state.isSendingCommand
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  _buildStatusCard(context, state),
                  const SizedBox(height: 16),

                  // Power Control
                  ControlCard.switchControl(
                    title: 'Power',
                    subtitle: state.deviceState.power ? 'ON' : 'OFF',
                    value: state.deviceState.power,
                    onChanged: (value) {
                      ref.read(deviceDetailProvider(widget.device).notifier).setPower(value);
                    },
                  ),
                  const SizedBox(height: 8),

                  // Speed Control
                  ControlCard.speedControl(
                    speed: state.deviceState.speed,
                    onSpeedChanged: (value) {
                      ref.read(deviceDetailProvider(widget.device).notifier).setSpeed(value);
                    },
                  ),
                  const SizedBox(height: 8),

                  // Sleep Mode
                  ControlCard.switchControl(
                    title: 'Sleep Mode',
                    subtitle: 'Gradually reduce speed',
                    value: state.deviceState.sleepMode,
                    onChanged: (value) {
                      ref.read(deviceDetailProvider(widget.device).notifier).setSleepMode(value);
                    },
                  ),
                  const SizedBox(height: 8),

                  // Timer
                  ControlCard.timerControl(
                    timerHours: state.deviceState.timerHours,
                    onTimerChanged: (value) {
                      ref.read(deviceDetailProvider(widget.device).notifier).setTimer(value);
                    },
                  ),
                  const SizedBox(height: 8),

                  // LED Control
                  ControlCard.switchControl(
                    title: 'LED Light',
                    subtitle: state.deviceState.led ? 'ON' : 'OFF',
                    value: state.deviceState.led,
                    onChanged: (value) {
                      ref.read(deviceDetailProvider(widget.device).notifier).setLed(value);
                    },
                  ),

                  // Brightness (if supported)
                  if (widget.device.supportsFeature(DeviceFeature.brightness)) ...[
                    const SizedBox(height: 8),
                    ControlCard.brightnessControl(
                      brightness: state.deviceState.brightness,
                      onBrightnessChanged: (value) {
                        ref.read(deviceDetailProvider(widget.device).notifier).setBrightness(value);
                      },
                    ),
                  ],

                  // Color Temperature (if supported)
                  if (widget.device.supportsFeature(DeviceFeature.colorTemperature)) ...[
                    const SizedBox(height: 8),
                    ControlCard.colorControl(
                      colorMode: state.deviceState.colorMode,
                      onColorChanged: (value) {
                        ref.read(deviceDetailProvider(widget.device).notifier).setColorMode(value);
                      },
                    ),
                  ],

                  if (state.isSendingCommand) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStatusCard(BuildContext context, DeviceDetailState state) {
    final isOnline = state.deviceState.isOnline;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isOnline ? Icons.circle : Icons.circle_outlined,
              color: isOnline ? Colors.green : Colors.red,
              size: 12,
            ),
            const SizedBox(width: 8),
            Text(
              isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                color: isOnline ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              widget.device.model,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}