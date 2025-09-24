import 'package:flutter/foundation.dart';
import '../../domain/services/reglamento_search_service.dart';

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

/// Controlador para manejar el chat del asistente virtual con búsqueda en reglamento
class AssistantChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final ReglamentoSearchService _searchService = ReglamentoSearchService();
  bool _isInitialized = false;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  bool get isInitialized => _isInitialized;

  /// Constructor
  AssistantChatController() {
    _initializeService();
  }

  /// Inicializa el servicio de búsqueda
  Future<void> _initializeService() async {
    try {
      await _searchService.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error inicializando servicio de reglamento: $e');
    }
  }

  /// Agrega un mensaje del usuario y busca respuesta en el reglamento
  Future<void> addUserMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    notifyListeners();

    // Buscar respuesta en el reglamento
    await _searchAndRespond(content.trim());
  }

  /// Busca respuesta en el reglamento y la agrega al chat
  Future<void> _searchAndRespond(String question) async {
    if (!_isInitialized) {
      _addBotMessage(
        'El servicio aún se está inicializando. Por favor, espera un momento.',
      );
      return;
    }

    _setTyping(true);

    try {
      final result = await _searchService.search(question);

      if (result.found) {
        _addBotMessage(result.content);
      } else {
        _addBotMessage(
          'No encontré información sobre eso en el reglamento interno del colegio.',
        );
      }
    } catch (e) {
      debugPrint('Error buscando en reglamento: $e');
      _addBotMessage(
        'Lo siento, hubo un error al buscar la información. Por favor, intenta de nuevo.',
      );
    } finally {
      _setTyping(false);
    }
  }

  /// Agrega un mensaje del bot
  void _addBotMessage(String content) {
    final botMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(botMessage);
    notifyListeners();
  }

  /// Establece el estado de escritura
  void _setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  /// Limpia todos los mensajes del chat
  void clearChat() {
    _messages.clear();
    _isTyping = false;
    notifyListeners();
  }

  /// Verifica si el chat está vacío
  bool get isEmpty => _messages.isEmpty;

  /// Obtiene el número total de mensajes
  int get messageCount => _messages.length;
}
