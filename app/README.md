# faro (Flutter)

Proyecto Flutter creado con `flutter create` dentro de este repositorio.

Archivos relevantes:
- `lib/main.dart` — entrada de la aplicación.

Cómo ejecutar (desde la raíz del proyecto `app/`):

```bash
# abrir el directorio del app
cd app

# ejecutar en macOS desktop
flutter run -d macos

# ejecutar en el navegador (Chrome)
flutter run -d chrome

# ejecutar en el dispositivo conectado o emulador Android/iOS
flutter run
```

Estado del entorno (resumen de `flutter doctor`):
- Flutter: instalado (stable)
- Dispositivos disponibles: macOS, Chrome
- Android toolchain: falla parcial (no se pudo determinar la versión de Java)
- Xcode: instalación incompleta (necesaria para iOS/macOS completos)
- Android Studio: no instalado

Siguientes pasos recomendados si quieres compilar para Android/iOS:
- Instalar/actualizar JDK (asegúrate que `java -version` funcione)
- Instalar Android Studio y configurar un emulador o SDK
- Instalar Xcode desde App Store y ejecutar los pasos indicados por `flutter doctor`
- Actualizar CocoaPods si vas a compilar para iOS/macOS (ver https://guides.cocoapods.org)

Si quieres, puedo también:
- Añadir un ejemplo de pantalla inicial o paquetes comunes.
- Configurar CI para builds automáticos.
# faro

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
