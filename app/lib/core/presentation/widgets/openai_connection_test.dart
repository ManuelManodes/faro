import 'package:flutter/material.dart';
import '../../infrastructure/services/openai_service.dart';
import '../../infrastructure/services/openai_config.dart';

class OpenAIConnectionTest extends StatefulWidget {
  const OpenAIConnectionTest({super.key});

  @override
  State<OpenAIConnectionTest> createState() => _OpenAIConnectionTestState();
}

class _OpenAIConnectionTestState extends State<OpenAIConnectionTest> {
  final OpenAIService _openAIService = OpenAIService();
  String _testResult = '';
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Probando conexión...\n';
    });

    try {
      // Información de debug
      final apiKey = OpenAIConfig.apiKey;
      setState(() {
        _testResult += 'API Key Length: ${apiKey.length}\n';
        _testResult += 'API Key Start: ${apiKey.substring(0, 10)}...\n';
        _testResult +=
            'API Key End: ...${apiKey.substring(apiKey.length - 10)}\n';
        _testResult += 'Is Configured: ${_openAIService.isConfigured}\n\n';
      });

      // Probar conexión
      final response = await _openAIService.testConnection();

      setState(() {
        if (response.success) {
          _testResult += '✅ CONEXIÓN EXITOSA!\n';
          _testResult += 'La API key está funcionando correctamente.\n';
        } else {
          _testResult += '❌ ERROR DE CONEXIÓN:\n';
          _testResult += '${response.error}\n';
        }
      });
    } catch (e) {
      setState(() {
        _testResult += '❌ ERROR INESPERADO:\n';
        _testResult += '$e\n';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                const Icon(Icons.wifi, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Prueba de Conexión OpenAI',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isLoading ? 'Probando...' : 'Probar Conexión'),
            ),
            const SizedBox(height: 16),
            if (_testResult.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  _testResult,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
