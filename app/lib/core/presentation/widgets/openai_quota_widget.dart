import 'package:flutter/material.dart';
import '../../infrastructure/services/openai_service.dart';

/// Widget que muestra el estado de la cuota de OpenAI
class OpenAIQuotaWidget extends StatefulWidget {
  const OpenAIQuotaWidget({super.key});

  @override
  State<OpenAIQuotaWidget> createState() => _OpenAIQuotaWidgetState();
}

class _OpenAIQuotaWidgetState extends State<OpenAIQuotaWidget> {
  final OpenAIService _openAIService = OpenAIService();
  bool _isChecking = false;
  String _statusMessage = '';
  bool _quotaAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _quotaAvailable ? Icons.check_circle : Icons.warning,
                  color: _quotaAvailable ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estado de OpenAI',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_statusMessage.isNotEmpty) ...[
              Text(
                _statusMessage,
                style: TextStyle(
                  color: _quotaAvailable
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
            ],

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _checkQuota,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh, size: 16),
                    label: Text(
                      _isChecking ? 'Verificando...' : 'Verificar cuota',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _quotaAvailable
                          ? Colors.green
                          : Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!_quotaAvailable)
                  TextButton.icon(
                    onPressed: () => _showQuotaInfo(),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Más info'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkQuota() async {
    setState(() {
      _isChecking = true;
      _statusMessage = '';
    });

    try {
      final response = await _openAIService.testConnection();

      setState(() {
        _isChecking = false;
        if (response.success) {
          _quotaAvailable = true;
          _statusMessage = '✅ OpenAI disponible - Cuota activa';
        } else {
          _quotaAvailable = false;
          if (response.error?.contains('429') == true) {
            _statusMessage = '⚠️ Cuota agotada - Usando respuestas de fallback';
          } else {
            _statusMessage = '❌ Error de conexión: ${response.error}';
          }
        }
      });
    } catch (e) {
      setState(() {
        _isChecking = false;
        _quotaAvailable = false;
        _statusMessage = '❌ Error de conexión: $e';
      });
    }
  }

  void _showQuotaInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('Información de Cuota'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de tu API de OpenAI:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Cuota agotada: Has excedido el límite de uso gratuito'),
            Text('• Respuestas de fallback: El asistente sigue funcionando'),
            Text('• Renovación: La cuota se renueva mensualmente'),
            SizedBox(height: 8),
            Text(
              'Para aumentar tu cuota:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('1. Ve a https://platform.openai.com/account/billing'),
            Text('2. Agrega un método de pago'),
            Text('3. Configura límites de gasto'),
            SizedBox(height: 8),
            Text(
              'El asistente seguirá funcionando con respuestas inteligentes de fallback.',
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
