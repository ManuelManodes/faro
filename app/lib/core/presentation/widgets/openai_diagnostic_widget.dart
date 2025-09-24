import 'package:flutter/material.dart';
import '../../infrastructure/services/openai_service.dart';

/// Widget de diagnóstico detallado para OpenAI
class OpenAIDiagnosticWidget extends StatefulWidget {
  const OpenAIDiagnosticWidget({super.key});

  @override
  State<OpenAIDiagnosticWidget> createState() => _OpenAIDiagnosticWidgetState();
}

class _OpenAIDiagnosticWidgetState extends State<OpenAIDiagnosticWidget> {
  final OpenAIService _openAIService = OpenAIService();
  bool _isTesting = false;
  String _diagnosticResult = '';
  bool _testSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Diagnóstico Detallado OpenAI',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Estado de la API Key
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _openAIService.isConfigured
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _openAIService.isConfigured
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _openAIService.isConfigured
                            ? Icons.check_circle
                            : Icons.error,
                        color: _openAIService.isConfigured
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Estado de API Key',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _openAIService.isConfigured
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _openAIService.isConfigured
                        ? '✅ API Key configurada correctamente'
                        : '❌ API Key no configurada',
                    style: TextStyle(
                      color: _openAIService.isConfigured
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botón de diagnóstico completo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTesting ? null : _runFullDiagnostic,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text(
                  _isTesting
                      ? 'Ejecutando diagnóstico...'
                      : 'Ejecutar Diagnóstico Completo',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            if (_diagnosticResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testSuccess
                        ? Colors.green.shade200
                        : Colors.orange.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _testSuccess ? Icons.check_circle : Icons.warning,
                          color: _testSuccess ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Resultado del Diagnóstico',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _testSuccess
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _diagnosticResult,
                      style: TextStyle(
                        color: _testSuccess
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Información adicional
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Información del Diagnóstico',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Este diagnóstico verificará:\n'
                    '• Estado de la API Key\n'
                    '• Conexión con OpenAI\n'
                    '• Disponibilidad de cuota\n'
                    '• Modelos disponibles\n'
                    '• Respuesta de prueba',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runFullDiagnostic() async {
    setState(() {
      _isTesting = true;
      _diagnosticResult = '';
      _testSuccess = false;
    });

    try {
      String result = '';

      // 1. Verificar API Key
      result += '1. API Key: ';
      if (_openAIService.isConfigured) {
        result += '✅ Configurada correctamente\n';
      } else {
        result += '❌ No configurada\n';
        setState(() {
          _isTesting = false;
          _testSuccess = false;
          _diagnosticResult = result;
        });
        return;
      }

      // 2. Probar conexión
      result += '2. Conexión: ';
      final connectionTest = await _openAIService.testConnection();
      if (connectionTest.success) {
        result += '✅ Conectado exitosamente\n';
      } else {
        result += '❌ Error de conexión: ${connectionTest.error}\n';
      }

      // 3. Probar envío de mensaje
      result += '3. Envío de mensaje: ';
      final messageTest = await _openAIService.sendMessage(
        message: 'Hola, responde solo "OK"',
        model: 'gpt-3.5-turbo',
        maxTokens: 10,
      );

      if (messageTest.success) {
        result += '✅ Mensaje enviado correctamente\n';
        result += 'Respuesta: ${messageTest.data}\n';
      } else {
        result += '❌ Error al enviar mensaje: ${messageTest.error}\n';
      }

      // 4. Obtener modelos disponibles
      result += '4. Modelos disponibles: ';
      final modelsTest = await _openAIService.getAvailableModels();
      if (modelsTest.success) {
        result += '✅ ${modelsTest.data?.length ?? 0} modelos encontrados\n';
        if (modelsTest.data != null && modelsTest.data!.isNotEmpty) {
          result += 'Modelos: ${modelsTest.data!.take(3).join(', ')}...\n';
        }
      } else {
        result += '❌ Error al obtener modelos: ${modelsTest.error}\n';
      }

      setState(() {
        _isTesting = false;
        _testSuccess = messageTest.success;
        _diagnosticResult = result;
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testSuccess = false;
        _diagnosticResult = '❌ Error inesperado durante el diagnóstico: $e';
      });
    }
  }
}
