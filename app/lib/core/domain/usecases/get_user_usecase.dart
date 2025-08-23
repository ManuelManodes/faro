import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _userRepository;

  const GetUserUseCase(this._userRepository);

  /// Obtiene un usuario por su ID
  Future<User?> execute(String id) async {
    try {
      return await _userRepository.getUserById(id);
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }
}

