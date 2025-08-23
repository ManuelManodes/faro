import '../entities/menu_option.dart';
import '../repositories/menu_repository.dart';

class GetMenuOptionsUseCase {
  final MenuRepository _menuRepository;

  const GetMenuOptionsUseCase(this._menuRepository);

  /// Obtiene todas las opciones del menú principal
  Future<List<MenuOption>> execute() async {
    try {
      return await _menuRepository.getMainMenuOptions();
    } catch (e) {
      throw Exception('Error al obtener opciones del menú: $e');
    }
  }
}
