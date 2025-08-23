import '../entities/menu_option.dart';

abstract class MenuRepository {
  /// Obtiene todas las opciones del menú principal
  Future<List<MenuOption>> getMainMenuOptions();

  /// Obtiene una opción específica por su ID
  Future<MenuOption?> getMenuOptionById(String id);
}
