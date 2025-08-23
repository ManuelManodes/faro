import 'package:flutter/foundation.dart';

import '../../domain/entities/student.dart';

/// Controlador para manejar la lista de estudiantes y las ausencias
class AttendanceListController extends ChangeNotifier {
  List<Student> _students = [];
  final Set<String> _absentStudentIds = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Student> get students => _students;
  Set<String> get absentStudentIds => _absentStudentIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Métodos para manejar ausencias
  void toggleAbsence(String studentId) {
    if (_absentStudentIds.contains(studentId)) {
      _absentStudentIds.remove(studentId);
    } else {
      _absentStudentIds.add(studentId);
    }
    notifyListeners();
  }

  bool isAbsent(String studentId) {
    return _absentStudentIds.contains(studentId);
  }

  void clearAbsences() {
    _absentStudentIds.clear();
    notifyListeners();
  }

  // Métodos para cargar estudiantes (mock data por ahora)
  Future<void> loadStudents(String level, String course) async {
    _setLoading(true);
    _clearError();

    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));

      // Generar datos mock
      _students = _generateMockStudents(level, course);
      _absentStudentIds.clear();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar estudiantes: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<Student> _generateMockStudents(String level, String course) {
    final mockNames = [
      'Ana García',
      'Carlos Rodríguez',
      'María López',
      'Juan Pérez',
      'Sofía Martínez',
      'Diego Silva',
      'Valentina Torres',
      'Andrés Morales',
      'Camila Herrera',
      'Felipe Vargas',
      'Isabella Castro',
      'Matías Rojas',
      'Antonella Díaz',
      'Sebastián Muñoz',
      'Javiera Soto',
    ];

    return List.generate(mockNames.length, (index) {
      final nameParts = mockNames[index].split(' ');
      return Student(
        id: 'student_${level}_${course}_$index',
        firstName: nameParts[0],
        lastName: nameParts[1],
        fullName: mockNames[index],
        level: level,
        course: course,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
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
