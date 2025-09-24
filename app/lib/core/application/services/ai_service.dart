import '../../domain/entities/ai_request.dart';
import '../../domain/entities/ai_response.dart';
import '../../domain/repositories/ai_repository.dart';

/// Servicio de aplicación para operaciones de IA
/// Orquesta la lógica de negocio relacionada con la IA
class AIService {
  final AIRepository _aiRepository;

  AIService(this._aiRepository);

  /// Procesa un mensaje del usuario y obtiene una respuesta de la IA
  ///
  /// [userMessage] - El mensaje del usuario
  /// [context] - Contexto adicional para la IA (opcional)
  /// [sessionId] - ID de la sesión actual (opcional)
  ///
  /// Retorna un Future<AIResponse> con la respuesta procesada
  Future<AIResponse> processUserMessage({
    required String userMessage,
    String? context,
    String? sessionId,
  }) async {
    try {
      // Crear la solicitud a la IA
      final request = AIRequest(
        message: userMessage,
        context: context,
        sessionId: sessionId,
        metadata: {
          'timestamp': DateTime.now().toIso8601String(),
          'source': 'flutter_app',
        },
      );

      // Enviar la solicitud al repositorio
      final response = await _aiRepository.sendMessage(request);

      return response;
    } catch (e) {
      // En caso de error, retornar una respuesta de error
      return AIResponse.error(
        errorMessage: 'Error procesando mensaje: ${e.toString()}',
        metadata: {
          'error_type': 'processing_error',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  /// Verifica si el servicio de IA está disponible
  ///
  /// Retorna true si está disponible, false en caso contrario
  Future<bool> isServiceAvailable() async {
    try {
      return await _aiRepository.isServiceAvailable();
    } catch (e) {
      return false;
    }
  }

  /// Obtiene información sobre el modelo de IA
  ///
  /// Retorna un mapa con información del modelo
  Future<Map<String, dynamic>> getModelInfo() async {
    try {
      return await _aiRepository.getModelInfo();
    } catch (e) {
      return {
        'error': 'No se pudo obtener información del modelo: ${e.toString()}',
        'available': false,
      };
    }
  }

  /// Procesa un mensaje con contexto de documento
  ///
  /// [userMessage] - El mensaje del usuario
  /// [documentContent] - Contenido del documento para contexto
  /// [sessionId] - ID de la sesión actual
  ///
  /// Retorna un Future<AIResponse> con la respuesta contextualizada
  Future<AIResponse> processMessageWithDocument({
    required String userMessage,
    required String documentContent,
    String? sessionId,
  }) async {
    try {
      // Crear contexto combinando el mensaje y el documento
      final context =
          '''
Documento de referencia:
$documentContent

Pregunta del usuario: $userMessage
''';

      final request = AIRequest(
        message: userMessage,
        context: context,
        sessionId: sessionId,
        metadata: {
          'has_document_context': true,
          'timestamp': DateTime.now().toIso8601String(),
          'source': 'flutter_app',
        },
      );

      final response = await _aiRepository.sendMessage(request);
      return response;
    } catch (e) {
      return AIResponse.error(
        errorMessage: 'Error procesando mensaje con documento: ${e.toString()}',
        metadata: {
          'error_type': 'document_processing_error',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }
}
