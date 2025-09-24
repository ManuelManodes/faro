import 'package:flutter/material.dart';
import '../../infrastructure/services/openai_service.dart';

/// Widget para probar la conexión con OpenAI
class OpenAITestWidget extends StatefulWidget {
  const OpenAITestWidget({super.key});

  @override
  State<OpenAITestWidget> createState() => _OpenAITestWidgetState();
}

class _OpenAITestWidgetState extends State<OpenAITestWidget> {
  final OpenAIService _openAIService = OpenAIService();
  bool _isTesting = false;
  String _testResult = '';
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
                Icon(
                  _testSuccess ? Icons.check_circle : Icons.help_outline,
                  color: _testSuccess ? Colors.green : Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Prueba de Conexión OpenAI',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Estado de configuración
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
              child: Row(
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
                  Expanded(
                    child: Text(
                      _openAIService.isConfigured
                          ? 'API Key configurada correctamente'
                          : 'API Key no configurada o inválida',
                      style: TextStyle(
                        color: _openAIService.isConfigured
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botón de prueba
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTesting ? null : _testConnection,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_protected_setup),
                label: Text(
                  _isTesting ? 'Probando conexión...' : 'Probar Conexión',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            if (_testResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testSuccess
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
                          _testSuccess ? Icons.check_circle : Icons.error,
                          color: _testSuccess ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _testSuccess
                              ? 'Conexión Exitosa'
                              : 'Error de Conexión',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _testSuccess
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _testResult,
                      style: TextStyle(
                        color: _testSuccess
                            ? Colors.green.shade700
                            : Colors.red.shade700,
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
                        'Información de Configuración',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• La API Key se carga desde variables de entorno (.env)\n'
                    '• Si no hay archivo .env, usa la configuración por defecto\n'
                    '• Verifica que tu clave de OpenAI sea válida\n'
                    '• Asegúrate de tener créditos disponibles en tu cuenta',
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

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = '';
      _testSuccess = false;
    });

    try {
      final response = await _openAIService.testConnection();

      setState(() {
        _isTesting = false;
        _testSuccess = response.success;
        _testResult = response.success
            ? '✅ Conexión exitosa con OpenAI API\n'
                  'Tu API Key está funcionando correctamente.'
            : '❌ Error: ${response.error}\n'
                  'Verifica tu API Key y conexión a internet.';
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testSuccess = false;
        _testResult =
            '❌ Error inesperado: $e\n'
            'Revisa la configuración de tu aplicación.';
      });
    }
  }
}
