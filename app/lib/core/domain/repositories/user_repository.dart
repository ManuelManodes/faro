import '../entities/user.dart';

abstract class UserRepository {
  /// Obtiene un usuario por su ID
  Future<User?> getUserById(String id);

  /// Obtiene todos los usuarios
  Future<List<User>> getAllUsers();

  /// Crea un nuevo usuario
  Future<User> createUser(User user);

  /// Actualiza un usuario existente
  Future<User> updateUser(User user);

  /// Elimina un usuario por su ID
  Future<bool> deleteUser(String id);

  /// Busca usuarios por nombre
  Future<List<User>> searchUsersByName(String name);
}

