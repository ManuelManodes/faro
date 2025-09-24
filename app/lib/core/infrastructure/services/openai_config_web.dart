import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'env_config.dart';

/// Configuración de OpenAI para Web
/// Maneja la API key de forma segura en el entorno web
class OpenAIConfigWeb {
  // Obtiene la API key desde diferentes fuentes
  static String get apiKey {
    if (kIsWeb) {
      // 1. Intentar obtener desde variables de entorno (build time)
      if (EnvConfig.openaiApiKey != 'tu-api-key-aqui' &&
          EnvConfig.openaiApiKey.startsWith('sk-')) {
        return EnvConfig.openaiApiKey;
      }

      // 2. Intentar obtener desde URL parameters (para testing)
      final urlParams = Uri.parse(html.window.location.href).queryParameters;
      final urlApiKey = urlParams['openai_api_key'];
      if (urlApiKey != null &&
          urlApiKey.isNotEmpty &&
          urlApiKey.startsWith('sk-')) {
        return urlApiKey;
      }

      // 3. Intentar obtener desde localStorage
      final localApiKey = html.window.localStorage['openai_api_key'];
      if (localApiKey != null &&
          localApiKey.isNotEmpty &&
          localApiKey.startsWith('sk-')) {
        return localApiKey;
      }

      // 4. Intentar obtener desde sessionStorage
      final sessionApiKey = html.window.sessionStorage['openai_api_key'];
      if (sessionApiKey != null &&
          sessionApiKey.isNotEmpty &&
          sessionApiKey.startsWith('sk-')) {
        return sessionApiKey;
      }
    }

    // Fallback a configuración por defecto
    return 'tu-api-key-aqui';
  }

  // Guarda la API key en localStorage
  static void saveApiKey(String apiKey) {
    if (kIsWeb && apiKey.startsWith('sk-')) {
      html.window.localStorage['openai_api_key'] = apiKey;
    }
  }

  // Limpia la API key del localStorage
  static void clearApiKey() {
    if (kIsWeb) {
      html.window.localStorage.remove('openai_api_key');
      html.window.sessionStorage.remove('openai_api_key');
    }
  }

  // Verifica si la API key está configurada
  static bool get isConfigured =>
      apiKey.isNotEmpty &&
      apiKey != 'tu-api-key-aqui' &&
      apiKey.startsWith('sk-');
}
