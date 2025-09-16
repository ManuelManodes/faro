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

  // Espaciado optimizado para widgets compactos
  static const double micro = 2.0;
  static const double compact = 6.0;
  static const double comfortable = 10.0;

  // Widgets de espaciado reutilizables
  static const Widget microH = SizedBox(width: micro);
  static const Widget xsH = SizedBox(width: xs);
  static const Widget compactH = SizedBox(width: compact);
  static const Widget smH = SizedBox(width: sm);
  static const Widget comfortableH = SizedBox(width: comfortable);
  static const Widget mdH = SizedBox(width: md);
  static const Widget lgH = SizedBox(width: lg);
  static const Widget xlH = SizedBox(width: xl);
  static const Widget xxlH = SizedBox(width: xxl);
  static const Widget xxxlH = SizedBox(width: xxxl);

  static const Widget microV = SizedBox(height: micro);
  static const Widget xsV = SizedBox(height: xs);
  static const Widget compactV = SizedBox(height: compact);
  static const Widget smV = SizedBox(height: sm);
  static const Widget comfortableV = SizedBox(height: comfortable);
  static const Widget mdV = SizedBox(height: md);
  static const Widget lgV = SizedBox(height: lg);
  static const Widget xlV = SizedBox(height: xl);
  static const Widget xxlV = SizedBox(height: xxl);
  static const Widget xxxlV = SizedBox(height: xxxl);
}

/// Colores de la aplicación
class AppColors {
  // Nueva paleta de colores principal
  static const Color primary = Color(0xFF4ECDC4); // Color turquesa más verde
  static const Color primaryDark = Color(
    0xFF5FD4CE,
  ); // Variante más saturada para modo oscuro
  static Color get primaryLight =>
      const Color(0xFF7FEFE9).withValues(alpha: 0.1);

  // Colores base del sistema
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static Color get grey =>
      const Color(0xFF32374A); // Color de texto principal como gris base
  static Color get lightGrey =>
      const Color(0xFFF5F5F5); // Fondo de contenedores

  // Color de acento para elementos destacados
  static const Color accent = Color(0xFFF77E2D); // Elementos destacados
  static const Color accentDark = Color(
    0xFFFF8A4C,
  ); // Variante para modo oscuro

  static Color get divider => const Color(0xFF32374A).withValues(alpha: 0.2);
  static Color get shadow => const Color(0xFF32374A).withValues(alpha: 0.1);

  // Colores de estado (mantenidos como están)
  static const Color error = Colors.red;
  static const Color success = Color(0xFF4CAF50); // Verde plano primario
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;

  // Métodos estáticos para colores según el tema
  static Color textPrimary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFFE8E9EA) : const Color(0xFF2C3E50);
  }

  static Color textSecondary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFFB8B9BA) : const Color(0xFF5A6C7D);
  }

  static Color textTertiary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF88898A) : const Color(0xFF7A8A9A);
  }

  static Color iconPrimary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFFE8E9EA) : const Color(0xFF2C3E50);
  }

  static Color iconSecondary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFFB8B9BA) : const Color(0xFF5A6C7D);
  }

  static Color backgroundPrimary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF1A1B23) : const Color(0xFFF8F9FA);
  }

  static Color backgroundSecondary(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF2A2D3A) : Colors.white;
  }

  static Color surface(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF2A2D3A) : const Color(0xFFF8F9FA);
  }

  static Color dividerTheme(bool isDarkMode) {
    return isDarkMode
        ? const Color(0xFF32374A).withValues(alpha: 0.3)
        : const Color(0xFF32374A).withValues(alpha: 0.1);
  }

  // Métodos para colores de acento según el tema
  static Color accentPrimary(bool isDarkMode) {
    return isDarkMode ? accentDark : accent;
  }

  static Color accentLight(bool isDarkMode) {
    return isDarkMode
        ? accentDark.withValues(alpha: 0.1)
        : accent.withValues(alpha: 0.1);
  }

  static Color accentHover(bool isDarkMode) {
    return isDarkMode
        ? accentDark.withValues(alpha: 0.8)
        : accent.withValues(alpha: 0.8);
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
    color: Colors.white,
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
    color: Colors.white,
    borderRadius: AppBorderRadius.md,
    border: Border.all(color: AppColors.divider),
  );

  static BoxDecoration searchField = BoxDecoration(
    color: Colors.white,
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

/// Estilos de texto consistentes para toda la aplicación
class AppTextStyles {
  // Títulos principales de vistas
  static TextStyle titlePrimary(bool isDarkMode) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary(isDarkMode),
    );
  }

  // Títulos de diálogos
  static TextStyle dialogTitle(bool isDarkMode) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary(isDarkMode),
    );
  }

  // Texto en controles (selectores, botones, etc.)
  static TextStyle controlText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary(isDarkMode),
    );
  }

  // Texto secundario (información, descripciones)
  static TextStyle secondaryText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(isDarkMode),
    );
  }

  // Enlaces del footer
  static TextStyle footerLink(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(isDarkMode),
    );
  }

  // Copyright y texto legal
  static TextStyle copyright(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(isDarkMode),
    );
  }

  // Texto de navegación
  static TextStyle navigationText(bool isDarkMode, bool isActive) {
    return TextStyle(
      fontSize: 12,
      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
      color: isActive
          ? AppColors.textPrimary(isDarkMode)
          : AppColors.textSecondary(isDarkMode),
    );
  }

  // Texto de estado del sistema
  static TextStyle systemStatus(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(isDarkMode),
    );
  }

  // Títulos de sección (subtítulos)
  static TextStyle sectionTitle(bool isDarkMode) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary(isDarkMode),
    );
  }

  // Texto de error
  static TextStyle errorText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.error,
    );
  }

  // Texto de éxito
  static TextStyle successText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.success,
    );
  }

  // Texto de placeholder/hint
  static TextStyle placeholderText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(isDarkMode),
    );
  }

  // Texto de tabla (nombres, datos)
  static TextStyle tableText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary(isDarkMode),
    );
  }

  // Texto de tabla secundario
  static TextStyle tableSecondaryText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(isDarkMode),
    );
  }

  // Texto de resultado (para tests)
  static TextStyle resultText(bool isDarkMode) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary(isDarkMode),
    );
  }

  // Texto de progreso
  static TextStyle progressText(bool isDarkMode) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary(isDarkMode),
    );
  }
}

