import '../entities/ai_request.dart';
import '../entities/ai_response.dart';

/// Repositorio de dominio para operaciones de IA
/// Define el contrato que debe implementar la capa de infraestructura
abstract class AIRepository {
  /// Envía una solicitud a la IA y obtiene una respuesta
  ///
  /// [request] - La solicitud a enviar a la IA
  ///
  /// Retorna un Future<AIResponse> con la respuesta de la IA
  Future<AIResponse> sendMessage(AIRequest request);

  /// Verifica si el servicio de IA está disponible
  ///
  /// Retorna true si el servicio está disponible, false en caso contrario
  Future<bool> isServiceAvailable();

  /// Obtiene información sobre el modelo de IA utilizado
  ///
  /// Retorna un mapa con información del modelo
  Future<Map<String, dynamic>> getModelInfo();
}
