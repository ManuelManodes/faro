import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Badge reutilizable para mostrar etiquetas
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  factory AppBadge.primary({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.primaryLight,
      textColor: AppColors.black,
    );
  }

  factory AppBadge.secondary({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.lightGrey,
      textColor: AppColors.grey,
    );
  }

  factory AppBadge.success({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: Colors.green.withAlpha(24),
      textColor: Colors.green.shade700,
    );
  }

  factory AppBadge.warning({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: Colors.orange.withAlpha(24),
      textColor: Colors.orange.shade700,
    );
  }

  factory AppBadge.error({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: Colors.red.withAlpha(24),
      textColor: Colors.red.shade700,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary.withAlpha(24),
        borderRadius: borderRadius ?? AppBorderRadius.md,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(color: textColor),
      ),
    );
  }
}

/// Avatar reutilizable
class AppAvatar extends StatelessWidget {
  final double radius;
  final Widget? child;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;

  const AppAvatar({
    super.key,
    this.radius = 20,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
  });

  factory AppAvatar.user({Key? key, double radius = 20}) {
    return AppAvatar(
      key: key,
      radius: radius,
      child: Icon(Icons.person, size: radius * 0.8),
    );
  }

  factory AppAvatar.icon({
    Key? key,
    required IconData icon,
    double radius = 20,
  }) {
    return AppAvatar(
      key: key,
      radius: radius,
      child: Icon(icon, size: radius * 0.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}

/// Contenedor con decoración reutilizable
class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
  });

  factory AppContainer.surface({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    bool isDarkMode = false,
  }) {
    return AppContainer(
      key: key,
      padding: padding,
      margin: margin,
      backgroundColor: AppColors.surface(isDarkMode),
      borderRadius: borderRadius ?? AppBorderRadius.md,
      child: child,
    );
  }

  factory AppContainer.outlined({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? borderColor,
    BorderRadius? borderRadius,
    bool isDarkMode = false,
  }) {
    return AppContainer(
      key: key,
      padding: padding,
      margin: margin,
      backgroundColor: AppColors.surface(isDarkMode),
      borderRadius: borderRadius ?? AppBorderRadius.md,
      border: Border.all(
        color: borderColor ?? AppColors.dividerTheme(isDarkMode),
        width: 1,
      ),
      child: child,
    );
  }

  factory AppContainer.elevated({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 4,
    BorderRadius? borderRadius,
    bool isDarkMode = false,
  }) {
    return AppContainer(
      key: key,
      padding: padding,
      margin: margin,
      backgroundColor: AppColors.surface(isDarkMode),
      borderRadius: borderRadius ?? AppBorderRadius.md,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: elevation,
          offset: Offset(0, elevation / 2),
        ),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}

/// Checkbox personalizado reutilizable
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final double size;
  final BorderRadius? borderRadius;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.checkColor,
    this.size = 24,
    this.borderRadius,
  });

  factory AppCheckbox.attendance({
    Key? key,
    required bool value,
    required ValueChanged<bool?> onChanged,
    double size = 24,
  }) {
    return AppCheckbox(
      key: key,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red,
      checkColor: Colors.white,
      size: size,
      borderRadius: BorderRadius.circular(6),
    );
  }

  factory AppCheckbox.standard({
    Key? key,
    required bool value,
    required ValueChanged<bool?> onChanged,
    double size = 24,
  }) {
    return AppCheckbox(
      key: key,
      value: value,
      onChanged: onChanged,
      size: size,
      borderRadius: BorderRadius.circular(4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? (activeColor ?? Colors.blue) : Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
          border: Border.all(
            color: value ? (activeColor ?? Colors.blue) : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: size * 0.6,
                color: checkColor ?? Colors.white,
              )
            : null,
      ),
    );
  }
}

/// Separador reutilizable
class AppDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const AppDivider({super.key, this.height = 1, this.color, this.margin});

  factory AppDivider.horizontal({
    Key? key,
    double height = 1,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return AppDivider(
      key: key,
      height: height,
      color: color,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16),
    );
  }

  factory AppDivider.vertical({
    Key? key,
    double height = 20,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return AppDivider(
      key: key,
      height: height,
      color: color,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      margin: margin,
      color: color ?? theme.dividerColor,
    );
  }
}

