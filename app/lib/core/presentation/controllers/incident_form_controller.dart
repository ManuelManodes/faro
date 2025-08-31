import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/incident.dart';

class IncidentFormController extends ChangeNotifier {
  final _uuid = const Uuid();

  // Campos del formulario
  String _title = '';
  String _description = '';
  IncidentType? _type;
  IncidentSeverity? _severity;
  String _studentName = '';
  String _reportedBy = '';
  String _location = '';
  DateTime _incidentDate = DateTime.now();
  final List<String> _witnesses = [];
  String _notes = '';

  // Nuevos campos
  bool _notifyParent = false;
  String _derivateTo = '';
  String _priority = 'Normal';
  String _category = 'General';

  // Estado del formulario
  bool _isLoading = false;
  bool _isValid = false;
  String? _errorMessage;
  bool _showValidationErrors = false;

  // Getters
  String get title => _title;
  String get description => _description;
  IncidentType? get type => _type;
  IncidentSeverity? get severity => _severity;
  String get studentName => _studentName;
  String get reportedBy => _reportedBy;
  String get location => _location;
  DateTime get incidentDate => _incidentDate;
  List<String> get witnesses => _witnesses;
  String get notes => _notes;
  bool get isLoading => _isLoading;
  bool get isValid => _isValid;
  String? get errorMessage => _errorMessage;
  bool get showValidationErrors => _showValidationErrors;

  // Getters para nuevos campos
  bool get notifyParent => _notifyParent;
  String get derivateTo => _derivateTo;
  String get priority => _priority;
  String get category => _category;

  // Listas estáticas para los selectores
  static const List<String> availableLocations = [
    'Aula de Clase',
    'Patio de Recreo',
    'Biblioteca',
    'Laboratorio',
    'Gimnasio',
    'Comedor',
    'Baños',
    'Pasillos',
    'Estacionamiento',
    'Sala de Profesores',
    'Oficina Administrativa',
    'Otro',
  ];

  static const List<String> availableWitnesses = [
    'Estudiante',
    'Profesor',
    'Personal Administrativo',
    'Personal de Limpieza',
    'Seguridad',
    'Padre de Familia',
    'Otro',
  ];

  static const List<String> availablePriorities = [
    'Baja',
    'Normal',
    'Alta',
    'Urgente',
  ];

  static const List<String> availableCategories = [
    'General',
    'Académica',
    'Disciplinaria',
    'Salud',
    'Seguridad',
    'Tecnología',
  ];

  static const List<String> availableDerivations = [
    'No derivar',
    'Psicólogo',
    'Asistente Social',
    'Inspector General',
    'Director',
    'Apoderado',
    'Carabineros',
    'Otro',
  ];

  // Setters sin validación visual inmediata
  void setTitle(String value) {
    _title = value.trim();
    _validateForm();
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value.trim();
    _validateForm();
    notifyListeners();
  }

  void setType(IncidentType? value) {
    _type = value;
    _validateForm();
    notifyListeners();
  }

  void setSeverity(IncidentSeverity? value) {
    _severity = value;
    _validateForm();
    notifyListeners();
  }

  void setStudentName(String value) {
    _studentName = value.trim();
    _validateForm();
    notifyListeners();
  }

  void setReportedBy(String value) {
    _reportedBy = value.trim();
    _validateForm();
    notifyListeners();
  }

  void setLocation(String value) {
    _location = value.trim();
    _validateForm();
    notifyListeners();
  }

  void setIncidentDate(DateTime value) {
    _incidentDate = value;
    _validateForm();
    notifyListeners();
  }

  void addWitness(String witness) {
    if (!_witnesses.contains(witness)) {
      _witnesses.add(witness);
      notifyListeners();
    }
  }

  void removeWitness(String witness) {
    _witnesses.remove(witness);
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value.trim();
    notifyListeners();
  }

  // Setters para nuevos campos
  void setNotifyParent(bool value) {
    _notifyParent = value;
    notifyListeners();
  }

  void setDerivateTo(String value) {
    _derivateTo = value.trim();
    notifyListeners();
  }

