import 'package:atomberg_fan_controller/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_theme.dart';
import 'presentation/screens/credential_screen.dart';


class AtombergApp extends ConsumerWidget {
  const AtombergApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Atomberg Fan Controller',
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme, 
      themeMode: ThemeMode.dark, 
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
