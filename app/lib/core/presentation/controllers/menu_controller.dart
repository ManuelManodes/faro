import 'package:flutter/foundation.dart';

import '../../application/services/menu_service.dart';
import '../../domain/entities/menu_option.dart';

class MainMenuController extends ChangeNotifier {
  final MenuService _menuService;

  List<MenuOption> _menuOptions = [];
  MenuOption? _selectedOption;
  bool _isLoading = false;
  String? _error;

  MainMenuController(this._menuService);

  // Getters
  List<MenuOption> get menuOptions => _menuOptions;
  MenuOption? get selectedOption => _selectedOption;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga las opciones del menú principal
  Future<void> loadMenuOptions() async {
    _setLoading(true);
    _clearError();

    try {
      _menuOptions = await _menuService.getMainMenuOptions();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar opciones del menú: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Selecciona una opción del menú
  void selectOption(MenuOption option) {
    _selectedOption = option;
    notifyListeners();
  }

  /// Limpia la selección
  void clearSelection() {
    _selectedOption = null;
    notifyListeners();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
