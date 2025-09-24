import 'dart:convert';
import 'package:http/http.dart' as http;
import 'openai_config.dart';

/// Servicio para interactuar con la API de OpenAI
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';

  // API Key obtenida desde la configuración
  String get _apiKey {
    final key = OpenAIConfig.apiKey;
    // Debug: verificar que la key no esté truncada
    if (key.length < 50) {
      print('WARNING: API Key parece estar truncada. Longitud: ${key.length}');
    }
    return key;
  }

  /// Verifica si la API key está configurada correctamente
  bool get isConfigured {
    final key = _apiKey;
    final isValid =
        key.isNotEmpty && key != 'tu-api-key-aqui' && key.startsWith('sk-');

    print('DEBUG: API Key validation:');
    print('  - Key length: ${key.length}');
    print('  - Key starts with sk-: ${key.startsWith('sk-')}');
    print('  - Key is not empty: ${key.isNotEmpty}');
    print('  - Key is not placeholder: ${key != 'tu-api-key-aqui'}');
    print('  - Is configured: $isValid');

    return isValid;
  }

  /// Obtiene los headers necesarios para las peticiones a OpenAI
  Map<String, String> get _headers {
    final key = _apiKey;
    print('DEBUG: Usando API Key de longitud: ${key.length}');
    print('DEBUG: Primeros 10 caracteres: ${key.substring(0, 10)}...');
    return {'Authorization': 'Bearer $key', 'Content-Type': 'application/json'};
  }

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
