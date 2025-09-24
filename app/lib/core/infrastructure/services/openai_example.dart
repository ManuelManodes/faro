import 'package:flutter/material.dart';
import 'openai_service.dart';

/// Ejemplo de uso del servicio de OpenAI
/// Este archivo muestra cómo integrar el servicio en tu aplicación
class OpenAIExample {
  final OpenAIService _openAIService = OpenAIService();

  /// Ejemplo básico de uso del servicio
  Future<void> ejemploBasico() async {
    // 1. Verificar configuración
    if (!_openAIService.isConfigured) {
      print('❌ API Key no configurada');
      return;
    }

    // 2. Probar conexión
    final connectionTest = await _openAIService.testConnection();
    if (connectionTest.success) {
      print('✅ Conexión exitosa con OpenAI');
    } else {
      print('❌ Error de conexión: ${connectionTest.error}');
      return;
    }

    // 3. Enviar mensaje
    final response = await _openAIService.sendMessage(
      message: 'Hola, ¿cómo estás?',
      model: 'gpt-3.5-turbo',
      maxTokens: 500,
    );

    if (response.success) {
      print('🤖 Respuesta: ${response.data}');
    } else {
      print('❌ Error: ${response.error}');
    }
  }

  /// Ejemplo de uso en un widget Flutter
  Widget buildChatWidget() {
    return FutureBuilder<OpenAIResponse<bool>>(
      future: _openAIService.testConnection(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.data!.success) {
          return Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  const Text(
                    'Error de configuración',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Revisa tu archivo .env y asegúrate de tener una API key válida',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ejemploBasico(),
                    child: const Text('Probar conexión'),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          color: Colors.green.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(height: 8),
                Text(
                  'OpenAI configurado correctamente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Puedes usar el asistente virtual',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Ejemplo de chat interactivo
  Future<String> chatInteractivo(String mensaje) async {
    final response = await _openAIService.sendMessage(
      message: mensaje,
      model: 'gpt-3.5-turbo',
      maxTokens: 1000,
      temperature: 0.7,
    );

    if (response.success) {
      return response.data!;
    } else {
      return 'Error: ${response.error}';
    }
  }

  /// Obtener modelos disponibles
  Future<List<String>> obtenerModelos() async {
    final response = await _openAIService.getAvailableModels();
    if (response.success) {
      return response.data!;
    } else {
      print('Error obteniendo modelos: ${response.error}');
      return [];
    }
  }
}

/// Widget de ejemplo para mostrar el estado de la configuración
class OpenAIStatusWidget extends StatelessWidget {
  const OpenAIStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenAIExample().buildChatWidget();
  }
}
