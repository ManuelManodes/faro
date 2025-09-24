# Despliegue Web - Sistema Faro

## Configuración para Despliegue Web

### Problema
El asistente virtual funciona en local pero no en web porque:
- La API key está hardcodeada en el código
- El código se ejecuta en el navegador del usuario
- No hay acceso a variables de entorno del servidor

### Solución Implementada

#### 1. **Configuración Automática (Recomendada)**
- Variables de entorno se inyectan durante el build
- API key se configura en Vercel/plataforma de despliegue
- No requiere configuración manual del usuario

#### 2. **Configuración Manual (Fallback)**
- Widget de configuración web para que usuarios configuren su API key
- API key se guarda en localStorage del navegador
- Funciona para usuarios que quieren usar su propia API key

## Configuración en Vercel

### Variables de Entorno
Configura estas variables en tu dashboard de Vercel:

```
OPENAI_API_KEY=sk-proj-tu-api-key-aqui
```

### Pasos:
1. Ve a tu proyecto en Vercel
2. Ve a Settings > Environment Variables
3. Agrega `OPENAI_API_KEY` con tu API key real
4. Redespliega la aplicación

## Configuración Manual para Usuarios

### Opción 1: URL Parameter
```
https://tu-app.vercel.app/?openai_api_key=sk-proj-tu-api-key-aqui
```

### Opción 2: Widget de Configuración
1. Abre la aplicación web
2. Ve a la página del Asistente Virtual
3. Usa el widget "Configuración Web - API Key"
4. Ingresa tu API key
5. Haz clic en "Guardar API Key"

## Archivos de Configuración

### `vercel.json`
```json
{
  "buildCommand": "chmod +x vercel-build.sh && ./vercel-build.sh",
  "outputDirectory": "app/build/web",
  "env": {
    "OPENAI_API_KEY": "sk-proj-tu-api-key-aqui"
  }
}
```

### `vercel-build.sh`
- Script de build que inyecta variables de entorno
- Genera `env_config.dart` automáticamente
- Configura la API key durante el build

## Flujo de Configuración

1. **Build Time**: Variables de entorno se inyectan
2. **Runtime**: Sistema intenta usar API key inyectada
3. **Fallback**: Si no hay API key, muestra widget de configuración
4. **User Config**: Usuario puede configurar su propia API key

## Seguridad

- ✅ API key no se expone en el código fuente
- ✅ Variables de entorno se inyectan en build time
- ✅ localStorage solo para configuración manual
- ✅ Validación de formato de API key

## Troubleshooting

### Error: "API Key no configurada"
1. Verifica que la variable de entorno esté configurada en Vercel
2. Redespliega la aplicación
3. Usa el widget de configuración manual

### Error: "CORS" o "Network Error"
1. Verifica que la API key sea válida
2. Comprueba que no haya límites de cuota
3. Revisa la consola del navegador para errores

### Widget de Configuración No Aparece
1. Verifica que estés en un navegador web
2. Recarga la página
3. Verifica que el widget esté en la página del asistente
