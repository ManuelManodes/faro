/// Entidad de dominio para representar una respuesta de la IA
class AIResponse {
  final String content;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const AIResponse({
    required this.content,
    required this.isSuccess,
    this.errorMessage,
    this.metadata,
    required this.timestamp,
  });

  /// Crea una respuesta exitosa
  factory AIResponse.success({
    required String content,
    Map<String, dynamic>? metadata,
  }) {
    return AIResponse(
      content: content,
      isSuccess: true,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Crea una respuesta de error
  factory AIResponse.error({
    required String errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return AIResponse(
      content: '',
      isSuccess: false,
      errorMessage: errorMessage,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Convierte la respuesta a un mapa para serialización
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Crea una respuesta desde un mapa JSON
  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      content: json['content'] as String,
      isSuccess: json['isSuccess'] as bool,
      errorMessage: json['errorMessage'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'AIResponse(content: $content, isSuccess: $isSuccess, errorMessage: $errorMessage)';
  }
}
