# 🏛️ Sistema Faro - Documentación Consolidada

## 📋 Resumen del Proyecto

**Sistema Faro** es una aplicación Flutter Web para gestión escolar que implementa arquitectura hexagonal y está desplegada en Vercel. El sistema incluye control de asistencia, asistente virtual, formularios de incidencias y una interfaz moderna y responsive.

## 🏗️ Arquitectura del Proyecto

### **Arquitectura Hexagonal Implementada**
- **Domain Layer**: Entidades, repositorios y casos de uso
- **Application Layer**: Servicios que orquestan la lógica de negocio
- **Infrastructure Layer**: Implementaciones concretas y DI
- **Presentation Layer**: UI, controladores y widgets

### **Estructura de Carpetas**
```
app/lib/core/
├── domain/          # Entidades, repositorios, casos de uso
├── application/     # Servicios de aplicación
├── infrastructure/  # Implementaciones y DI
└── presentation/    # UI, controladores, widgets
```

## 🚀 Despliegue en Vercel

### **Configuración Automática**
- **Build Command**: `cd faro/app && flutter build web --release`
- **Output Directory**: `faro/app/build/web`
- **URL**: https://sistema-faro.vercel.app

### **Características del Despliegue**
- ✅ Compresión Gzip automática
- ✅ CDN global (200+ ubicaciones)
- ✅ HTTPS automático
- ✅ Headers de seguridad configurados
- ✅ CI/CD automático con GitHub

## 🎯 Funcionalidades Principales

### **1. Control de Asistencia**
- Selector de fecha, año académico y curso
- Tabla de estudiantes con marcado de ausencias
- Navegación por teclado (flechas, Enter, Espacio)
- Persistencia de datos de asistencia

### **2. Asistente Virtual**
- Chat interactivo con sesiones
- Sidebar de conversaciones
- Historial de mensajes
- Interfaz moderna y responsive

### **3. Formularios de Incidencias**
- Formulario integrado en navbar
- Validación de campos
- Envío de datos
- Feedback visual con SnackBars

### **4. Sistema de Navegación**
- Navbar con múltiples vistas
- Shortcuts de teclado (B para búsqueda)
- Navegación por teclado completa
- Indicadores visuales de shortcuts

## 🎨 Características de UI/UX

### **Diseño Responsive**
- Adaptable a diferentes tamaños de pantalla
- Grid system basado en Figma
- Layout flexible y moderno

### **Tema y Estilos**
- Tema claro/oscuro automático
- Colores consistentes
- Componentes reutilizables
- Efectos visuales y animaciones

### **Accesibilidad**
- Navegación completa por teclado
- Shortcuts intuitivos
- Indicadores visuales claros
- Soporte para lectores de pantalla

## ⌨️ Shortcuts de Teclado

### **Navegación General**
- **B**: Enfocar campo de búsqueda
- **Flechas**: Navegar por elementos
- **Enter**: Seleccionar/activar
- **Espacio**: Marcar/desmarcar ausencias
- **Tab**: Navegar entre campos

### **Control de Asistencia**
- **Flechas arriba/abajo**: Navegar estudiantes
- **Enter**: Marcar ausencia
- **Espacio**: Marcar ausencia
- **Tab**: Cambiar entre controles

## 🔧 Tecnologías Utilizadas

### **Frontend**
- **Flutter Web**: Framework principal
- **Provider**: Gestión de estado
- **Material Design**: Componentes UI

### **Despliegue**
- **Vercel**: Plataforma de hosting
- **GitHub**: Control de versiones
- **CI/CD**: Despliegue automático

### **Arquitectura**
- **Arquitectura Hexagonal**: Patrón de diseño
- **Dependency Injection**: Inyección de dependencias
- **Clean Architecture**: Principios SOLID

## 📁 Archivos Importantes

### **Configuración**
- `vercel.json`: Configuración de Vercel
- `pubspec.yaml`: Dependencias de Flutter
- `build.sh`: Script de construcción

### **Código Principal**
- `main.dart`: Punto de entrada
- `core.dart`: Exportaciones centralizadas
- `dependency_injection.dart`: Configuración DI

### **Widgets Principales**
- `flexible_dashboard_page.dart`: Página principal
- `attendance_table_widget.dart`: Tabla de asistencia
- `assistant_chat_widget.dart`: Chat del asistente
- `header_widget.dart`: Header de navegación

## 🚀 Comandos de Desarrollo

### **Ejecutar Localmente**
```bash
cd app
flutter pub get
flutter run -d chrome
```

### **Construir para Producción**
```bash
cd app
flutter build web --release
```

### **Desplegar en Vercel**
```bash
git add .
git commit -m "Actualización"
git push origin main
# Vercel se despliega automáticamente
```

## 🔍 Troubleshooting

### **Problemas Comunes**
1. **Build falla**: Verificar dependencias en `pubspec.yaml`
2. **Errores 404**: Verificar configuración de SPA routing en `vercel.json`
3. **Errores 401**: Verificar variables de entorno en Vercel

### **Logs y Debugging**
- Logs de build disponibles en Vercel Dashboard
- Console logs en navegador para debugging
- Analytics integrados en Vercel

## 📈 Estado del Proyecto

### **✅ Completado**
- Arquitectura hexagonal implementada
- Control de asistencia funcional
- Asistente virtual operativo
- Formularios de incidencias
- Despliegue en Vercel
- Navegación por teclado
- UI responsive y moderna

### **🔄 En Desarrollo**
- Mejoras de performance
- Nuevas funcionalidades
- Optimizaciones de UX

### **📋 Próximas Funcionalidades**
- Integración con Firebase
- Autenticación de usuarios
- Reportes y estadísticas
- Notificaciones push

## 📞 Soporte

Para soporte técnico o preguntas sobre el proyecto:
- Revisar logs en Vercel Dashboard
- Consultar documentación de Flutter
- Verificar configuración en archivos de proyecto

---

**Sistema Faro** - Plataforma de Gestión Escolar Moderna 🏛️