  void setPriority(String value) {
    _priority = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  // Validación del formulario
  void _validateForm() {
    _isValid =
        _title.isNotEmpty &&
        _description.isNotEmpty &&
        _type != null &&
        _severity != null &&
        _studentName.isNotEmpty &&
        _reportedBy.isNotEmpty &&
        _location.isNotEmpty &&
        true; // _incidentDate siempre tiene un valor (DateTime.now())

    _errorMessage = null;
  }

  // Crear la incidencia
  Incident? createIncident() {
    if (!_isValid) {
      _errorMessage = 'Por favor completa todos los campos requeridos';
      notifyListeners();
      return null;
    }

    try {
      final incident = Incident(
        id: _uuid.v4(),
        title: _title,
        description: _description,
        type: _type!,
        severity: _severity!,
        studentId: '', // TODO: Implementar búsqueda de estudiante
        studentName: _studentName,
        reportedBy: _reportedBy,
        location: _location,
        incidentDate: _incidentDate,
        reportedDate: DateTime.now(),
        status: IncidentStatus.reported,
        witnesses: _witnesses,
        notes: _notes.isNotEmpty ? _notes : null,
        // TODO: Agregar campos adicionales a la entidad Incident
      );

      return incident;
    } catch (e) {
      _errorMessage = 'Error al crear la incidencia: $e';
      notifyListeners();
      return null;
    }
  }

  // Limpiar formulario
  void clearForm() {
    _title = '';
    _description = '';
    _type = null;
    _severity = null;
    _studentName = '';
    _reportedBy = '';
    _location = '';
    _incidentDate = DateTime.now();
    _witnesses.clear();
    _notes = '';
    _notifyParent = false;
    _derivateTo = '';
    _priority = 'Normal';
    _category = 'General';
    _isValid = false;
    _errorMessage = null;
    _showValidationErrors = false;
    notifyListeners();
  }

  // Simular envío de formulario
  Future<bool> submitForm() async {
    // Activar validación visual al intentar enviar
    _showValidationErrors = true;

    if (!_isValid) {
      _errorMessage = 'Por favor completa todos los campos requeridos';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 2));

      final incident = createIncident();
      if (incident == null) {
        return false;
      }

      // TODO: Implementar guardado en base de datos
      // await _incidentRepository.save(incident);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al enviar el formulario: $e';
      notifyListeners();
      return false;
    }
  }

  // Obtener fecha formateada
  String getFormattedIncidentDate() {
    return '${_incidentDate.day}/${_incidentDate.month}/${_incidentDate.year}';
  }

  // Verificar si un campo está vacío
  bool isFieldEmpty(String field) {
    switch (field) {
      case 'title':
        return _title.isEmpty;
      case 'description':
        return _description.isEmpty;
      case 'studentName':
        return _studentName.isEmpty;
      case 'reportedBy':
        return _reportedBy.isEmpty;
      case 'location':
        return _location.isEmpty;
      case 'type':
        return _type == null;
      case 'severity':
        return _severity == null;
      case 'incidentDate':
        return false; // _incidentDate siempre tiene un valor
      default:
        return false;
    }
  }

  // Obtener mensaje de error para un campo específico
  String? getFieldError(String field) {
    if (!_showValidationErrors || !isFieldEmpty(field)) return null;

    switch (field) {
      case 'title':
        return 'El título es requerido';
      case 'description':
        return 'La descripción es requerida';
      case 'studentName':
        return 'El nombre del estudiante es requerido';
      case 'reportedBy':
        return 'El nombre del reportante es requerido';
      case 'location':
        return 'La ubicación es requerida';
      case 'type':
        return 'El tipo de incidencia es requerido';
      case 'severity':
        return 'La severidad es requerida';
      case 'incidentDate':
        return 'La fecha del incidente es requerida';
      default:
        return null;
    }
  }

  // Verificar si un campo debe mostrar error visual
  bool shouldShowFieldError(String field) {
    return _showValidationErrors && isFieldEmpty(field);
  }
}
