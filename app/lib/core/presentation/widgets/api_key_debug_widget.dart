import 'package:flutter/material.dart';
import '../../infrastructure/services/openai_service.dart';
import '../../infrastructure/services/openai_config.dart';

class APIKeyDebugWidget extends StatefulWidget {
  const APIKeyDebugWidget({super.key});

  @override
  State<APIKeyDebugWidget> createState() => _APIKeyDebugWidgetState();
}

class _APIKeyDebugWidgetState extends State<APIKeyDebugWidget> {
  final OpenAIService _openAIService = OpenAIService();
  String _debugInfo = '';

  @override
  void initState() {
    super.initState();
    _generateDebugInfo();
  }

  void _generateDebugInfo() {
    final configKey = OpenAIConfig.apiKey;
    final serviceKey = OpenAIConfig.apiKey; // Usar la misma key que el servicio
    final isConfigured = _openAIService.isConfigured;

    setState(() {
      _debugInfo =
          '''
=== DEBUG API KEY ===
Config Key Length: ${configKey.length}
Config Key Start: ${configKey.substring(0, 10)}...
Config Key End: ...${configKey.substring(configKey.length - 10)}

Service Key Length: ${serviceKey.length}
Service Key Start: ${serviceKey.substring(0, 10)}...
Service Key End: ...${serviceKey.substring(serviceKey.length - 10)}

Keys Match: ${configKey == serviceKey}
Is Configured: $isConfigured

Full Config Key: $configKey
      ''';
    });
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
                Icon(Icons.bug_report, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Debug API Key',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: SelectableText(
                _debugInfo,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.red.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateDebugInfo,
              child: const Text('Actualizar Debug Info'),
            ),
          ],
        ),
      ),
    );
  }
}
