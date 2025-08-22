import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // Aquí se implementaría la lógica real de acceso a datos
  // Por ahora usamos datos de ejemplo

  @override
  Future<User?> getUserById(String id) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    // Datos de ejemplo
    if (id == '1') {
      return User(
        id: '1',
        name: 'Juan Pérez',
        email: 'juan@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    return null;
  }

  @override
  Future<List<User>> getAllUsers() async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Datos de ejemplo
    final now = DateTime.now();
    return [
      User(
        id: '1',
        name: 'Juan Pérez',
        email: 'juan@example.com',
        createdAt: now,
        updatedAt: now,
      ),
      User(
        id: '2',
        name: 'María García',
        email: 'maria@example.com',
        createdAt: now,
        updatedAt: now,
      ),
      User(
        id: '3',
        name: 'Carlos López',
        email: 'carlos@example.com',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  @override
  Future<User> createUser(User user) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 600));

    // En una implementación real, aquí se guardaría en la base de datos
    return user.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<User> updateUser(User user) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 400));

    // En una implementación real, aquí se actualizaría en la base de datos
    return user.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<bool> deleteUser(String id) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 300));

    // En una implementación real, aquí se eliminaría de la base de datos
    return true;
  }

  @override
  Future<List<User>> searchUsersByName(String name) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 400));

    final allUsers = await getAllUsers();
    return allUsers
        .where((user) => user.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }
}
