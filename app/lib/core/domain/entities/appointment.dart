import 'package:uuid/uuid.dart';

/// Tipos de citas disponibles
enum AppointmentType {
  consulta('Consulta'),
  reunion('Reunión'),
  evaluacion('Evaluación'),
  seguimiento('Seguimiento'),
  emergencia('Emergencia');

  const AppointmentType(this.displayName);
  final String displayName;
}

/// Estados de una cita
enum AppointmentStatus {
  programada('Programada'),
  confirmada('Confirmada'),
  enProgreso('En Progreso'),
  completada('Completada'),
  cancelada('Cancelada'),
  reagendada('Reagendada');

  const AppointmentStatus(this.displayName);
  final String displayName;
}

/// Prioridad de una cita
enum AppointmentPriority {
  baja('Baja'),
  media('Media'),
  alta('Alta'),
  urgente('Urgente');

  const AppointmentPriority(this.displayName);
  final String displayName;
}

/// Entidad que representa una cita
class Appointment {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentType type;
  final AppointmentStatus status;
  final AppointmentPriority priority;
  final String studentId;
  final String studentName;
  final String? teacherId;
  final String? teacherName;
  final String? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRecurring;
  final String? recurrencePattern;
  final String? parentAppointmentId;

  const Appointment({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.status,
    required this.priority,
    required this.studentId,
    required this.studentName,
    this.teacherId,
    this.teacherName,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isRecurring = false,
    this.recurrencePattern,
    this.parentAppointmentId,
  });

  /// Crea una nueva cita
  factory Appointment.create({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required AppointmentType type,
    required AppointmentPriority priority,
    required String studentId,
    required String studentName,
    String? teacherId,
    String? teacherName,
    String? location,
    String? notes,
    bool isRecurring = false,
    String? recurrencePattern,
  }) {
    final now = DateTime.now();
    return Appointment(
      id: const Uuid().v4(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      type: type,
      status: AppointmentStatus.programada,
      priority: priority,
      studentId: studentId,
      studentName: studentName,
      teacherId: teacherId,
      teacherName: teacherName,
      location: location,
      notes: notes,
      createdAt: now,
      updatedAt: now,
      isRecurring: isRecurring,
      recurrencePattern: recurrencePattern,
    );
  }

  /// Crea una copia de la cita con campos modificados
  Appointment copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    AppointmentType? type,
    AppointmentStatus? status,
    AppointmentPriority? priority,
    String? studentId,
    String? studentName,
    String? teacherId,
    String? teacherName,
    String? location,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRecurring,
    String? recurrencePattern,
    String? parentAppointmentId,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      parentAppointmentId: parentAppointmentId ?? this.parentAppointmentId,
    );
  }

  /// Actualiza la cita con nueva información
  Appointment update({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    AppointmentType? type,
    AppointmentStatus? status,
    AppointmentPriority? priority,
    String? teacherId,
    String? teacherName,
    String? location,
    String? notes,
  }) {
    return copyWith(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      type: type,
      status: status,
      priority: priority,
      teacherId: teacherId,
      teacherName: teacherName,
      location: location,
      notes: notes,
      updatedAt: DateTime.now(),
    );
  }

  /// Confirma la cita
  Appointment confirm() {
    return copyWith(
      status: AppointmentStatus.confirmada,
      updatedAt: DateTime.now(),
    );
  }

  /// Cancela la cita
  Appointment cancel() {
    return copyWith(
      status: AppointmentStatus.cancelada,
      updatedAt: DateTime.now(),
    );
  }

  /// Completa la cita
  Appointment complete() {
    return copyWith(
      status: AppointmentStatus.completada,
      updatedAt: DateTime.now(),
    );
  }

  /// Verifica si la cita está en el rango de fechas especificado
  bool isInDateRange(DateTime startDate, DateTime endDate) {
    return startTime.isAfter(startDate.subtract(const Duration(days: 1))) &&
        startTime.isBefore(endDate.add(const Duration(days: 1)));
  }

  /// Verifica si la cita es hoy
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  /// Verifica si la cita es mañana
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return startTime.year == tomorrow.year &&
        startTime.month == tomorrow.month &&
        startTime.day == tomorrow.day;
  }

  /// Verifica si la cita es esta semana
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isInDateRange(startOfWeek, endOfWeek);
  }

  /// Obtiene la duración de la cita en minutos
  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Obtiene la duración de la cita en horas
  double get durationInHours {
    return durationInMinutes / 60.0;
  }

  /// Verifica si la cita está activa (no cancelada ni completada)
  bool get isActive {
    return status != AppointmentStatus.cancelada &&
        status != AppointmentStatus.completada;
  }

  /// Verifica si la cita está pendiente
  bool get isPending {
    return status == AppointmentStatus.programada ||
        status == AppointmentStatus.confirmada;
  }

  /// Obtiene el color asociado al tipo de cita
  int get typeColor {
    switch (type) {
      case AppointmentType.consulta:
        return 0xFF2196F3; // Azul
      case AppointmentType.reunion:
        return 0xFF4CAF50; // Verde
      case AppointmentType.evaluacion:
        return 0xFFFF9800; // Naranja
      case AppointmentType.seguimiento:
        return 0xFF9C27B0; // Púrpura
      case AppointmentType.emergencia:
        return 0xFFF44336; // Rojo
    }
  }

  /// Obtiene el color asociado a la prioridad
  int get priorityColor {
    switch (priority) {
      case AppointmentPriority.baja:
        return 0xFF4CAF50; // Verde
      case AppointmentPriority.media:
        return 0xFFFF9800; // Naranja
      case AppointmentPriority.alta:
        return 0xFFFF5722; // Rojo oscuro
      case AppointmentPriority.urgente:
        return 0xFFF44336; // Rojo
    }
  }

  /// Convierte la cita a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type.name,
      'status': status.name,
      'priority': priority.name,
      'studentId': studentId,
      'studentName': studentName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'location': location,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
      'parentAppointmentId': parentAppointmentId,
    };
  }

  /// Crea una cita desde un mapa
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      type: AppointmentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AppointmentType.consulta,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AppointmentStatus.programada,
      ),
      priority: AppointmentPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => AppointmentPriority.media,
      ),
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      location: map['location'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isRecurring: map['isRecurring'] ?? false,
      recurrencePattern: map['recurrencePattern'],
      parentAppointmentId: map['parentAppointmentId'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Appointment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Appointment(id: $id, title: $title, startTime: $startTime, type: $type, status: $status)';
  }
}
