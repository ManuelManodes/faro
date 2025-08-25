import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_sessions_controller.dart';

/// Modelo para representar un mensaje en el chat
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Métodos para serialización JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isLoading': isLoading,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      isLoading: json['isLoading'] ?? false,
    );
  }
}

/// Controlador para manejar el chat del asistente virtual
class AssistantChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  static const String _storageKey = 'assistant_chat_messages';

  // Referencia al controlador de sesiones (se establecerá después de la inicialización)
  ChatSessionsController? _sessionsController;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  /// Establece la referencia al controlador de sesiones
  void setSessionsController(ChatSessionsController controller) {
    _sessionsController = controller;
  }

  /// Constructor que carga el historial al inicializar
  AssistantChatController() {
    _loadMessages();
  }

  /// Agrega un mensaje del usuario
  void addUserMessage(String content) {
    if (content.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(message);
    _saveMessages(); // Guardar automáticamente

    // Guardar en la sesión activa si existe
    _sessionsController?.addMessageToActiveSession(message);

    notifyListeners();

    // Simular respuesta de IA
    _simulateAIResponse();
  }

  /// Simula una respuesta de IA
  void _simulateAIResponse() {
    _isTyping = true;
    notifyListeners();

    // Agregar mensaje de carga
    final loadingMessage = ChatMessage(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    _messages.add(loadingMessage);
    notifyListeners();

    // Simular delay de respuesta
    Future.delayed(const Duration(seconds: 2), () {
      _isTyping = false;

      // Remover mensaje de carga
      _messages.removeWhere((msg) => msg.isLoading);

      // Agregar respuesta simulada
      final lastUserMessage = _messages.lastWhere((msg) => msg.isUser);
      final aiResponse = _generateAIResponse(lastUserMessage.content);

      final responseMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(responseMessage);
      _saveMessages(); // Guardar automáticamente

      // Guardar en la sesión activa si existe
      _sessionsController?.addMessageToActiveSession(responseMessage);

      notifyListeners();
    });
  }

  /// Genera una respuesta simulada de IA basada en el mensaje del usuario
  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('hola') ||
        lowerMessage.contains('buenos días') ||
        lowerMessage.contains('buenas')) {
      return '¡Hola! Soy tu asistente virtual. Estoy aquí para ayudarte con cualquier consulta sobre el documento seleccionado. ¿En qué puedo asistirte?';
    }

    if (lowerMessage.contains('qué') && lowerMessage.contains('documento')) {
      return 'Actualmente estoy analizando el documento seleccionado. Puedes hacerme preguntas específicas sobre su contenido y te ayudaré a encontrar la información que necesitas.';
    }

    if (lowerMessage.contains('ayuda') || lowerMessage.contains('cómo')) {
      return 'Puedo ayudarte a:\n• Buscar información específica en el documento\n• Explicar conceptos o procedimientos\n• Resumir secciones del documento\n• Responder preguntas sobre políticas y procedimientos\n\n¿Qué te gustaría saber?';
    }

    if (lowerMessage.contains('resumen') || lowerMessage.contains('resumir')) {
      return 'Basándome en el documento actual, puedo proporcionarte un resumen de los puntos más importantes. ¿Hay alguna sección específica que te interese o prefieres un resumen general?';
    }

    if (lowerMessage.contains('política') ||
        lowerMessage.contains('procedimiento')) {
      return 'He encontrado información relevante sobre políticas y procedimientos en el documento. ¿Podrías ser más específico sobre qué aspecto te interesa conocer?';
    }

    if (lowerMessage.contains('gracias') || lowerMessage.contains('thank')) {
      return '¡De nada! Estoy aquí para ayudarte. Si tienes más preguntas sobre el documento, no dudes en preguntarme.';
    }

    // Respuesta genérica
    return 'Entiendo tu consulta sobre "$userMessage". Basándome en el documento seleccionado, puedo ayudarte con esa información. ¿Podrías ser más específico para que pueda darte una respuesta más precisa?';
  }

  /// Limpia todos los mensajes del chat
  void clearChat() {
    _messages.clear();
    _isTyping = false;
    _saveMessages();
    notifyListeners();
  }

  /// Verifica si el chat está vacío
  bool get isEmpty => _messages.isEmpty;

  /// Obtiene el número total de mensajes
  int get messageCount => _messages.length;

  /// Guarda los mensajes en SharedPreferences
  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = _messages.map((msg) => msg.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(messagesJson));
    } catch (e) {
      // Silenciar errores de guardado para no interrumpir la experiencia
      debugPrint('Error guardando mensajes: $e');
    }
  }

  /// Carga los mensajes desde SharedPreferences
  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesString = prefs.getString(_storageKey);

      if (messagesString != null) {
        final messagesJson = jsonDecode(messagesString) as List;
        _messages.clear();
        _messages.addAll(
          messagesJson.map((json) => ChatMessage.fromJson(json)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      // Silenciar errores de carga para no interrumpir la experiencia
      debugPrint('Error cargando mensajes: $e');
    }
  }

  /// Carga mensajes específicos (para sesiones)
  void loadMessages(List<ChatMessage> messages) {
    _messages.clear();
    _messages.addAll(messages);
    _isTyping = false;
    notifyListeners();
  }
}
