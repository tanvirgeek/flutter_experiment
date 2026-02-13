import 'package:flutter/material.dart';
import 'package:flutter_experiment/features/auth/presentation/core/Theme/colors.dart';

class AppTheme {
  AppTheme._();

  // ===============================
  // LIGHT THEME
  // ===============================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primary,

      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.secondary,

      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,

      outline: AppColors.outline,
      shadow: Colors.black,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: Colors.white,
      inversePrimary: AppColors.primary,
    ),

    scaffoldBackgroundColor: AppColors.surface,

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    // Dynamic ElevatedButtons
    elevatedButtonTheme: _elevatedButtonTheme(isDark: false),
  );

  // ===============================
  // DARK THEME
  // ===============================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: AppColors.darkPrimary,
      onPrimary: Colors.black,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkPrimary,

      secondary: AppColors.darkSecondary,
      onSecondary: Colors.black,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkSecondary,

      error: AppColors.darkError,
      onError: Colors.black,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkError,

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkTextSecondary,

      outline: AppColors.darkOutline,
      shadow: Colors.black,
      inverseSurface: AppColors.darkInverseSurface,
      onInverseSurface: Colors.black,
      inversePrimary: AppColors.darkPrimary,
    ),

    scaffoldBackgroundColor: AppColors.darkSurface,

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    // Dynamic ElevatedButtons
    elevatedButtonTheme: _elevatedButtonTheme(isDark: true),
  );

  // ===============================
  // BUTTONS
  // ===============================
  static ElevatedButtonThemeData _elevatedButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return isDark
                ? AppColors.darkPrimaryContainer
                : AppColors.primaryContainer;
          }
          if (states.contains(WidgetState.pressed)) {
            return isDark
                ? AppColors.darkPrimary.withOpacity(0.8)
                : AppColors.primary.withOpacity(0.8);
          }
          return isDark ? AppColors.darkPrimary : AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return isDark ? Colors.black : Colors.white;
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.fromLTRB(40, 16, 48, 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
    );
  }
}
