// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../core/constant/app_constants.dart';
// import '../../domain/entities/device.dart';
// import '../providers/device_detail_provider.dart';
// import '../widgets/control_card.dart';

// class DeviceDetailScreen extends ConsumerStatefulWidget {
//   final Device device;

//   const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

//   @override
//   ConsumerState<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
// }

// class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(deviceDetailProvider(widget.device).notifier).loadDeviceState();
//     });
//   }

//   Future<void> _handleRefresh() async {
//     await ref
//         .read(deviceDetailProvider(widget.device).notifier)
//         .loadDeviceState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(deviceDetailProvider(widget.device));

//     // Show error / success snackbar (floating so it doesn't hide controls)
//     ref.listen<DeviceDetailState>(
//       deviceDetailProvider(widget.device),
//       (previous, next) {
//         if (!mounted) return;
//         if (next.error != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(next.error!),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//               margin: const EdgeInsets.symmetric(horizontal: 16)
//                   .copyWith(bottom: 16),
//             ),
//           );
//         }
//         if (next.commandSuccess != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(next.commandSuccess!),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               margin: const EdgeInsets.symmetric(horizontal: 16)
//                   .copyWith(bottom: 16),
//             ),
//           );
//         }
//       },
//     );

//     // bottom padding to make sure last item is reachable and not hidden by overlays
//     final bottomPadding = MediaQuery.of(context).viewInsets.bottom + 80.0;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.deviceName),
//         actions: [
//           IconButton(
//             onPressed: _handleRefresh,
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Main scrollable content
//             ListView(
//               padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
//               children: [
//                 _buildStatusCard(context, state),
//                 const SizedBox(height: 16),

//                 // Power Control
//                 ControlCard.switchControl(
//                   title: 'Power',
//                   subtitle: state.deviceState.power ? 'ON' : 'OFF',
//                   value: state.deviceState.power,
//                   onChanged: (value) {
//                     ref
//                         .read(deviceDetailProvider(widget.device).notifier)
//                         .setPower(value);
//                   },
//                 ),
//                 const SizedBox(height: 0),

//                 // Speed Control
//                 ControlCard.speedControl(
//                   speed: state.deviceState.speed,
//                   onSpeedChanged: (value) {
//                     ref
//                         .read(deviceDetailProvider(widget.device).notifier)
//                         .setSpeed(value);
//                   },
//                 ),
//                 const SizedBox(height: 0),

//                 // Sleep Mode
//                 ControlCard.switchControl(
//                   title: 'Sleep Mode',
//                   subtitle: 'Gradually reduce speed',
//                   value: state.deviceState.sleepMode,
//                   onChanged: (value) {
//                     ref
//                         .read(deviceDetailProvider(widget.device).notifier)
//                         .setSleepMode(value);
//                   },
//                 ),
//                 const SizedBox(height: 0),

//                 // Timer
//                 ControlCard.timerControl(
//                   timerHours: state.deviceState.timerHours,
//                   onTimerChanged: (value) {
//                     ref
//                         .read(deviceDetailProvider(widget.device).notifier)
//                         .setTimer(value);
//                   },
//                 ),
//                 const SizedBox(height: 0),

//                 // LED Control
//                 ControlCard.switchControl(
//                   title: 'LED Light',
//                   subtitle: state.deviceState.led ? 'ON' : 'OFF',
//                   value: state.deviceState.led,
//                   onChanged: (value) {
//                     ref
//                         .read(deviceDetailProvider(widget.device).notifier)
//                         .setLed(value);
//                   },
//                 ),

//                 // Brightness (if supported)
//                 if (widget.device
//                     .supportsFeature(DeviceFeature.brightness)) ...[
//                   const SizedBox(height: 0),
//                   ControlCard.brightnessControl(
//                     brightness: state.deviceState.brightness,
//                     onBrightnessChanged: (value) {
//                       ref
//                           .read(deviceDetailProvider(widget.device).notifier)
//                           .setBrightness(value);
//                     },
//                   ),
//                 ],

//                 // Color Temperature (if supported)
//                 if (widget.device
//                     .supportsFeature(DeviceFeature.colorTemperature)) ...[
//                   const SizedBox(height: 0),
//                   ControlCard.colorControl(
//                     colorMode: state.deviceState.colorMode,
//                     onColorChanged: (value) {
//                       ref
//                           .read(deviceDetailProvider(widget.device).notifier)
//                           .setColorMode(value);
//                     },
//                   ),
//                 ],

//                 const SizedBox(height: 16),
//               ],
//             ),

//             // Overlay sending indicator (doesn't push content)
//             if (state.isSendingCommand)
//               Positioned(
//                 bottom: 24,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).cardColor,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                         SizedBox(width: 12),
//                         Text('Sending command...'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//             // Optional: full-screen loader when initial loading
//             if (state.isLoading && !state.isSendingCommand)
//               const Positioned.fill(
//                 child: ColoredBox(
//                   color: Color.fromRGBO(255, 255, 255, 0.7),
//                   child: Center(child: CircularProgressIndicator()),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCard(BuildContext context, DeviceDetailState state) {
//     final isOnline = state.deviceState.isOnline;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(
//               isOnline ? Icons.circle : Icons.circle_outlined,
//               color: isOnline ? Colors.green : Colors.red,
//               size: 12,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               isOnline ? 'Online' : 'Offline',
//               style: TextStyle(
//                 color: isOnline ? Colors.green : Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             Text(
//               widget.device.model,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/device_detail_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/entities/device.dart';
// import '../providers/device_detail_provider.dart';
// import '../widgets/control_card.dart';

