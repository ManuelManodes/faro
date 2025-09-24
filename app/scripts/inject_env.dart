import 'dart:io';

/// Script para inyectar variables de entorno en el build de Flutter Web
void main(List<String> args) async {
  print('🔧 Inyectando variables de entorno...');

  // Leer variables de entorno
  final openaiApiKey =
      Platform.environment['OPENAI_API_KEY'] ?? 'tu-api-key-aqui';

  // Crear archivo de configuración temporal
  final configContent =
      '''
// Archivo generado automáticamente - NO EDITAR
class EnvConfig {
  static const String openaiApiKey = '$openaiApiKey';
}
''';

  // Escribir archivo de configuración
  final configFile = File('lib/core/infrastructure/services/env_config.dart');
  await configFile.writeAsString(configContent);

  print('✅ Variables de entorno inyectadas correctamente');
  print('📝 API Key configurada: ${openaiApiKey.substring(0, 10)}...');
}
