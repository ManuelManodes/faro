import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/assistant_chat_controller.dart';
import 'common/common.dart';
import 'common/pressable_icon_button.dart';
import 'common/confirmation_dialog.dart';

/// Widget principal del chat del asistente virtual
class AssistantChatWidget extends StatefulWidget {
  const AssistantChatWidget({super.key});

  @override
  State<AssistantChatWidget> createState() => _AssistantChatWidgetState();
}

class _AssistantChatWidgetState extends State<AssistantChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundPrimary(isDarkMode),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header del chat
              _buildChatHeader(context, isDarkMode),

              // Área de mensajes
              Expanded(child: _buildMessagesArea(context, isDarkMode)),

              // Área de entrada de mensaje
              _buildMessageInput(context, isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatHeader(BuildContext context, bool isDarkMode) {
    return Consumer<AssistantChatController>(
      builder: (context, chatController, child) {
        if (chatController.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () {
                  _showClearChatDialog(context, isDarkMode);
                },
                icon: Icon(
                  Icons.clear_all,
                  color: AppColors.iconSecondary(isDarkMode),
                  size: 18,
                ),
                tooltip: 'Limpiar chat',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesArea(BuildContext context, bool isDarkMode) {
    return Consumer<AssistantChatController>(
      builder: (context, chatController, child) {
        if (chatController.isEmpty) {
          return _buildEmptyState(context, isDarkMode);
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: chatController.messages.length,
          itemBuilder: (context, index) {
            final message = chatController.messages[index];
            return _buildMessageBubble(context, isDarkMode, message);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Colors.green.shade600,
            ),
          ),
          AppSpacing.lgV,
          Text(
            '¡Hola! Soy tu asistente virtual',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(isDarkMode),
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.smV,
          Text(
            'Selecciona un documento y comienza a hacer preguntas',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(isDarkMode),
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.lgV,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Puedo ayudarte con:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                AppSpacing.smV,
                _buildSuggestionChip(
                  context,
                  isDarkMode,
                  'Buscar información específica',
                ),
                _buildSuggestionChip(context, isDarkMode, 'Explicar conceptos'),
                _buildSuggestionChip(context, isDarkMode, 'Resumir secciones'),
                _buildSuggestionChip(
                  context,
                  isDarkMode,
                  'Responder preguntas',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(
    BuildContext context,
    bool isDarkMode,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
          AppSpacing.xsH,
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    bool isDarkMode,
    ChatMessage message,
  ) {
    if (message.isLoading) {
      return _buildLoadingBubble(context, isDarkMode);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isUser) const Spacer(),

          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: message.isUser
                  ? AppColors.surface(isDarkMode)
                  : AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Icon(
              message.isUser ? Icons.person : Icons.smart_toy,
              color: AppColors.textPrimary(isDarkMode),
              size: 18,
            ),
          ),
          AppSpacing.smH,

          // Mensaje
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface(isDarkMode),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.dividerTheme(isDarkMode),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary(isDarkMode),
                        ),
                      ),
                      AppSpacing.xsV,
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),

                // Icono de copiar sutil (debajo de la tarjeta)
                if (!message.isUser) ...[
                  AppSpacing.xsV,
                  CopyButton(textToCopy: message.content, size: 14),
                ],
              ],
            ),
          ),

          if (!message.isUser) const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Icon(
              Icons.smart_toy,
              color: AppColors.iconPrimary(isDarkMode),
              size: 18,
            ),
          ),
          AppSpacing.smH,

          // Indicador de carga
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                AppSpacing.smH,
                Text(
                  'Escribiendo...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary(isDarkMode),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Campo de texto
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary(isDarkMode),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.dividerTheme(isDarkMode),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.dividerTheme(isDarkMode),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.dividerTheme(isDarkMode),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          AppSpacing.smH,

          // Botón de enviar
          Consumer<AssistantChatController>(
            builder: (context, chatController, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: chatController.isTyping ? null : _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  tooltip: 'Enviar mensaje',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<AssistantChatController>().addUserMessage(message);
    _messageController.clear();
    _focusNode.requestFocus();

    // Scroll al final después de un breve delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showClearChatDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => ClearChatDialog(
        onConfirm: () {
          context.read<AssistantChatController>().clearChat();
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
