import 'package:flutter/foundation.dart';

import '../../application/services/user_service.dart';
import '../../domain/entities/user.dart';

class UserController extends ChangeNotifier {
  final UserService _userService;

  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = false;
  String? _error;

  UserController(this._userService);

  // Getters
  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga todos los usuarios
  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();

    try {
      _users = await _userService.getAllUsers();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar usuarios: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga un usuario específico por ID
  Future<void> loadUserById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedUser = await _userService.getUserById(id);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar usuario: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Selecciona un usuario
  void selectUser(User user) {
    _selectedUser = user;
    notifyListeners();
  }

  /// Limpia la selección de usuario
  void clearSelection() {
    _selectedUser = null;
    notifyListeners();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