/// Fila de estudiante reutilizable para tablas de asistencia
class AppStudentRow extends StatelessWidget {
  final String studentName;
  final String studentInfo;
  final int studentNumber;
  final bool isAbsent;
  final VoidCallback? onToggleAbsence;
  final bool isDarkMode;
  final bool isSelected;
  final VoidCallback? onTap;

  const AppStudentRow({
    super.key,
    required this.studentName,
    required this.studentInfo,
    required this.studentNumber,
    required this.isAbsent,
    this.onToggleAbsence,
    this.isDarkMode = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        backgroundColor: isAbsent
            ? Colors.red.withValues(alpha: 0.05)
            : isSelected
            ? AppColors.primaryLight.withAlpha(30)
            : AppColors.surface(isDarkMode),
        child: Row(
          children: [
            // Número de estudiante
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface(isDarkMode),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
              ),
              child: Center(
                child: Text(
                  '$studentNumber',
                  style: TextStyle(
                    color: AppColors.textSecondary(isDarkMode),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            AppSpacing.mdH,
            // Información del estudiante
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: TextStyle(
                      color: AppColors.textPrimary(isDarkMode),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppSpacing.xsV,
                  Text(
                    studentInfo,
                    style: TextStyle(
                      color: AppColors.textSecondary(isDarkMode),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox de ausencia
            Expanded(
              flex: 1,
              child: Center(
                child: AppCheckbox.attendance(
                  value: isAbsent,
                  onChanged: (_) => onToggleAbsence?.call(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header de tabla reutilizable
class AppTableHeader extends StatelessWidget {
  final List<String> headers;
  final List<double> flexValues;
  final bool isDarkMode;
  final EdgeInsetsGeometry? padding;

  const AppTableHeader({
    super.key,
    required this.headers,
    this.flexValues = const [1, 3, 1],
    this.isDarkMode = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer.surface(
      isDarkMode: isDarkMode,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: List.generate(
          headers.length,
          (index) => Expanded(
            flex: index < flexValues.length ? flexValues[index].toInt() : 1,
            child: Text(
              headers[index],
              style: TextStyle(
                color: AppColors.textSecondary(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// DatePicker personalizado con tema acorde a la aplicación
class AppDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? cancelText,
    String? confirmText,
  }) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      cancelText: cancelText ?? 'Cancelar',
      confirmText: confirmText ?? 'Aceptar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
                    primary: const Color(
                      0xFF2A2A2A,
                    ), // Fondo de fecha seleccionada más suave
                    onPrimary: Colors.white.withValues(
                      alpha: 0.9,
                    ), // Texto sobre fecha seleccionada más suave
                    surface: const Color(
                      0xFF1E1E1E,
                    ), // Fondo del calendario más suave
                    onSurface: Colors.white.withValues(
                      alpha: 0.87,
                    ), // Texto principal más suave
                    onSurfaceVariant: Colors.white.withValues(
                      alpha: 0.6,
                    ), // Texto secundario más suave
                    outline: Colors.white.withValues(
                      alpha: 0.12,
                    ), // Bordes más suaves
                    outlineVariant: Colors.white.withValues(
                      alpha: 0.08,
                    ), // Bordes secundarios más suaves
                    secondary: const Color(
                      0xFF2A2A2A,
                    ), // Color secundario más suave
                    onSecondary: Colors.white.withValues(
                      alpha: 0.9,
                    ), // Texto sobre secundario más suave
                  )
                : ColorScheme.light(
                    primary: AppColors.surface(
                      isDarkMode,
                    ), // Fondo de fecha seleccionada
                    onPrimary: AppColors.textPrimary(
                      isDarkMode,
                    ), // Texto sobre fecha seleccionada
                    surface: AppColors.backgroundPrimary(
                      isDarkMode,
                    ), // Fondo del calendario
                    onSurface: AppColors.textPrimary(
                      isDarkMode,
                    ), // Texto principal del calendario
                    onSurfaceVariant: AppColors.textSecondary(
                      isDarkMode,
                    ), // Texto secundario
                    outline: AppColors.dividerTheme(isDarkMode), // Bordes
                    outlineVariant: AppColors.dividerTheme(
                      isDarkMode,
                    ), // Bordes secundarios
                    secondary: AppColors.surface(
                      isDarkMode,
                    ), // Color secundario
                    onSecondary: AppColors.textPrimary(
                      isDarkMode,
                    ), // Texto sobre secundario
                  ),
            dialogTheme: DialogThemeData(
              backgroundColor: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : AppColors.backgroundPrimary(isDarkMode),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary(isDarkMode),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
