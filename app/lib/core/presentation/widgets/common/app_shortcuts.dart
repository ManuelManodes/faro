import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Singleton para manejar el modal de navegación globalmente
class SearchFocusManager {
  static final SearchFocusManager _instance = SearchFocusManager._internal();
  factory SearchFocusManager() => _instance;
  SearchFocusManager._internal();

  VoidCallback? _showNavigationModal;

  /// Registra el callback para mostrar el modal de navegación
  void registerNavigationModal(VoidCallback callback) {
    // 🔍 Registrando modal de navegación
    _showNavigationModal = callback;
  }

  /// Desregistra el callback del modal de navegación
  void unregisterNavigationModal() {
    // 🔍 Desregistrando modal de navegación
    _showNavigationModal = null;
  }

  /// Muestra el modal de navegación
  void showNavigationModal() {
    // 🔍 Mostrando modal de navegación
    _showNavigationModal?.call();
  }

  /// Verifica si hay un modal de navegación registrado
  bool get hasNavigationModal => _showNavigationModal != null;
}

/// Widget que envuelve la aplicación con shortcuts de teclado
class AppShortcuts extends StatelessWidget {
  final Widget child;

  const AppShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Detectar la plataforma para usar el shortcut correcto
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        // Shortcut para macOS (Command + B)
        if (isMacOS)
          const SingleActivator(
            LogicalKeyboardKey.keyB,
            control: false,
            alt: false,
            shift: false,
            meta: true,
          ): () {
            // 🔍 Callback shortcut Cmd+B activado!
            SearchFocusManager().showNavigationModal();
          },
        // Shortcut para Windows/Linux (Ctrl + B)
        if (!isMacOS)
          const SingleActivator(
            LogicalKeyboardKey.keyB,
            control: true,
            alt: false,
            shift: false,
            meta: false,
          ): () {
            // 🔍 Callback shortcut Ctrl+B activado!
            SearchFocusManager().showNavigationModal();
          },
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