// class DeviceDetailScreen extends ConsumerStatefulWidget {
//   final Device device;

//   const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

//   @override
//   ConsumerState<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
// }

// class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(deviceDetailProvider(widget.device).notifier).loadDeviceState();
//     });
//   }

//   Future<void> _handleRefresh() async {
//     await ref.read(deviceDetailProvider(widget.device).notifier).loadDeviceState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(deviceDetailProvider(widget.device));
//     final theme = Theme.of(context);

//     // Snackbar listener
//     ref.listen(deviceDetailProvider(widget.device), (prev, next) {
//       if (next.error != null) {
//         _showSnack(context, next.error!, Colors.redAccent.shade200);
//       } else if (next.commandSuccess != null) {
//         _showSnack(context, next.commandSuccess!, Colors.greenAccent.shade400);
//       }
//     });

//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1614), // brownish-dark background

//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(174, 100, 47, 10),
//                 Color.fromARGB(255, 209, 98, 19),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: Text(
//           widget.device.deviceName,
//           style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _handleRefresh,
//             icon: const Icon(Icons.refresh),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.only(top: 16, left: 13, right: 13, bottom: 32),

//           child: Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2A2421), // single brownish-dark container
//               borderRadius: BorderRadius.circular(18),
//             ),

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ---------------- STATUS ---------------- //
//                 _buildStatusRow(state),

//                 const SizedBox(height: 20),

//                 // ---------------- POWER ---------------- //
//                 ControlCard.switchControl(
//                   title: 'Power',
//                   subtitle: state.deviceState.power ? 'ON' : 'OFF',
//                   value: state.deviceState.power,
//                   onChanged: (value) {
//                     ref.read(deviceDetailProvider(widget.device).notifier).setPower(value);
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 // ---------------- SPEED ---------------- //
//                 ControlCard.speedControl(
//                   speed: state.deviceState.speed,
//                   onSpeedChanged: (value) {
//                     ref.read(deviceDetailProvider(widget.device).notifier).setSpeed(value);
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 // ---------------- SLEEP MODE ---------------- //
//                 ControlCard.switchControl(
//                   title: 'Sleep Mode',
//                   subtitle: 'Gradually reduces speed',
//                   value: state.deviceState.sleepMode,
//                   onChanged: (value) {
//                     ref.read(deviceDetailProvider(widget.device).notifier).setSleepMode(value);
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 // ---------------- TIMER ---------------- //
//                 ControlCard.timerControl(
//                   timerHours: state.deviceState.timerHours,
//                   onTimerChanged: (value) {
//                     ref.read(deviceDetailProvider(widget.device).notifier).setTimer(value);
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 // ---------------- LED ---------------- //
//                 ControlCard.switchControl(
//                   title: 'LED Light',
//                   subtitle: state.deviceState.led ? 'ON' : 'OFF',
//                   value: state.deviceState.led,
//                   onChanged: (value) {
//                     ref.read(deviceDetailProvider(widget.device).notifier).setLed(value);
//                   },
//                 ),

//                 if (widget.device.supportsFeature(DeviceFeature.brightness)) ...[
//                   const SizedBox(height: 16),
//                   ControlCard.brightnessControl(
//                     brightness: state.deviceState.brightness,
//                     onBrightnessChanged: (value) {
//                       ref.read(deviceDetailProvider(widget.device).notifier).setBrightness(value);
//                     },
//                   ),
//                 ],

//                 if (widget.device.supportsFeature(DeviceFeature.colorTemperature)) ...[
//                   const SizedBox(height: 16),
//                   ControlCard.colorControl(
//                     colorMode: state.deviceState.colorMode,
//                     onColorChanged: (value) {
//                       ref.read(deviceDetailProvider(widget.device).notifier).setColorMode(value);
//                     },
//                   ),
//                 ],

//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),

//       // ---------------- COMMAND SENDING OVERLAY ---------------- //
//       bottomNavigationBar: state.isSendingCommand
//           ? Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2A2421),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
//                   SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
//                   SizedBox(width: 12),
//                   Text("Sending command...", style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//             )
//           : null,
//     );
//   }

//   Widget _buildStatusRow(DeviceDetailState state) {
//     final isOnline = state.deviceState.isOnline;

//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isOnline ? Colors.greenAccent : Colors.redAccent,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           isOnline ? "Online" : "Offline",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: isOnline ? Colors.greenAccent : Colors.redAccent,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           widget.device.model,
//           style: TextStyle(color: Colors.grey[400], fontSize: 13),
//         ),
//       ],
//     );
//   }

//   void _showSnack(BuildContext context, String message, Color bg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: bg,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }

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
            // limit width so on large screens content doesn't stretch too far
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: Card(
                color: const Color(0xFF2F2724), // warm brown-dark card
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.zero, // spacing handled by outer padding
                child: Padding(
                  // reduced inner padding so content sits closer to card edges
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
