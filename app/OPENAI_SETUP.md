# Configuración de OpenAI

## Configurar la API Key

Para que el asistente virtual funcione, necesitas configurar tu API key de OpenAI.

### Pasos:

1. **Obtén tu API Key:**
   - Ve a https://platform.openai.com/account/api-keys
   - Inicia sesión en tu cuenta de OpenAI
   - Crea una nueva API key
   - Copia la clave generada

2. **Configura la API Key:**
   - Abre el archivo `lib/core/infrastructure/services/openai_config.dart`
   - Reemplaza `'tu-api-key-aqui'` con tu API key real
   - Guarda el archivo

3. **Ejemplo:**
   ```dart
   static const String apiKey = 'sk-proj-tu-api-key-aqui';
   ```

### Seguridad

- ⚠️ **NUNCA** subas tu API key al repositorio
- ⚠️ **NUNCA** compartas tu API key públicamente
- ✅ Usa variables de entorno en producción
- ✅ Mantén tu API key segura

### Verificación

Una vez configurada, puedes:
1. Ejecutar la aplicación
2. Ir a la página del Asistente Virtual
3. Usar el widget "Prueba de Conexión OpenAI"
4. Verificar que la conexión sea exitosa

### Solución de Problemas

Si recibes errores 401:
- Verifica que la API key sea correcta
- Asegúrate de que comience con `sk-`
- Verifica que no haya espacios extra
- Comprueba que la API key no haya expirado
