import 'package:flutter/material.dart';
import '../widgets/openai_integration_example.dart';
import '../widgets/openai_quota_widget.dart';
import '../widgets/openai_test_widget.dart';
import '../widgets/openai_diagnostic_widget.dart';

/// Página del Asistente Virtual
/// Integra el chat completo con OpenAI en una página dedicada
class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Virtual'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Información del asistente',
          ),
        ],
      ),
      body: const Column(
        children: [
          OpenAIQuotaWidget(),
          OpenAITestWidget(),
          OpenAIDiagnosticWidget(),
          Expanded(child: OpenAIIntegrationExample()),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.blue),
            SizedBox(width: 8),
            Text('Asistente Virtual'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu asistente virtual está listo para ayudarte con:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Preguntas generales'),
            Text('• Ayuda con el sistema'),
            Text('• Información educativa'),
            Text('• Soporte técnico'),
            SizedBox(height: 8),
            Text(
              'Escribe tu mensaje en el campo de texto y presiona enviar.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
