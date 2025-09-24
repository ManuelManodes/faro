# 🤖 Instrucciones para usar OpenAI en tu proyecto Faro

## ✅ Configuración completada

Tu proyecto ya está configurado para usar OpenAI de forma segura.

## 🔐 Configuración de API Key

Para usar OpenAI, necesitas configurar tu API key como variable de entorno:

### Opción 1: Variable de entorno (Recomendado)
```bash
export OPENAI_API_KEY=tu-clave-real-aqui
flutter run -d chrome --web-port=8080
```

### Opción 2: Archivo .env (Para desarrollo local)
1. Crea un archivo `.env` en la raíz del proyecto
2. Agrega: `OPENAI_API_KEY=tu-clave-real-aqui`
3. Ejecuta: `flutter run -d chrome --web-port=8080`

## 🚀 Cómo probar la configuración

### Opción 1: Widget de prueba independiente

```dart
import 'package:flutter/material.dart';
import 'core/presentation/widgets/openai_test_widget.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prueba OpenAI')),
      body: OpenAITestWidget(),
    );
  }
}
```

### Opción 2: Widget de diagnóstico completo

```dart
import 'package:flutter/material.dart';
import 'core/presentation/widgets/openai_diagnostic_widget.dart';

class DiagnosticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diagnóstico OpenAI')),
      body: OpenAIDiagnosticWidget(),
    );
  }
}
```

## 🎯 Funcionalidades disponibles

### 1. OpenAIService
- **testConnection()**: Prueba la conexión con OpenAI
- **sendMessage()**: Envía mensajes al chat
- **getAvailableModels()**: Obtiene modelos disponibles

### 2. Widgets de interfaz
- **OpenAITestWidget**: Prueba básica de conexión
- **OpenAIDiagnosticWidget**: Diagnóstico completo
- **OpenAIQuotaWidget**: Estado de cuota
- **OpenAIIntegrationExample**: Chat completo

### 3. Manejo de errores
- **Fallbacks automáticos**: Respuestas inteligentes cuando la API no está disponible
- **Detección de cuota**: Manejo automático de límites de uso
- **Mensajes informativos**: Notificaciones claras del estado

## 🔧 Configuración avanzada

### Variables de entorno disponibles
- `OPENAI_API_KEY`: Tu clave de API de OpenAI
- `OPENAI_MODEL`: Modelo a usar (default: gpt-3.5-turbo)
- `OPENAI_MAX_TOKENS`: Máximo de tokens (default: 1000)

### Ejemplo de uso completo
```dart
import 'core/infrastructure/services/openai_service.dart';

final openAIService = OpenAIService();

// Probar conexión
final connectionTest = await openAIService.testConnection();
if (connectionTest.success) {
  print('✅ OpenAI conectado correctamente');
} else {
  print('❌ Error: ${connectionTest.error}');
}

// Enviar mensaje
final response = await openAIService.sendMessage(
  message: 'Hola, ¿cómo estás?',
  model: 'gpt-3.5-turbo',
  maxTokens: 500,
);

if (response.success) {
  print('🤖 Respuesta: ${response.data}');
} else {
  print('❌ Error: ${response.error}');
}
```

## 🛡️ Seguridad

- ✅ API key no expuesta en el código
- ✅ Variables de entorno para configuración
- ✅ Manejo seguro de errores
- ✅ Validación de configuración

## 🚨 Solución de problemas

### Error: "API Key no configurada"
- Verifica que la variable de entorno esté configurada
- Asegúrate de que la clave no sea 'tu-api-key-aqui'

### Error: "Error 401: Unauthorized"
- Tu API key es inválida o expirada
- Genera una nueva en https://platform.openai.com/api-keys

### Error: "Error 429: Rate limit"
- Has excedido el límite de peticiones
- Espera un momento antes de hacer más peticiones

### Error: "insufficient_quota"
- Has agotado tu cuota de OpenAI
- Revisa tu cuenta en https://platform.openai.com/account/billing

## 📚 Recursos adicionales

- [Documentación oficial de OpenAI](https://platform.openai.com/docs)
- [Modelos disponibles](https://platform.openai.com/docs/models)
- [Precios de OpenAI](https://openai.com/pricing)

## 🎯 Próximos pasos

1. Configura tu API key como variable de entorno
2. Ejecuta la aplicación con `flutter run`
3. Navega al Asistente Virtual
4. Usa los widgets de diagnóstico para verificar la conexión
5. ¡Disfruta de tu asistente con IA!

¡Listo! Tu proyecto Flutter ya está configurado para usar OpenAI de forma segura.