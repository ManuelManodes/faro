import 'package:provider/provider.dart';

// Application
import '../../application/services/menu_service.dart';
// Application
import '../../application/services/user_service.dart';
import '../../domain/repositories/menu_repository.dart';
// Domain
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_menu_options_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../presentation/controllers/assistant_chat_controller.dart';
import '../../presentation/controllers/assistant_header_controller.dart';
import '../../presentation/controllers/attendance_header_controller.dart';
import '../../presentation/controllers/attendance_list_controller.dart';
import '../../presentation/controllers/menu_controller.dart';
// Presentation
import '../../presentation/controllers/user_controller.dart';
import '../../presentation/widgets/common/theme_provider.dart';
import '../repositories/menu_repository_impl.dart';
// Infrastructure
import '../repositories/user_repository_impl.dart';

class DependencyInjection {
  static List<ChangeNotifierProvider> getProviders() {
    return [
      // Theme Provider
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),

      // Controllers
      ChangeNotifierProvider<UserController>(
        create: (context) => UserController(context.read<UserService>()),
      ),
      ChangeNotifierProvider<MainMenuController>(
        create: (context) => MainMenuController(context.read<MenuService>()),
      ),
      ChangeNotifierProvider<AttendanceHeaderController>(
        create: (context) => AttendanceHeaderController(),
      ),
      ChangeNotifierProvider<AttendanceListController>(
        create: (context) => AttendanceListController(),
      ),
      ChangeNotifierProvider<AssistantHeaderController>(
        create: (context) => AssistantHeaderController(),
      ),
      ChangeNotifierProvider<AssistantChatController>(
        create: (context) => AssistantChatController(),
      ),
    ];
  }

  static List<Provider> getSimpleProviders() {
    return [
      // Repositories
      Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
      Provider<MenuRepository>(create: (_) => MenuRepositoryImpl()),

      // Use Cases
      Provider<GetUserUseCase>(
        create: (context) => GetUserUseCase(context.read<UserRepository>()),
      ),
      Provider<GetAllUsersUseCase>(
        create: (context) => GetAllUsersUseCase(context.read<UserRepository>()),
      ),
      Provider<GetMenuOptionsUseCase>(
        create: (context) =>
            GetMenuOptionsUseCase(context.read<MenuRepository>()),
      ),

      // Services
      Provider<UserService>(
        create: (context) => UserService(
          getUserUseCase: context.read<GetUserUseCase>(),
          getAllUsersUseCase: context.read<GetAllUsersUseCase>(),
        ),
      ),
      Provider<MenuService>(
        create: (context) => MenuService(
          getMenuOptionsUseCase: context.read<GetMenuOptionsUseCase>(),
        ),
      ),
    ];
  }
}
