import '../../presentation/controllers/assistant_chat_controller.dart';

/// Modelo que representa una sesión de chat individual
class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastModified;
  final List<ChatMessage> messages;
  final bool isActive;

  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastModified,
    required this.messages,
    this.isActive = false,
  });

  /// Crea una nueva sesión de chat
  factory ChatSession.create({
    required String title,
    List<ChatMessage> messages = const [],
  }) {
    final now = DateTime.now();
    return ChatSession(
      id: _generateId(),
      title: title,
      createdAt: now,
      lastModified: now,
      messages: messages,
    );
  }

  /// Crea una copia de la sesión con nuevos valores
  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastModified,
    List<ChatMessage>? messages,
    bool? isActive,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      messages: messages ?? this.messages,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Actualiza la sesión con nuevos mensajes
  ChatSession withNewMessage(ChatMessage message) {
    final updatedMessages = List<ChatMessage>.from(messages)..add(message);
    return copyWith(messages: updatedMessages, lastModified: DateTime.now());
  }

  /// Marca la sesión como activa
  ChatSession markAsActive() {
    return copyWith(isActive: true);
  }

  /// Marca la sesión como inactiva
  ChatSession markAsInactive() {
    return copyWith(isActive: false);
  }

  /// Obtiene el título de la sesión basado en el primer mensaje
  String getDisplayTitle() {
    if (title.isNotEmpty) return title;
    if (messages.isNotEmpty) {
      final firstMessage = messages.first.content;
      return firstMessage.length > 30
          ? '${firstMessage.substring(0, 30)}...'
          : firstMessage;
    }
    return 'Nuevo chat';
  }

  /// Genera un ID único para la sesión
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Convierte la sesión a JSON para persistencia
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'isActive': isActive,
    };
  }

  /// Crea una sesión desde JSON
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      messages: (json['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}
