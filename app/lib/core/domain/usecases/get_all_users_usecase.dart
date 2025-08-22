import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetAllUsersUseCase {
  final UserRepository _userRepository;

  const GetAllUsersUseCase(this._userRepository);

  /// Obtiene todos los usuarios
  Future<List<User>> execute() async {
    try {
      return await _userRepository.getAllUsers();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }
}
