import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common.dart';

/// Botones reutilizables con diseño consistente
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonStyle style;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style = AppButtonStyle.primary,
    this.padding,
    this.borderRadius,
  });

  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.primary,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.secondary,
    );
  }

  factory AppButton.outlined({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.outlined,
    );
  }

  factory AppButton.white({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.white,
    );
  }

  factory AppButton.green({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.green,
    );
  }

  factory AppButton.surface({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.surface,
    );
  }

  factory AppButton.elegantGreen({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.elegantGreen,
    );
  }

  factory AppButton.elegantRed({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.elegantRed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (style) {
      case AppButtonStyle.primary:
        return _buildPrimaryButton(theme);
      case AppButtonStyle.secondary:
        return _buildSecondaryButton(theme);
      case AppButtonStyle.outlined:
        return _buildOutlinedButton(theme);
      case AppButtonStyle.white:
        return _buildWhiteButton(theme);
      case AppButtonStyle.green:
        return _buildGreenButton(theme);
      case AppButtonStyle.surface:
        return _buildSurfaceButton(theme);
      case AppButtonStyle.elegantGreen:
        return _buildElegantGreenButton(theme);
      case AppButtonStyle.elegantRed:
        return _buildElegantRedButton(theme);
    }
  }

  Widget _buildPrimaryButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(ThemeData theme) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: TextButton.styleFrom(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(ThemeData theme) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildWhiteButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 1,
      ),
    );
  }

  Widget _buildGreenButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildSurfaceButton(ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (icon != null) {
          return TextButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(text),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.surface(themeProvider.isDarkMode),
              foregroundColor: AppColors.textPrimary(themeProvider.isDarkMode),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                side: BorderSide(
                  color: AppColors.dividerTheme(themeProvider.isDarkMode),
                ),
              ),
            ),
          );
        } else {
          return TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.surface(themeProvider.isDarkMode),
              foregroundColor: AppColors.textPrimary(themeProvider.isDarkMode),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                side: BorderSide(
                  color: AppColors.dividerTheme(themeProvider.isDarkMode),
                ),
              ),
            ),
            child: Text(text),
          );
        }
      },
    );
  }

  Widget _buildElegantGreenButton(ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
            label: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.green.shade600,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildElegantRedButton(ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
            label: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.red.shade600,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }
}

enum AppButtonStyle {
  primary,
  secondary,
  outlined,
  white,
  green,
  surface,
  elegantGreen,
  elegantRed,
}
