import 'package:provider/provider.dart';

// Application
import '../../application/services/user_service.dart';
// Domain
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
// Presentation
import '../../presentation/controllers/user_controller.dart';
import '../../presentation/widgets/common/theme_provider.dart';
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
    ];
  }

  static List<Provider> getSimpleProviders() {
    return [
      // Repositories
      Provider<UserRepository>(create: (_) => UserRepositoryImpl()),

      // Use Cases
      Provider<GetUserUseCase>(
        create: (context) => GetUserUseCase(context.read<UserRepository>()),
      ),
      Provider<GetAllUsersUseCase>(
        create: (context) => GetAllUsersUseCase(context.read<UserRepository>()),
      ),

      // Services
      Provider<UserService>(
        create: (context) => UserService(
          getUserUseCase: context.read<GetUserUseCase>(),
          getAllUsersUseCase: context.read<GetAllUsersUseCase>(),
        ),
      ),
    ];
  }
}
