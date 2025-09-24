import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../infrastructure/services/openai_config.dart';

class APIKeyConfigWidget extends StatefulWidget {
  const APIKeyConfigWidget({super.key});

  @override
  State<APIKeyConfigWidget> createState() => _APIKeyConfigWidgetState();
}

class _APIKeyConfigWidgetState extends State<APIKeyConfigWidget> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isKeyValid = false;
  bool _showKey = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentKey();
  }

  void _checkCurrentKey() {
    final currentKey = OpenAIConfig.apiKey;
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

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Cómo obtener tu API Key'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Para configurar tu API Key de OpenAI:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('1. Ve a https://platform.openai.com/account/api-keys'),
            Text('2. Inicia sesión en tu cuenta de OpenAI'),
            Text('3. Haz clic en "Create new secret key"'),
            Text('4. Copia la clave generada'),
            Text('5. Pégalo en el campo de abajo'),
            SizedBox(height: 8),
            Text(
              'Nota: La API key debe comenzar con "sk-" y tener al menos 20 caracteres.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
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
                  _isKeyValid ? Icons.check_circle : Icons.warning,
                  color: _isKeyValid ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Configuración de API Key',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isKeyValid ? Colors.green : Colors.orange,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showInstructions,
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'Instrucciones',
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
                        'La API key no está configurada. El asistente virtual no funcionará hasta que configures una API key válida.',
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
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _apiKeyController.text),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('API Key copiada al portapapeles'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
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
                  onPressed: _isKeyValid
                      ? () {
                          // Aquí normalmente actualizarías la configuración
                          // Por ahora solo mostramos un mensaje
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'API Key configurada correctamente',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar API Key'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _apiKeyController.clear();
                    _validateKey('');
                  },
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
