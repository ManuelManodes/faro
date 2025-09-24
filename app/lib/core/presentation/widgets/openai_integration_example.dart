import 'package:flutter/material.dart';
import 'openai_test_widget.dart';
import '../../infrastructure/services/openai_service.dart';

/// Ejemplo de cómo integrar OpenAI en tu aplicación
/// Este archivo muestra diferentes formas de usar el servicio de OpenAI
class OpenAIIntegrationExample extends StatefulWidget {
  const OpenAIIntegrationExample({super.key});

  @override
  State<OpenAITestWidget> createState() => _OpenAITestWidgetState();
}

class _OpenAITestWidgetState extends State<OpenAITestWidget> {
  final OpenAIService _openAIService = OpenAIService();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Virtual - OpenAI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Widget de prueba de configuración
          const OpenAITestWidget(),

          // Chat interface
          if (_openAIService.isConfigured) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Input area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu mensaje...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  message.isUser ? Icons.person : Icons.smart_toy,
                  size: 16,
                  color: message.isUser
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
                Text(
                  message.isUser ? 'Tú' : 'Asistente',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: message.isUser
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(text: text, isUser: true));
      _messageController.clear();
    });

    try {
      final response = await _openAIService.sendMessage(
        message: text,
        model: 'gpt-3.5-turbo',
        maxTokens: 500,
        temperature: 0.7,
      );

      setState(() {
        _isLoading = false;
        if (response.success) {
          _messages.add(ChatMessage(text: response.data!, isUser: false));
        } else {
          _messages.add(
            ChatMessage(text: 'Error: ${response.error}', isUser: false),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(text: 'Error inesperado: $e', isUser: false));
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

/// Widget simple para mostrar el estado de OpenAI
class OpenAIStatusCard extends StatelessWidget {
  const OpenAIStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const OpenAITestWidget(),
            const SizedBox(height: 16),
            const Text(
              'Para usar el asistente virtual, asegúrate de que la configuración esté correcta.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
