import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Singleton para manejar el dropdown de navegación globalmente
class SearchFocusManager {
  static final SearchFocusManager _instance = SearchFocusManager._internal();
  factory SearchFocusManager() => _instance;
  SearchFocusManager._internal();

  VoidCallback? _showNavigationDropdown;

  /// Registra el callback para mostrar el dropdown de navegación
  void registerNavigationDropdown(VoidCallback callback) {
    print('🔍 Registrando dropdown de navegación');
    _showNavigationDropdown = callback;
  }

  /// Desregistra el callback del dropdown de navegación
  void unregisterNavigationDropdown() {
    print('🔍 Desregistrando dropdown de navegación');
    _showNavigationDropdown = null;
  }

  /// Muestra el dropdown de navegación
  void showNavigationDropdown() {
    print('🔍 Mostrando dropdown de navegación');
    _showNavigationDropdown?.call();
  }

  /// Verifica si hay un dropdown de navegación registrado
  bool get hasNavigationDropdown => _showNavigationDropdown != null;
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
          SearchFocusManager().showNavigationDropdown();
        },
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
