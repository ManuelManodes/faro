# Sistema de Grillas Figma para Flutter

## ¿Qué hemos implementado?

He creado un sistema completo de grillas de 12 columnas basado en las mejores prácticas de Figma para tu proyecto Flutter **Faro**. Ahora todo el contenido debajo del navbar está centrado y organizado en un sistema de grillas responsive.

## 📋 Componentes del Sistema

### 1. `FigmaGridSystem`
La clase base que define:
- **12 columnas** (estándar de Figma)
- **Gutters de 16px** (espaciado entre columnas)
- **Ancho máximo de 1200px** (para pantallas grandes)
- **Breakpoints responsive**:
  - Mobile: < 768px
  - Tablet: 768px - 1024px  
  - Desktop: > 1024px

### 2. `FigmaGridContainer`
Contenedor principal que:
- ✅ **Centra el contenido**
- ✅ **Aplica márgenes automáticos**
- ✅ **Respeta el ancho máximo**
- ✅ **Se adapta a diferentes pantallas**

### 3. `FigmaRow` y `FigmaColumn`
Widgets para crear layouts:
```dart
FigmaRow(
  children: [
    FigmaColumn(
      columns: 8,           // En desktop
      mobileColumns: 12,    // En mobile
      tabletColumns: 10,    // En tablet
      child: MiWidget(),
    ),
  ],
)
```

## 🔄 Cambios Realizados

### En tu Layout Principal (`app_layout.dart`)
- ✅ El layout base se mantiene igual
- ✅ Header sigue funcionando normalmente

### En `content_container.dart`
- ✅ Ahora usa `FigmaGridContainer`
- ✅ Todo el contenido está centrado
- ✅ Respeta los márgenes de la grilla

### En `view_header_widget.dart`
- ✅ Los títulos de vista usan la grilla
- ✅ Están centrados y alineados con el contenido

### En `main.dart` y `demo_main.dart`
- ✅ Ejemplos de cómo usar el sistema
- ✅ Layouts responsive demostrados

## 🎯 Cómo Usar el Sistema

### Ejemplo Básico
```dart
// En cualquier vista bajo el navbar
FigmaRow(
  children: [
    FigmaColumn(
      columns: 12,        // Ocupa toda la fila
      child: Text('Título'),
    ),
  ],
)
```

### Ejemplo de 2 Columnas
```dart
FigmaRow(
  children: [
    FigmaColumn(
      columns: 6,         // Mitad en desktop
      mobileColumns: 12,  // Completa en mobile
      child: Card1(),
    ),
    FigmaColumn(
      columns: 6,         // Mitad en desktop  
      mobileColumns: 12,  // Completa en mobile
      child: Card2(),
    ),
  ],
)
```

### Ejemplo Centrado
```dart
FigmaRow(
  children: [
    FigmaColumn(
      columns: 8,         // 8 de 12 columnas
      mobileColumns: 12,  // Completa en mobile
      child: ContenidoPrincipal(),
    ),
  ],
)
```

## 📱 Responsive Design

El sistema automáticamente:
- **En Mobile** (< 768px): Márgenes de 16px
- **En Tablet** (768px - 1024px): Márgenes de 32px
- **En Desktop** (> 1024px): Márgenes de 48px, máximo 1200px centrado

## 🎨 Integración con tu Tema

El sistema se integra perfectamente con:
- ✅ `AppSpacing` - Para espaciado vertical
- ✅ `AppColors` - Para colores
- ✅ `AppBorderRadius` - Para bordes
- ✅ Todos tus widgets existentes

## 🚀 Próximos Pasos

1. **Prueba la aplicación** - Ejecuta `flutter run -d chrome` y redimensiona la ventana
2. **Usa en tus vistas** - Reemplaza los layouts existentes con el sistema de grillas
3. **Personaliza** - Ajusta breakpoints y tamaños según tus necesidades de Figma

## 📖 Referencia Rápida

### Tamaños de Columna Comunes
- `columns: 12` - Ancho completo
- `columns: 8` - Contenido principal centrado
- `columns: 6` - Mitad del ancho  
- `columns: 4` - Un tercio del ancho
- `columns: 3` - Un cuarto del ancho

### Breakpoints Responsive
```dart
FigmaColumn(
  columns: 8,         // Desktop
  tabletColumns: 10,  // Tablet
  mobileColumns: 12,  // Mobile
  child: widget,
)
```

¡Ahora tu aplicación **Faro** tiene un sistema de grillas profesional que replica exactamente los estándares de Figma! 🎉
