import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Singleton para manejar el enfoque del campo de búsqueda globalmente
class SearchFocusManager {
  static final SearchFocusManager _instance = SearchFocusManager._internal();
  factory SearchFocusManager() => _instance;
  SearchFocusManager._internal();

  FocusNode? _searchFocusNode;

  /// Registra un FocusNode de campo de búsqueda
  void registerSearchField(FocusNode focusNode) {
    print('🔍 Registrando campo de búsqueda');
    _searchFocusNode = focusNode;
  }

  /// Desregistra el FocusNode actual
  void unregisterSearchField() {
    print('🔍 Desregistrando campo de búsqueda');
    _searchFocusNode = null;
  }

  /// Enfoca el campo de búsqueda actual si existe
  void focusSearchField() {
    print('🔍 Intentando enfocar campo: $_searchFocusNode');
    if (_searchFocusNode != null) {
      print(
        '🔍 FocusNode existe, canRequestFocus: ${_searchFocusNode!.canRequestFocus}',
      );
      if (_searchFocusNode!.canRequestFocus) {
        _searchFocusNode!.requestFocus();
        print('🔍 Focus solicitado');
      } else {
        print('🔍 No se puede solicitar focus');
      }
    } else {
      print('🔍 No hay FocusNode registrado');
    }
  }

  /// Verifica si hay un campo de búsqueda registrado
  bool get hasSearchField => _searchFocusNode != null;
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
          SearchFocusManager().focusSearchField();
        },
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}

/// Intent para enfocar el campo de búsqueda
class FocusSearchIntent extends Intent {
  const FocusSearchIntent();
}

/// Acción que enfoca el campo de búsqueda
class FocusSearchAction extends Action<FocusSearchIntent> {
  @override
  Object? invoke(FocusSearchIntent intent) {
    print('🔍 Shortcut B presionado - intentando enfocar campo de búsqueda');
    final manager = SearchFocusManager();
    print('🔍 Campo de búsqueda registrado: ${manager.hasSearchField}');
    manager.focusSearchField();
    return null;
  }
}

/// Mixin para widgets que contienen campos de búsqueda
mixin SearchFieldMixin<T extends StatefulWidget> on State<T> {
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    print('🔍 SearchFieldMixin: initState llamado');
    // Registrar inmediatamente
    SearchFocusManager().registerSearchField(searchFocusNode);
  }

  @override
  void dispose() {
    print('🔍 SearchFieldMixin: dispose llamado');
    SearchFocusManager().unregisterSearchField();
    searchFocusNode.dispose();
    super.dispose();
  }
}

/// Widget que muestra el indicador de shortcut "B" para el campo de búsqueda
class SearchShortcutIndicator extends StatelessWidget {
  const SearchShortcutIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'B',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
