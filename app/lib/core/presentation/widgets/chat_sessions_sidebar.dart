import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_sessions_controller.dart';
import 'common/app_theme.dart';
import 'common/theme_provider.dart';
import 'common/app_button.dart';

/// Widget para la barra lateral de sesiones de chat
class ChatSessionsSidebar extends StatelessWidget {
  const ChatSessionsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          width: 240,
          decoration: BoxDecoration(color: AppColors.surface(isDarkMode)),
          child: Column(
            children: [
              // Header de la barra lateral
              _buildSidebarHeader(context, isDarkMode),

              // Lista de sesiones
              Expanded(child: _buildSessionsList(context, isDarkMode)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebarHeader(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary(isDarkMode),
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerTheme(isDarkMode),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: AppColors.iconPrimary(isDarkMode),
            size: 14,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Conversaciones',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(isDarkMode),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<ChatSessionsController>().createNewSession();
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.surface(isDarkMode),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
              ),
              child: Icon(
                Icons.add,
                color: AppColors.iconPrimary(isDarkMode),
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context, bool isDarkMode) {
    return Consumer<ChatSessionsController>(
      builder: (context, sessionsController, child) {
        if (!sessionsController.hasSessions) {
          return _buildEmptyState(context, isDarkMode);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemCount: sessionsController.sessions.length,
          itemBuilder: (context, index) {
            final session = sessionsController.sessions[index];
            return _buildSessionItem(
              context,
              isDarkMode,
              session,
              sessionsController,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 56,
              color: AppColors.textSecondary(isDarkMode),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay conversaciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary(isDarkMode),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea una nueva conversación para comenzar',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary(isDarkMode),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(
    BuildContext context,
    bool isDarkMode,
    dynamic session,
    ChatSessionsController controller,
  ) {
    final isActive = session.isActive;
    final title = session.getDisplayTitle();
    final lastModified = session.lastModified;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surface(isDarkMode) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: AppColors.dividerTheme(isDarkMode), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.activateSession(session.id),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Contenido de la sesión (solo texto)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isActive
                              ? AppColors.textPrimary(isDarkMode)
                              : AppColors.textSecondary(isDarkMode),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatLastModified(lastModified),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),

                // Botón de eliminar
                if (controller.sessions.length > 1)
                  GestureDetector(
                    onTap: () => _showDeleteSessionDialog(
                      context,
                      session.id,
                      controller,
                    ),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 12,
                        color: AppColors.textTertiary(isDarkMode),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatLastModified(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showDeleteSessionDialog(
    BuildContext context,
    String sessionId,
    ChatSessionsController controller,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(isDarkMode),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Eliminar conversación',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar esta conversación? Esta acción no se puede deshacer.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary(isDarkMode),
          ),
        ),
        actions: [
          AppButton.surface(
            text: 'Cancelar',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.elegantRed(
            text: 'Eliminar',
            onPressed: () {
              controller.deleteSession(sessionId);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
