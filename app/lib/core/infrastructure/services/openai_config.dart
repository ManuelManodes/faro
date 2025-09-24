/// Configuración de OpenAI
/// Este archivo debe ser configurado con tu API key real
class OpenAIConfig {
  // IMPORTANTE: Configura tu API key aquí
  // Obtén tu API key en: https://platform.openai.com/account/api-keys
  // Para producción, usa variables de entorno o un archivo de configuración seguro
  static const String apiKey = 'tu-api-key-aqui';

  // Verifica si la API key está configurada
  static bool get isConfigured =>
      apiKey.isNotEmpty && 
      apiKey != 'tu-api-key-aqui' && 
      apiKey.startsWith('sk-');
}
