/// Configuración de OpenAI
/// Este archivo debe ser configurado con tu API key real
class OpenAIConfig {
  // Reemplaza 'tu-api-key-aqui' con tu clave real de OpenAI
  static const String apiKey = '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';
  
  // Verifica si la API key está configurada
  static bool get isConfigured => apiKey.isNotEmpty && apiKey != 'tu-api-key-aqui';
}
