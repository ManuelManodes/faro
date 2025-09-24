import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para interactuar con la API de OpenAI
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';

  // API Key - configurar como variable de entorno
  // Para desarrollo: export OPENAI_API_KEY=tu-clave-aqui
  static const String _apiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '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',
  );

  /// Verifica si la API key está configurada correctamente
  bool get isConfigured => _apiKey.isNotEmpty && _apiKey != 'tu-api-key-aqui';

  /// Obtiene los headers necesarios para las peticiones a OpenAI
  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
  };

  /// Prueba la conexión con la API de OpenAI
  Future<OpenAIResponse<bool>> testConnection() async {
    if (!isConfigured) {
      return OpenAIResponse(
        success: false,
        error: 'API Key no configurada. Revisa tu archivo .env',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/models'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return OpenAIResponse(success: true, data: true);
      } else {
        final errorData = json.decode(response.body);
        return OpenAIResponse(
          success: false,
          error:
              'Error ${response.statusCode}: ${errorData['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return OpenAIResponse(success: false, error: 'Error de conexión: $e');
    }
  }

  /// Envía un mensaje al chat de OpenAI
  Future<OpenAIResponse<String>> sendMessage({
    required String message,
    String model = 'gpt-3.5-turbo',
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    if (!isConfigured) {
      return OpenAIResponse(
        success: false,
        error: 'API Key no configurada. Revisa tu archivo .env',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: _headers,
        body: json.encode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': message},
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return OpenAIResponse(success: true, data: content);
      } else {
        final errorData = json.decode(response.body);
        return OpenAIResponse(
          success: false,
          error:
              'Error ${response.statusCode}: ${errorData['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return OpenAIResponse(success: false, error: 'Error de conexión: $e');
    }
  }

  /// Obtiene la lista de modelos disponibles
  Future<OpenAIResponse<List<String>>> getAvailableModels() async {
    if (!isConfigured) {
      return OpenAIResponse(
        success: false,
        error: 'API Key no configurada. Revisa tu archivo .env',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/models'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final models = (data['data'] as List)
            .map((model) => model['id'] as String)
            .where((id) => id.contains('gpt'))
            .toList();
        return OpenAIResponse(success: true, data: models);
      } else {
        final errorData = json.decode(response.body);
        return OpenAIResponse(
          success: false,
          error:
              'Error ${response.statusCode}: ${errorData['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      return OpenAIResponse(success: false, error: 'Error de conexión: $e');
    }
  }
}

/// Clase para manejar las respuestas de OpenAI de forma tipada
class OpenAIResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  OpenAIResponse({required this.success, this.data, this.error});

  @override
  String toString() {
    if (success) {
      return 'OpenAIResponse(success: true, data: $data)';
    } else {
      return 'OpenAIResponse(success: false, error: $error)';
    }
  }
}
