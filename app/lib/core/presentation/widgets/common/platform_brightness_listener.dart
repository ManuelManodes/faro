import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

/// Widget que escucha los cambios del brillo de la plataforma
/// y actualiza el ThemeProvider automáticamente
class PlatformBrightnessListener extends StatefulWidget {
  final Widget child;

  const PlatformBrightnessListener({super.key, required this.child});

  @override
  State<PlatformBrightnessListener> createState() =>
      _PlatformBrightnessListenerState();
}

class _PlatformBrightnessListenerState extends State<PlatformBrightnessListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inicializar con el brillo actual del sistema
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final brightness = MediaQuery.of(context).platformBrightness;
        context.read<ThemeProvider>().updatePlatformBrightness(brightness);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Actualiza el brillo de la plataforma cuando cambie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final brightness = MediaQuery.of(context).platformBrightness;
        context.read<ThemeProvider>().updatePlatformBrightness(brightness);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
