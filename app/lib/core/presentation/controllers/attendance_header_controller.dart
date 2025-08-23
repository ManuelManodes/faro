import 'package:flutter/foundation.dart';

/// Controlador para manejar el estado de los selectores en el header de asistencia
class AttendanceHeaderController extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String _selectedLevel = '1ero Básico';
  String _selectedCourse = 'A';

  // Getters
  DateTime get selectedDate => _selectedDate;
  String get selectedLevel => _selectedLevel;
  String get selectedCourse => _selectedCourse;

  // Lista de niveles escolares disponibles
  static const List<String> availableLevels = [
    '1ero Básico',
    '2do Básico',
    '3ero Básico',
    '4to Básico',
    '5to Básico',
    '6to Básico',
    '7mo Básico',
    '8vo Básico',
    '1ero Medio',
    '2do Medio',
    '3ero Medio',
    '4to Medio',
  ];

  // Lista de cursos disponibles
  static const List<String> availableCourses = ['A', 'B', 'C', 'D', 'E', 'F'];

  // Métodos para actualizar los valores
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  void setCourse(String course) {
    _selectedCourse = course;
    notifyListeners();
  }

  // Método para obtener la fecha formateada
  String getFormattedDate() {
    final day = _selectedDate.day.toString().padLeft(2, '0');
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final year = _selectedDate.year.toString();
    return '$day/$month/$year';
  }
}
