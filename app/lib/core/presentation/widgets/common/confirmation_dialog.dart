import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'app_button.dart';
import 'theme_provider.dart';

/// Widget reutilizable para dialogs de confirmación
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final IconData icon;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
    this.icon = Icons.help_outline,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return AlertDialog(
          backgroundColor: AppColors.surface(isDarkMode),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                icon,
                color: isDestructive
                    ? Colors.red.shade600
                    : AppColors.iconSecondary(isDarkMode),
              ),
              AppSpacing.smH,
              Text(
                title,
                style: TextStyle(color: AppColors.textPrimary(isDarkMode)),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(color: AppColors.textSecondary(isDarkMode)),
          ),
          actions: [
            AppButton.surface(
              text: cancelText,
              onPressed: () {
                onCancel?.call();
                Navigator.of(context).pop();
              },
            ),
            AppSpacing.smH,
            AppButton.elegantGreen(
              text: confirmText,
              onPressed: () {
                onConfirm?.call();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/// Widget especializado para dialog de limpiar chat
class ClearChatDialog extends StatelessWidget {
  final VoidCallback? onConfirm;

  const ClearChatDialog({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Limpiar chat',
      message:
          '¿Estás seguro de que quieres limpiar todo el historial del chat? Esta acción no se puede deshacer.',
      confirmText: 'Limpiar',
      icon: Icons.clear_all,
      isDestructive: false,
      onConfirm: onConfirm,
    );
  }
}

/// Widget especializado para dialog de eliminar
class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback? onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemName,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Eliminar $itemName',
      message:
          '¿Estás seguro de que quieres eliminar "$itemName"? Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      icon: Icons.delete_outline,
      isDestructive: true,
      onConfirm: onConfirm,
    );
  }
}

/// Widget especializado para dialog de guardar
class SaveConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;

  const SaveConfirmationDialog({
    super.key,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Guardar cambios',
      message: message,
      confirmText: 'Guardar',
      icon: Icons.save_outlined,
      onConfirm: onConfirm,
    );
  }
}