/// Sistema de bordes reutilizable para toda la aplicación
class AppBorders {
  // Bordes estándar para contenedores principales
  static Border standardBorder(bool isDarkMode) {
    return Border.all(color: AppColors.dividerTheme(isDarkMode), width: 1);
  }

  // Bordes para campos de formulario
  static Border fieldBorder(bool isDarkMode, {bool hasError = false}) {
    return Border.all(
      color: hasError ? AppColors.error : AppColors.dividerTheme(isDarkMode),
      width: 1,
    );
  }

  // Bordes para elementos seleccionados
  static Border selectedBorder(bool isDarkMode) {
    return Border.all(color: AppColors.accentPrimary(isDarkMode), width: 2);
  }

  // Bordes para elementos con error
  static Border errorBorder() {
    return Border.all(color: AppColors.error, width: 1);
  }

  // Bordes para elementos de éxito
  static Border successBorder() {
    return Border.all(color: AppColors.success, width: 1);
  }

  // Bordes para elementos de advertencia
  static Border warningBorder() {
    return Border.all(color: AppColors.warning, width: 1);
  }

  // Bordes para elementos de información
  static Border infoBorder() {
    return Border.all(color: AppColors.info, width: 1);
  }
}

/// Sistema de decoraciones de caja reutilizable
class AppDecorations {
  // Cache para decoraciones estáticas
  static final Map<String, BoxDecoration> _decorationCache = {};

  // Decoración estándar para contenedores principales
  static BoxDecoration standardContainer(bool isDarkMode) {
    final key = 'standard_${isDarkMode}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.surface(isDarkMode),
      borderRadius: BorderRadius.circular(12),
      border: AppBorders.standardBorder(isDarkMode),
    );
  }

  // Decoración para campos de formulario
  static BoxDecoration fieldContainer(
    bool isDarkMode, {
    bool hasError = false,
  }) {
    final key = 'field_${isDarkMode}_${hasError}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.surface(isDarkMode),
      borderRadius: BorderRadius.circular(8),
      border: AppBorders.fieldBorder(isDarkMode, hasError: hasError),
    );
  }

  // Decoración para elementos seleccionados
  static BoxDecoration selectedContainer(bool isDarkMode) {
    final key = 'selected_${isDarkMode}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.accentLight(isDarkMode),
      borderRadius: BorderRadius.circular(8),
      border: AppBorders.selectedBorder(isDarkMode),
    );
  }

  // Decoración para elementos con error
  static BoxDecoration errorContainer(bool isDarkMode) {
    final key = 'error_${isDarkMode}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.error.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: AppBorders.errorBorder(),
    );
  }

  // Decoración para elementos de éxito
  static BoxDecoration successContainer(bool isDarkMode) {
    final key = 'success_${isDarkMode}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.success.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: AppBorders.successBorder(),
    );
  }

  // Decoración para elementos de advertencia
  static BoxDecoration warningContainer(bool isDarkMode) {
    final key = 'warning_${isDarkMode}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.warning.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: AppBorders.warningBorder(),
    );
  }

  // Decoración para elementos de información
  static BoxDecoration infoContainer(bool isDarkMode) {
    final key = 'info_${isDarkMode}';
    return _decorationCache[key] ??= BoxDecoration(
      color: AppColors.info.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: AppBorders.infoBorder(),
    );
  }
}
