// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_provider.dart';
// import '../providers/devices_provider.dart';
// import '../widgets/device_card.dart';
// import 'credential_screen.dart';

// class DevicesScreen extends ConsumerStatefulWidget {
//   const DevicesScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
// }

// class _DevicesScreenState extends ConsumerState<DevicesScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(devicesProvider.notifier).loadDevices();
//     });
//   }

//   Future<void> _handleRefresh() async {
//     await ref.read(devicesProvider.notifier).loadDevices();
//   }

//   Future<void> _handleLogout() async {
//     await ref.read(authProvider.notifier).logout();
//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const CredentialScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final devicesState = ref.watch(devicesProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Fans'),
//         actions: [
//           IconButton(
//             onPressed: _handleRefresh,
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh',
//           ),
//           IconButton(
//             onPressed: _handleLogout,
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: _buildBody(devicesState),
//     );
//   }

//   Widget _buildBody(DevicesState state) {
//     if (state.isLoading && state.devices.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (state.error != null && state.devices.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//             const SizedBox(height: 16),
//             Text(
//               state.error!,
//               style: const TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _handleRefresh,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (state.devices.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.devices_other, size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             const Text(
//               'No devices found',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Add fans to your Atomberg Home app',
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _handleRefresh,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: state.devices.length,
//         itemBuilder: (context, index) {
//           return DeviceCard(device: state.devices[index]);
//         },
//       ),
//     );
//   }
// }
// lib/screens/devices_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/devices_provider.dart';
import '../widgets/device_card.dart';
import 'credential_screen.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  @override
  void initState() {
    super.initState();
    // Load devices once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(devicesProvider.notifier).loadDevices();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(devicesProvider.notifier).loadDevices();
  }

  Future<void> _handleLogout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CredentialScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesState = ref.watch(devicesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // AppBar with Atomberg-like gradient + actions
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.95),
                colorScheme.primaryContainer.withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Your Fans',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),

        // Actions: Refresh + Logout (styled)
        actions: [
          IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Body
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(devicesState),
      ),
    );
  }

  Widget _buildBody(DevicesState state) {
    // Loading state with centered spinner (when no devices loaded yet)
    if (state.isLoading && state.devices.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state (when no devices shown + error occurred)
    if (state.error != null && state.devices.isEmpty) {
      return _buildErrorState(state.error!);
    }

    // Empty state (no devices, no error)
    if (state.devices.isEmpty) {
      return _buildEmptyState();
    }

    // Normal list state
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      // Use padding & separated list for better spacing
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        itemCount: state.devices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final device = state.devices[index];

          // Wrap DeviceCard in a nicely styled container to match Atomberg aesthetic
          return Material(
            color: Theme.of(context).cardTheme.color,
            elevation: 2,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // If your DeviceCard already handles taps, remove this InkWell
                // Optionally navigate to device detail screen here
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DeviceCard(device: device),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined, size: 72, color: Colors.red.shade300),
            const SizedBox(height: 18),
            Text(
              'Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.red.shade200),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _handleRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _handleLogout,
                  child: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.white10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // minimal illustration using Icon (replace with image if you have one)
            Icon(Icons.devices_other, size: 84, color: Colors.grey[500]),
            const SizedBox(height: 20),
            const Text(
              'No Fans Connected',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Add fans to your Atomberg account and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Search Devices'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
