import '../../domain/entities/user.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';

class UserService {
  final GetUserUseCase _getUserUseCase;
  final GetAllUsersUseCase _getAllUsersUseCase;

  const UserService({
    required GetUserUseCase getUserUseCase,
    required GetAllUsersUseCase getAllUsersUseCase,
  }) : _getUserUseCase = getUserUseCase,
       _getAllUsersUseCase = getAllUsersUseCase;

  /// Obtiene un usuario por su ID
  Future<User?> getUserById(String id) async {
    return await _getUserUseCase.execute(id);
  }

  /// Obtiene todos los usuarios
  Future<List<User>> getAllUsers() async {
    return await _getAllUsersUseCase.execute();
  }
}

