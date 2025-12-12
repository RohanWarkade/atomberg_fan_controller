
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    await ref
        .read(deviceDetailProvider(widget.device).notifier)
        .loadDeviceState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deviceDetailProvider(widget.device));
    final theme = Theme.of(context);

    // Snackbar listener
    ref.listen(deviceDetailProvider(widget.device), (prev, next) {
      if (next.error != null) {
        _showSnack(context, next.error!, Colors.redAccent.shade200);
      } else if (next.commandSuccess != null) {
        _showSnack(context, next.commandSuccess!, Colors.greenAccent.shade400);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1A1614),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(174, 100, 47, 10),
                Color.fromARGB(255, 209, 98, 19),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.device.deviceName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Center(
          
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: Card(
                color: const Color(0xFF2F2724), 
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.zero, 
                child: Padding(
                  
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // STATUS ROW
                      _buildStatusRow(state),

                      const SizedBox(height: 14),

                      // POWER
                      ControlCard.switchControl(
                        title: 'Power',
                        subtitle: state.deviceState.power ? 'ON' : 'OFF',
                        value: state.deviceState.power,
                        onChanged: (value) {
                          ref
                              .read(
                                  deviceDetailProvider(widget.device).notifier)
                              .setPower(value);
                        },
                      ),


                      // SPEED
                      ControlCard.speedControl(
                        speed: state.deviceState.speed,
                        onSpeedChanged: (value) {
                          ref
                              .read(
                                  deviceDetailProvider(widget.device).notifier)
                              .setSpeed(value);
                        },
                      ),


                      ControlCard.switchControl(
                        title: 'Sleep Mode',
                        subtitle: 'Gradually reduces speed',
                        value: state.deviceState.sleepMode,
                        onChanged: (value) {
                          ref
                              .read(
                                  deviceDetailProvider(widget.device).notifier)
                              .setSleepMode(value);
                        },
                      ),


                      ControlCard.timerControl(
                        timerHours: state.deviceState.timerHours,
                        onTimerChanged: (value) {
                          ref
                              .read(
                                  deviceDetailProvider(widget.device).notifier)
                              .setTimer(value);
                        },
                      ),


                      ControlCard.switchControl(
                        title: 'LED Light',
                        subtitle: state.deviceState.led ? 'ON' : 'OFF',
                        value: state.deviceState.led,
                        onChanged: (value) {
                          ref
                              .read(
                                  deviceDetailProvider(widget.device).notifier)
                              .setLed(value);
                        },
                      ),

                      if (widget.device
                          .supportsFeature(DeviceFeature.brightness)) ...[
                        ControlCard.brightnessControl(
                          brightness: state.deviceState.brightness,
                          onBrightnessChanged: (value) {
                            ref
                                .read(deviceDetailProvider(widget.device)
                                    .notifier)
                                .setBrightness(value);
                          },
                        ),
                      ],

                      if (widget.device
                          .supportsFeature(DeviceFeature.colorTemperature)) ...[
                        ControlCard.colorControl(
                          colorMode: state.deviceState.colorMode,
                          onColorChanged: (value) {
                            ref
                                .read(deviceDetailProvider(widget.device)
                                    .notifier)
                                .setColorMode(value);
                          },
                        ),
                      ],

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      
      bottomNavigationBar: state.isSendingCommand
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F2724),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text("Sending command...", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusRow(DeviceDetailState state) {
    final isOnline = state.deviceState.isOnline;

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isOnline ? "Online" : "Offline",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isOnline ? Colors.greenAccent : Colors.redAccent,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          widget.device.model,
          style: TextStyle(color: Colors.grey[350], fontSize: 13),
        ),
      ],
    );
  }

  void _showSnack(BuildContext context, String message, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
