import '../../domain/entities/menu_option.dart';
import '../../domain/usecases/get_menu_options_usecase.dart';

class MenuService {
  final GetMenuOptionsUseCase _getMenuOptionsUseCase;

  const MenuService({required GetMenuOptionsUseCase getMenuOptionsUseCase})
    : _getMenuOptionsUseCase = getMenuOptionsUseCase;

  /// Obtiene todas las opciones del menú principal
  Future<List<MenuOption>> getMainMenuOptions() async {
    return await _getMenuOptionsUseCase.execute();
  }
}
