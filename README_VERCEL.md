# 🚀 Despliegue en Vercel - Sistema Faro

## 📋 Configuración Completa para Vercel

Este proyecto está configurado para desplegarse automáticamente en Vercel con Flutter Web.

## 🛠️ Archivos de Configuración

### `vercel.json`
- **Build Command**: `cd faro/app && flutter build web --release`
- **Output Directory**: `faro/app/build/web`
- **Headers de Seguridad**: Configurados para producción
- **Cache**: Optimizado para assets estáticos
- **SPA Routing**: Configurado para Flutter Web

### `package.json`
- Scripts para desarrollo y build
- Metadatos del proyecto
- Configuración de Node.js

### `.gitignore`
- Excluye archivos innecesarios
- Optimizado para Flutter + Vercel

## 🚀 Pasos para Desplegar

### 1. **Preparar el Repositorio**
```bash
# Asegúrate de que todos los archivos estén committeados
git add .
git commit -m "Configuración para Vercel"
git push origin main
```

### 2. **Conectar con Vercel**
1. Ve a [vercel.com](https://vercel.com)
2. Inicia sesión con tu cuenta de GitHub
3. Haz clic en "New Project"
4. Importa tu repositorio `sistema-faro`

### 3. **Configuración en Vercel**
- **Framework Preset**: `Other`
- **Root Directory**: `./` (raíz del proyecto)
- **Build Command**: Se detecta automáticamente desde `vercel.json`
- **Output Directory**: Se detecta automáticamente desde `vercel.json`

### 4. **Variables de Entorno (Opcional)**
Si necesitas configurar Firebase o otras APIs:
```bash
# En Vercel Dashboard > Settings > Environment Variables
FIREBASE_API_KEY=tu_api_key
FIREBASE_PROJECT_ID=faro-4b40e
FIREBASE_AUTH_DOMAIN=tu_proyecto.firebaseapp.com
```

### 5. **Desplegar**
- Haz clic en "Deploy"
- Vercel construirá automáticamente tu aplicación Flutter
- El primer build puede tomar 5-10 minutos

## 🔧 Configuración Avanzada

### **Headers de Seguridad**
```json
{
  "X-Frame-Options": "DENY",
  "X-Content-Type-Options": "nosniff",
  "Referrer-Policy": "strict-origin-when-cross-origin"
}
```

### **Cache Optimization**
- **Assets**: Cache por 1 año (31536000 segundos)
- **HTML/JS**: Sin cache para actualizaciones inmediatas

### **SPA Routing**
- Todas las rutas redirigen a `index.html`
- Compatible con Flutter Web routing

## 📱 Características del Despliegue

### ✅ **Optimizaciones Automáticas**
- **Compresión**: Gzip automático
- **CDN**: Distribución global
- **HTTPS**: SSL automático
- **Cache**: Headers optimizados

### ✅ **Monitoreo**
- **Analytics**: Integrado automáticamente
- **Logs**: Accesibles desde Vercel Dashboard
- **Performance**: Métricas automáticas

### ✅ **Escalabilidad**
- **Auto-scaling**: Basado en tráfico
- **Edge Functions**: Disponibles si las necesitas
- **Global CDN**: 200+ ubicaciones

## 🔍 Troubleshooting

### **Build Fails**
```bash
# Verificar Flutter
flutter doctor
flutter clean
flutter pub get

# Verificar dependencias
cd faro/app
flutter pub deps
```

### **Runtime Errors**
1. Revisa los logs en Vercel Dashboard
2. Verifica las variables de entorno
3. Asegúrate de que Firebase esté configurado

### **Performance Issues**
1. Optimiza las imágenes
2. Reduce el tamaño del bundle
3. Usa lazy loading donde sea posible

## 🌐 URLs de Despliegue

### **Producción**
```
https://sistema-faro.vercel.app
```

### **Preview (por branch)**
```
https://sistema-faro-git-[branch]-tu-usuario.vercel.app
```

## 📊 Monitoreo

### **Vercel Analytics**
- Visitas y páginas vistas
- Performance metrics
- Error tracking

### **Logs**
- Build logs
- Runtime logs
- Function logs

## 🔄 CI/CD

### **Automatic Deployments**
- **Push a main**: Deploy a producción
- **Pull Request**: Deploy de preview
- **Branch**: Deploy automático

### **Manual Deploy**
```bash
# Desde Vercel CLI
vercel --prod
```

## 🎯 Próximos Pasos

1. **Configurar dominio personalizado** (opcional)
2. **Configurar Firebase** para persistencia de datos
3. **Agregar analytics** (Google Analytics, etc.)
4. **Configurar monitoreo** de errores

## 📞 Soporte

- **Vercel Docs**: [vercel.com/docs](https://vercel.com/docs)
- **Flutter Web**: [flutter.dev/web](https://flutter.dev/web)
- **Issues**: GitHub repository

---

**¡Tu Sistema Faro estará listo para producción en minutos!** 🚀✨
