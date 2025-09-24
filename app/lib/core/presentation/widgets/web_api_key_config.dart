import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../infrastructure/services/openai_config_web.dart';

class WebAPIKeyConfigWidget extends StatefulWidget {
  const WebAPIKeyConfigWidget({super.key});

  @override
  State<WebAPIKeyConfigWidget> createState() => _WebAPIKeyConfigWidgetState();
}

class _WebAPIKeyConfigWidgetState extends State<WebAPIKeyConfigWidget> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isKeyValid = false;
  bool _showKey = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _loadCurrentKey();
    }
  }

  void _loadCurrentKey() {
    final currentKey = OpenAIConfigWeb.apiKey;
    setState(() {
      _isKeyValid =
          currentKey.isNotEmpty &&
          currentKey != 'tu-api-key-aqui' &&
          currentKey.startsWith('sk-');
      if (_isKeyValid) {
        _apiKeyController.text = currentKey;
      }
    });
  }

  void _validateKey(String key) {
    setState(() {
      _isKeyValid =
          key.isNotEmpty &&
          key != 'tu-api-key-aqui' &&
          key.startsWith('sk-') &&
          key.length > 20;
    });
  }

  void _toggleKeyVisibility() {
    setState(() {
      _showKey = !_showKey;
    });
  }

  void _saveApiKey() {
    if (_isKeyValid) {
      OpenAIConfigWeb.saveApiKey(_apiKeyController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API Key guardada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _loadCurrentKey(); // Recargar para verificar
    }
  }

  void _clearApiKey() {
    OpenAIConfigWeb.clearApiKey();
    _apiKeyController.clear();
    _validateKey('');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('API Key eliminada'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const SizedBox.shrink(); // No mostrar en móvil/desktop
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.web, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Configuración Web - API Key',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!_isKeyValid) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Para usar el asistente virtual en web, necesitas configurar tu API key de OpenAI.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _apiKeyController,
              onChanged: _validateKey,
              obscureText: !_showKey,
              decoration: InputDecoration(
                labelText: 'API Key de OpenAI',
                hintText: 'sk-proj-...',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _toggleKeyVisibility,
                      icon: Icon(
                        _showKey ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _apiKeyController.text.isNotEmpty && !_isKeyValid
                    ? 'API Key inválida. Debe comenzar con "sk-" y tener al menos 20 caracteres.'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isKeyValid ? _saveApiKey : null,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar API Key'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _clearApiKey,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
            if (_isKeyValid) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'API Key configurada correctamente. El asistente virtual debería funcionar ahora.',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
}
