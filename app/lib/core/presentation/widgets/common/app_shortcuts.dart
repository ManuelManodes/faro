import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Singleton para manejar el modal de navegación globalmente
class SearchFocusManager {
  static final SearchFocusManager _instance = SearchFocusManager._internal();
  factory SearchFocusManager() => _instance;
  SearchFocusManager._internal();

  VoidCallback? _showNavigationModal;

  /// Registra el callback para mostrar el modal de navegación
  void registerNavigationModal(VoidCallback callback) {
    print('🔍 Registrando modal de navegación');
    _showNavigationModal = callback;
  }

  /// Desregistra el callback del modal de navegación
  void unregisterNavigationModal() {
    print('🔍 Desregistrando modal de navegación');
    _showNavigationModal = null;
  }

  /// Muestra el modal de navegación
  void showNavigationModal() {
    print('🔍 Mostrando modal de navegación');
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
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyB): () {
          print('🔍 Callback shortcut B activado!');
          SearchFocusManager().showNavigationModal();
        },
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
