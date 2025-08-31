import 'package:flutter/material.dart';

/// Espaciado consistente para toda la aplicación
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Widgets de espaciado reutilizables
  static const Widget xsH = SizedBox(width: xs);
  static const Widget smH = SizedBox(width: sm);
  static const Widget mdH = SizedBox(width: md);
  static const Widget lgH = SizedBox(width: lg);
  static const Widget xlH = SizedBox(width: xl);
  static const Widget xxlH = SizedBox(width: xxl);
  static const Widget xxxlH = SizedBox(width: xxxl);

  static const Widget xsV = SizedBox(height: xs);
  static const Widget smV = SizedBox(height: sm);
  static const Widget mdV = SizedBox(height: md);
  static const Widget lgV = SizedBox(height: lg);
  static const Widget xlV = SizedBox(height: xl);
  static const Widget xxlV = SizedBox(height: xxl);
  static const Widget xxxlV = SizedBox(height: xxxl);
}

/// Colores de la aplicación
class AppColors {
  static const Color primary = Colors.white;
  static const Color primaryDark = Colors.white;
  static Color get primaryLight => Colors.grey[100]!;

  static const Color white = Colors.white; // Cambié de #e9ecef a blanco real
  static const Color black = Colors.black;
  static Color get grey => Colors.grey[600]!;
  static Color get lightGrey => const Color(0xFFE9ECEF); // #e9ecef

  static Color get divider => Colors.grey.withValues(alpha: 0.2);
  static Color get shadow => Colors.black.withValues(alpha: 0.1);

  // Colores de estado
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;

  // Métodos estáticos para colores según el tema
  static Color textPrimary(bool isDarkMode) {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  static Color textSecondary(bool isDarkMode) {
    return isDarkMode ? Colors.white70 : Colors.black54;
  }

  static Color textTertiary(bool isDarkMode) {
    return isDarkMode ? Colors.white60 : Colors.black38;
  }

  static Color iconPrimary(bool isDarkMode) {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  static Color iconSecondary(bool isDarkMode) {
    return isDarkMode ? Colors.white70 : Colors.black54;
  }

  static Color backgroundPrimary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF121212) : Colors.white;
  }

  static Color backgroundSecondary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA);
  }

  static Color surface(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
  }

  static Color dividerTheme(bool isDarkMode) {
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.1);
  }
}

/// BorderRadius reutilizables
class AppBorderRadius {
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(20));
}

/// Estilos de contenedor reutilizables
class AppContainerStyles {
  static BoxDecoration card = BoxDecoration(
    color: AppColors.white,
    borderRadius: AppBorderRadius.md,
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration outlined = BoxDecoration(
    color: AppColors.white,
    borderRadius: AppBorderRadius.md,
    border: Border.all(color: AppColors.divider),
  );

  static BoxDecoration searchField = BoxDecoration(
    color: AppColors.white,
    borderRadius: AppBorderRadius.md,
    border: Border.all(color: AppColors.divider),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Métodos estáticos para estilos según el tema
  static BoxDecoration cardTheme(bool isDarkMode) {
    return BoxDecoration(
      color: AppColors.surface(isDarkMode),
      borderRadius: AppBorderRadius.md,
      boxShadow: [
        BoxShadow(
          color: isDarkMode
              ? Colors.black.withValues(alpha: 0.3)
              : AppColors.shadow,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration outlinedTheme(bool isDarkMode) {
    return BoxDecoration(
      color: AppColors.surface(isDarkMode),
      borderRadius: AppBorderRadius.md,
      border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
    );
  }
}
