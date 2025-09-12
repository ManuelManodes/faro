import 'package:flutter/material.dart';
import '../../domain/entities/holland_test.dart';

/// Controlador para el Test de Holland
class HollandTestController extends ChangeNotifier {
  HollandTest? _currentTest;
  String _studentName = '';
  String _studentId = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  HollandTest? get currentTest => _currentTest;
  String get studentName => _studentName;
  String get studentId => _studentId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasTest => _currentTest != null;
  double get progress => _currentTest?.progress ?? 0.0;
  int get completionPercentage => _currentTest?.completionPercentage ?? 0;
  bool get isComplete => _currentTest?.isComplete ?? false;

  /// Inicia un nuevo test
  void startTest(String studentName, String studentId) {
    _studentName = studentName;
    _studentId = studentId;
    _currentTest = HollandTest.create(
      studentId: studentId,
      studentName: studentName,
    );
    _error = null;
    notifyListeners();
  }

  /// Actualiza una respuesta del test
  void updateAnswer(String questionId, int answerIndex) {
    if (_currentTest == null) return;

    _currentTest = _currentTest!.updateAnswer(questionId, answerIndex);
    notifyListeners();
  }

  /// Completa el test y calcula el resultado
  void completeTest() {
    if (_currentTest == null || !_currentTest!.isComplete) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simular procesamiento
      Future.delayed(const Duration(seconds: 1), () {
        _currentTest = _currentTest!.complete().calculateResult();
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _error = 'Error al completar el test: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reinicia el test
  void resetTest() {
    _currentTest = null;
    _studentName = '';
    _studentId = '';
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Obtiene la respuesta para una pregunta específica
  int? getAnswer(String questionId) {
    return _currentTest?.answers[questionId];
  }

  /// Verifica si una pregunta tiene respuesta
  bool hasAnswer(String questionId) {
    return _currentTest?.answers.containsKey(questionId) ?? false;
  }

  /// Obtiene el número de preguntas respondidas
  int get answeredQuestions {
    return _currentTest?.answers.length ?? 0;
  }

  /// Obtiene el total de preguntas
  int get totalQuestions {
    return HollandTestData.totalQuestions;
  }

  /// Obtiene el resultado del test
  HollandTestResult? get result {
    return _currentTest?.result;
  }

  /// Verifica si el test está completado
  bool get isTestCompleted {
    return _currentTest?.status == HollandTestStatus.completed;
  }

  /// Obtiene el tipo primario del resultado
  HollandType? get primaryType {
    return _currentTest?.result?.primaryType;
  }

  /// Obtiene el tipo secundario del resultado
  HollandType? get secondaryType {
    return _currentTest?.result?.secondaryType;
  }

  /// Obtiene las sugerencias de carrera
  List<String> get careerSuggestions {
    return _currentTest?.result?.careerSuggestions ?? [];
  }

  /// Obtiene los rasgos de personalidad
  List<String> get personalityTraits {
    return _currentTest?.result?.personalityTraits ?? [];
  }

  /// Obtiene la interpretación del resultado
  String get interpretation {
    return _currentTest?.result?.interpretation ?? '';
  }

  /// Obtiene los scores por tipo
  Map<HollandType, int> get scores {
    return _currentTest?.result?.scores ?? {};
  }

  /// Exporta el resultado del test
  Map<String, dynamic> exportResult() {
    if (_currentTest == null || _currentTest!.result == null) {
      return {};
    }

    return {
      'studentName': _studentName,
      'studentId': _studentId,
      'testDate': _currentTest!.testDate.toIso8601String(),
      'completedDate': _currentTest!.completedDate.toIso8601String(),
      'primaryType': _currentTest!.result!.primaryType.name,
      'secondaryType': _currentTest!.result!.secondaryType.name,
      'tertiaryType': _currentTest!.result!.tertiaryType.name,
      'scores': _currentTest!.result!.scores.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'interpretation': _currentTest!.result!.interpretation,
      'careerSuggestions': _currentTest!.result!.careerSuggestions,
      'personalityTraits': _currentTest!.result!.personalityTraits,
    };
  }

  /// Valida que el test esté completo
  bool validateTest() {
    if (_currentTest == null) return false;
    return _currentTest!.isComplete;
  }

  /// Obtiene estadísticas del test
  Map<String, dynamic> getTestStatistics() {
    if (_currentTest == null) return {};

    return {
      'totalQuestions': totalQuestions,
      'answeredQuestions': answeredQuestions,
      'completionPercentage': completionPercentage,
      'isComplete': isComplete,
      'testDuration': _currentTest!.completedDate
          .difference(_currentTest!.testDate)
          .inMinutes,
    };
  }
}
