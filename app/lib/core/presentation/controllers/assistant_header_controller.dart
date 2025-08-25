import 'package:flutter/foundation.dart';

/// Controlador para manejar el estado del header del asistente virtual
class AssistantHeaderController extends ChangeNotifier {
  String _selectedDocument = 'Seleccionar documento';
  String _selectedModel = 'GPT-4';
  bool _isLoading = false;

  // Getters
  String get selectedDocument => _selectedDocument;
  String get selectedModel => _selectedModel;
  bool get isLoading => _isLoading;

  // Documentos disponibles (simulados)
  static const List<String> availableDocuments = [
    'Manual de Usuario.pdf',
    'Políticas de la Empresa.pdf',
    'Procedimientos Operativos.pdf',
    'Guía de Seguridad.pdf',
    'Reglamento Interno.pdf',
  ];

  // Modelos de IA disponibles
  static const List<String> availableModels = [
    'GPT-4',
    'GPT-3.5',
    'Claude-3',
    'Gemini Pro',
  ];

  /// Establece el documento seleccionado
  void setDocument(String document) {
    _selectedDocument = document;
    notifyListeners();
  }

  /// Establece el modelo de IA seleccionado
  void setModel(String model) {
    _selectedModel = model;
    notifyListeners();
  }

  /// Establece el estado de carga
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Verifica si hay un documento seleccionado
  bool get hasDocumentSelected => _selectedDocument != 'Seleccionar documento';

  /// Obtiene el nombre del documento sin la extensión
  String get documentName {
    if (!hasDocumentSelected) return '';
    return _selectedDocument.replaceAll('.pdf', '');
  }
}
