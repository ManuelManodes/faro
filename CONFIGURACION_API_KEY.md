# 🔐 Configuración de API Key de OpenAI

## ⚠️ IMPORTANTE: Configuración requerida

Para que la aplicación funcione correctamente, necesitas configurar tu API key de OpenAI.

## 🚀 Opciones de configuración

### Opción 1: Variable de entorno (Recomendado)

```bash
# En tu terminal, antes de ejecutar la aplicación:
export OPENAI_API_KEY=tu-clave-real-de-openai-aqui
cd app
flutter run -d chrome --web-port=8080
```

### Opción 2: Archivo .env (Para desarrollo local)

1. **Crea un archivo `.env` en la carpeta `app/`**:
   ```bash
   cd app
   echo "OPENAI_API_KEY=tu-clave-real-de-openai-aqui" > .env
   ```

2. **Ejecuta la aplicación**:
   ```bash
   flutter run -d chrome --web-port=8080
   ```

## 🔑 Obtener tu API Key

1. Ve a [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Inicia sesión o crea una cuenta
3. Crea una nueva API Key
4. **¡IMPORTANTE!** Copia la clave inmediatamente, no podrás verla de nuevo

## ✅ Verificar configuración

Una vez configurada la API key, puedes verificar que funciona:

1. **Abre la aplicación** en http://localhost:8080
2. **Navega al Asistente Virtual**
3. **Usa el "Diagnóstico Detallado"** para verificar la conexión
4. **Envía un mensaje** en el chat para probar la funcionalidad

## 🛡️ Seguridad

- ✅ La API key no está expuesta en el código
- ✅ Se usa configuración segura con variables de entorno
- ✅ El archivo `.env` está en `.gitignore`
- ✅ Cumple con las políticas de seguridad de GitHub

## 🚨 Solución de problemas

### Error: "API Key no configurada"
- Verifica que la variable de entorno esté configurada
- Asegúrate de que la clave no sea 'tu-api-key-aqui'

### Error: "insufficient_quota"
- Has agotado tu cuota de OpenAI
- Revisa tu cuenta en https://platform.openai.com/account/billing

### Error: "Error 401: Unauthorized"
- Tu API key es inválida o expirada
- Genera una nueva en https://platform.openai.com/api-keys

¡Una vez configurada, tu asistente virtual funcionará con respuestas reales de OpenAI!
