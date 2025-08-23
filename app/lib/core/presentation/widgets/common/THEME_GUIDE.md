# Guía de Uso del Sistema Global de Temas

## Sistema de Colores Global

El sistema `AppColors` ahora incluye métodos estáticos para obtener colores según el tema actual, eliminando la necesidad de repetir lógica de colores en cada widget.

## Métodos Disponibles

### Colores de Texto
```dart
// Texto principal (títulos, encabezados)
AppColors.textPrimary(isDarkMode)

// Texto secundario (descripciones, subtítulos)
AppColors.textSecondary(isDarkMode)

// Texto terciario (texto pequeño, notas)
AppColors.textTertiary(isDarkMode)
```

### Colores de Iconos
```dart
// Iconos principales
AppColors.iconPrimary(isDarkMode)

// Iconos secundarios
AppColors.iconSecondary(isDarkMode)
```

### Colores de Fondo
```dart
// Fondo principal de la aplicación
AppColors.backgroundPrimary(isDarkMode)

// Fondo secundario (headers, cards)
AppColors.backgroundSecondary(isDarkMode)

// Superficies (cards, contenedores)
AppColors.surface(isDarkMode)
```

### Colores de Separadores
```dart
// Divisores y bordes
AppColors.dividerTheme(isDarkMode)
```

## Ejemplos de Uso

### En un Widget
```dart
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    final isDarkMode = themeProvider.isDarkMode;
    
    return Text(
      'Mi Título',
      style: TextStyle(
        color: AppColors.textPrimary(isDarkMode),
        fontSize: 16,
      ),
    );
  },
)
```

### En un Icono
```dart
Icon(
  Icons.help_outline,
  color: AppColors.iconPrimary(isDarkMode),
  size: 24,
)
```

### En un Contenedor
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.surface(isDarkMode),
    border: Border.all(
      color: AppColors.dividerTheme(isDarkMode),
    ),
  ),
  child: // contenido
)
```

## Estilos de Contenedor

### Cards con Tema
```dart
Container(
  decoration: AppContainerStyles.cardTheme(isDarkMode),
  child: // contenido
)
```

### Contenedores Outlined con Tema
```dart
Container(
  decoration: AppContainerStyles.outlinedTheme(isDarkMode),
  child: // contenido
)
```

## Beneficios

✅ **Consistencia**: Todos los componentes usan los mismos colores  
✅ **Mantenibilidad**: Cambios centralizados en un solo lugar  
✅ **Legibilidad**: Código más limpio y fácil de entender  
✅ **Escalabilidad**: Fácil agregar nuevos colores o temas  

## Migración

Para migrar widgets existentes:

1. Reemplazar `isDarkMode ? Colors.white : Colors.black87` por `AppColors.textPrimary(isDarkMode)`
2. Reemplazar `isDarkMode ? Colors.white70 : Colors.black54` por `AppColors.textSecondary(isDarkMode)`
3. Reemplazar colores de fondo por los métodos correspondientes
4. Usar `AppContainerStyles` para estilos de contenedor

