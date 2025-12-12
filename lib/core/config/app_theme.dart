// import 'package:flutter/material.dart';

// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: Colors.orange,
//         brightness: Brightness.light,
//       ),
//       appBarTheme: const AppBarTheme(
//         centerTitle: true,
//         elevation: 0,
//       ),

//       // FIXED: CardTheme → CardThemeData
//       cardTheme: CardThemeData(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),

//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         filled: true,
//       ),
//     );
//   }
// }
// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Atomberg-like brand colors
  static const Color _brandOrange = Color(0xFFFF6A00); // main orange
  static const Color _brandDeep = Color(0xFF0F1720);   // deep background
  static const Color _brandLightBg = Color(0xFFF7F7F8); // soft light surface
  static const Color _mutedText = Color(0xFF6B7280);

  // ---------- LIGHT THEME ----------
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandOrange,
      brightness: Brightness.light,
      background: _brandLightBg,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Scaffold / background
      scaffoldBackgroundColor: _brandLightBg,

      // Text themes — bold, clean
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: colorScheme.onBackground),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colorScheme.onBackground),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        bodyLarge: const TextStyle(fontSize: 15, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: _mutedText),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.primary),
      ),

      // Card style (modern API: CardTheme)
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      // If your SDK expects CardThemeData instead, replace the above with:
      // cardTheme: CardThemeData(...), // <-- uncomment & use if analyzer wants CardThemeData

      // Elevated / Filled buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        ),
      ),

      // Outlined and Text buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _brandOrange,
          side: BorderSide(color: _brandOrange.withOpacity(0.9)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _brandOrange),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _brandOrange, width: 1.6),
        ),
        hintStyle: TextStyle(color: _mutedText),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _brandOrange,
        unselectedItemColor: _mutedText,
        showUnselectedLabels: true,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _brandOrange,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _brandDeep.withOpacity(0.9),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),

      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.onBackground),

      // Divider
      dividerTheme: DividerThemeData(color: Colors.grey.withOpacity(0.12), thickness: 1),

      // Slider / Switch / Checkbox
      sliderTheme: SliderThemeData(
        activeTrackColor: _brandOrange,
        thumbColor: _brandOrange,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(_brandOrange),
        trackColor: MaterialStateProperty.all(_brandOrange.withOpacity(0.4)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(_brandOrange),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: _brandOrange),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: _brandOrange.withOpacity(0.12),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ---------- DARK THEME ----------
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandOrange,
      brightness: Brightness.dark,
      background: _brandDeep,
      surface: const Color(0xFF111216),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      scaffoldBackgroundColor: _brandDeep,

      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
        bodyLarge: TextStyle(fontSize: 15, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brandOrange),
      ),

      // Card style (modern API)
      cardTheme: CardThemeData(
        color: const Color(0xFF0B0C0D),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),

      // If your SDK expects CardThemeData instead, replace the above with:
      // cardTheme: CardThemeData(...), // <-- uncomment & use if analyzer wants CardThemeData

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white70,
          side: BorderSide(color: Colors.white.withOpacity(0.06)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _brandOrange),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0D0F10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _brandOrange.withOpacity(0.95), width: 1.6),
        ),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF0B0C0D),
        selectedItemColor: _brandOrange,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _brandOrange,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade900,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),

      iconTheme: IconThemeData(color: Colors.white70),

      dividerTheme: DividerThemeData(color: Colors.white.withOpacity(0.06), thickness: 1),

      sliderTheme: SliderThemeData(
        activeTrackColor: _brandOrange,
        thumbColor: _brandOrange,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(_brandOrange),
        trackColor: MaterialStateProperty.all(_brandOrange.withOpacity(0.4)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(_brandOrange),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(color: _brandOrange),

      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF111315),
        selectedColor: _brandOrange.withOpacity(0.16),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
