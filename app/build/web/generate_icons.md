# Generación de Iconos para el Sistema de Gestión Faro

## Iconos Necesarios

### Favicon
- **favicon.svg** - Icono vectorial principal (ya creado)
- **favicon.png** - Versión PNG del favicon

### Iconos PWA
- **Icon-192.png** - 192x192 pixels
- **Icon-512.png** - 512x512 pixels
- **Icon-maskable-192.png** - 192x192 pixels (maskable)
- **Icon-maskable-512.png** - 512x512 pixels (maskable)

## Diseño del Icono

### Elementos del Icono:
1. **Fondo negro** (#000000) - Fondo contrastante
2. **Faro naranja** (#FF8C00) - Símbolo principal del sistema
3. **Ventanas y puerta negras** - Detalles arquitectónicos
4. **Haces de luz naranjas** - Simbolizan guía y dirección

### Colores Utilizados:
- **Naranja del faro**: #FF8C00 (Dark Orange)
- **Fondo negro**: #000000
- **Detalles negros**: #000000

## Generación de Iconos

### Opción 1: Herramientas Online
1. **Favicon.io** - https://favicon.io/
2. **RealFaviconGenerator** - https://realfavicongenerator.net/
3. **Favicon Generator** - https://www.favicon-generator.org/

### Opción 2: Software de Diseño
1. **Figma** - Diseño vectorial
2. **Adobe Illustrator** - Diseño profesional
3. **Inkscape** - Software gratuito

### Opción 3: Comando de Línea
```bash
# Usando ImageMagick (si está instalado)
convert favicon.svg -resize 192x192 Icon-192.png
convert favicon.svg -resize 512x512 Icon-512.png
```

## Implementación

### Archivos a Actualizar:
1. **web/index.html** - Referencias a favicon
2. **web/manifest.json** - Configuración PWA
3. **web/icons/** - Carpeta con iconos PNG

### Verificación:
1. Limpiar caché del navegador
2. Verificar que el favicon aparece en la pestaña
3. Probar instalación como PWA
4. Verificar iconos en diferentes dispositivos

## Notas Importantes

- Los iconos maskable deben tener padding suficiente para ser recortados
- El favicon SVG es escalable y se ve nítido en cualquier tamaño
- Los iconos PNG son necesarios para compatibilidad con navegadores antiguos
- El color naranja (#FF8C00) debe coincidir con el tema de la aplicación
