# 🤖 Configuración de OpenAI en Flutter

Esta guía te ayudará a configurar de forma segura la API de OpenAI en tu proyecto Flutter.

## ⚠️ Advertencia inicial

**Necesitas una API Key válida desde https://platform.openai.com/**. No existe una clave gratuita universal, pero puedes crear una con cuota limitada o bajo facturación.

## 📋 Pasos de configuración

### 1. Obtener tu API Key

1. Ve a [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Inicia sesión o crea una cuenta
3. Crea una nueva API Key
4. **¡IMPORTANTE!** Copia la clave inmediatamente, no podrás verla de nuevo

### 2. Configurar la API Key

#### Opción A: Usando archivo .env (Recomendado)

1. **Edita el archivo `.env`** en la raíz de tu proyecto:
   ```bash
   # Reemplaza 'tu-api-key-aqui' con tu clave real
   OPENAI_API_KEY=sk-tu-clave-real-aqui
   ```

2. **Instala las dependencias** (ya están agregadas al `pubspec.yaml`):
   ```bash
   flutter pub get
   ```

3. **El archivo `.env` ya está en `.gitignore`** para mantener tu clave segura.

#### Opción B: Usando variables de entorno al compilar

```bash
flutter run --dart-define=OPENAI_API_KEY=sk-tu-clave-real-aqui
```

### 3. Usar el servicio en tu código

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/infrastructure/services/openai_service.dart';

// Obtener la API key
final apiKey = dotenv.env['OPENAI_API_KEY'];

// Usar el servicio
final openAIService = OpenAIService();

// Verificar configuración
if (openAIService.isConfigured) {
  // Probar conexión
  final test = await openAIService.testConnection();
  if (test.success) {
    print('✅ OpenAI configurado correctamente');
  }
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

## 🔧 Funcionalidades disponibles

### OpenAIService

- **`isConfigured`**: Verifica si la API key está configurada
- **`testConnection()`**: Prueba la conexión con OpenAI
- **`sendMessage()`**: Envía un mensaje al chat
- **`getAvailableModels()`**: Obtiene modelos disponibles

### Parámetros de sendMessage()

- **`message`**: El mensaje a enviar (requerido)
- **`model`**: Modelo a usar (default: 'gpt-3.5-turbo')
- **`maxTokens`**: Máximo de tokens en la respuesta (default: 1000)
- **`temperature`**: Creatividad de la respuesta 0-1 (default: 0.7)

## 🛡️ Seguridad

- ✅ El archivo `.env` está en `.gitignore`
- ✅ Las API keys no se incluyen en el código
- ✅ Manejo seguro de errores
- ✅ Validación de configuración

## 🧪 Ejemplo de prueba

```dart
import 'core/infrastructure/services/openai_example.dart';

// Usar el widget de estado
OpenAIStatusWidget()

// O usar directamente el servicio
final example = OpenAIExample();
await example.ejemploBasico();
```

## 🚨 Solución de problemas

### Error: "API Key no configurada"
- Verifica que el archivo `.env` existe
- Asegúrate de que `OPENAI_API_KEY` está definida
- Revisa que la clave no sea 'tu-api-key-aqui'

### Error: "Error de conexión"
- Verifica tu conexión a internet
- Confirma que tu API key es válida
- Revisa que tienes créditos en tu cuenta de OpenAI

### Error: "Error 401: Unauthorized"
- Tu API key es inválida o expirada
- Genera una nueva API key en OpenAI

### Error: "Error 429: Rate limit"
- Has excedido el límite de peticiones
- Espera un momento antes de hacer más peticiones

## 📚 Recursos adicionales

- [Documentación oficial de OpenAI](https://platform.openai.com/docs)
- [Modelos disponibles](https://platform.openai.com/docs/models)
- [Precios de OpenAI](https://openai.com/pricing)

## 🎯 Próximos pasos

1. Configura tu API key en el archivo `.env`
2. Ejecuta `flutter pub get`
3. Prueba la conexión con `OpenAIStatusWidget()`
4. Integra el servicio en tu asistente virtual existente

¡Listo! Tu proyecto Flutter ya está configurado para usar OpenAI de forma segura.
