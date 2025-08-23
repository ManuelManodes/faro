import '../../domain/entities/menu_option.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  @override
  Future<List<MenuOption>> getMainMenuOptions() async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      MenuOption(
        id: 'dashboard',
        title: 'Panel Principal',
        description: 'Vista general del sistema y estadísticas principales',
        icon: 'dashboard',
        route: '/dashboard',
      ),
      MenuOption(
        id: 'attendance',
        title: 'Control de Asistencia',
        description: 'Gestionar asistencia y control de personal',
        icon: 'people',
        route: '/attendance',
      ),
      MenuOption(
        id: 'agenda',
        title: 'Agenda',
        description: 'Calendario y programación de actividades',
        icon: 'event',
        route: '/agenda',
      ),
      MenuOption(
        id: 'evaluations',
        title: 'Evaluaciones',
        description: 'Sistema de evaluaciones y calificaciones',
        icon: 'assessment',
        route: '/evaluations',
      ),
      MenuOption(
        id: 'reports',
        title: 'Reportes de Incidencias',
        description: 'Generar y consultar reportes de incidencias',
        icon: 'report',
        route: '/reports',
      ),
      MenuOption(
        id: 'assistant',
        title: 'Asistente Virtual',
        description: 'Chatbot y asistencia inteligente',
        icon: 'smart_toy',
        route: '/assistant',
      ),
      MenuOption(
        id: 'organization',
        title: 'Estructura Organizacional',
        description: 'Organigrama y estructura de la empresa',
        icon: 'account_tree',
        route: '/organization',
      ),
    ];
  }

  @override
  Future<MenuOption?> getMenuOptionById(String id) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 200));

    final options = await getMainMenuOptions();
    try {
      return options.firstWhere((option) => option.id == id);
    } catch (e) {
      return null;
    }
  }
}
