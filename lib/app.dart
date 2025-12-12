import 'package:atomberg_fan_controller/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_theme.dart';
import 'presentation/screens/credential_screen.dart';

// class AtombergApp extends ConsumerWidget {
//   const AtombergApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//       title: 'Atomberg Fan Controller',
//       theme: AppTheme.lightTheme,
//       home: const SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
class AtombergApp extends ConsumerWidget {
  const AtombergApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Atomberg Fan Controller',
      theme: AppTheme.lightTheme, // Light theme
      darkTheme: AppTheme.darkTheme, // Dark theme
      themeMode: ThemeMode.dark, // Force dark theme ON
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
