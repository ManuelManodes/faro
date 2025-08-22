import 'package:flutter/material.dart';

/// Enum para los tipos de tema disponibles
enum ThemeType { system, light, dark }

/// Provider para gestionar el tema global de la aplicación
class ThemeProvider extends ChangeNotifier {
  ThemeType _currentTheme = ThemeType.system;
  Brightness? _platformBrightness;

  ThemeType get currentTheme => _currentTheme;
  Brightness? get platformBrightness => _platformBrightness;

  /// Actualiza el brillo de la plataforma (llamado desde el widget principal)
  void updatePlatformBrightness(Brightness brightness) {
    if (_platformBrightness != brightness) {
      _platformBrightness = brightness;
      notifyListeners();
    }
  }

  /// Cambia el tema de la aplicación
  void setTheme(ThemeType theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  /// Obtiene el tema actual de Material
  ThemeData getTheme() {
    switch (_currentTheme) {
      case ThemeType.light:
        return _lightTheme;
      case ThemeType.dark:
        return _darkTheme;
      case ThemeType.system:
        // Detecta el tema del sistema basado en el brillo de la plataforma
        final isSystemDark = _platformBrightness == Brightness.dark;
        return isSystemDark ? _darkTheme : _lightTheme;
    }
  }

  /// Obtiene si el tema actual es oscuro (considerando el tema del sistema)
  bool get isDarkMode {
    switch (_currentTheme) {
      case ThemeType.light:
        return false;
      case ThemeType.dark:
        return true;
      case ThemeType.system:
        return _platformBrightness == Brightness.dark;
    }
  }

  /// Tema claro
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.black.withOpacity(0.1),
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black87),
      titleSmall: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
  );

  /// Tema oscuro
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    dividerColor: Colors.white.withOpacity(0.1),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
