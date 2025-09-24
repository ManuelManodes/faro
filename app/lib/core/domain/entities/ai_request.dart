/// Entidad de dominio para representar una solicitud a la IA
class AIRequest {
  final String message;
  final String? context;
  final String? sessionId;
  final Map<String, dynamic>? metadata;

  const AIRequest({
    required this.message,
    this.context,
    this.sessionId,
    this.metadata,
  });

  /// Convierte la solicitud a un mapa para la API
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'context': context,
      'sessionId': sessionId,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'AIRequest(message: $message, context: $context, sessionId: $sessionId)';
  }
}
