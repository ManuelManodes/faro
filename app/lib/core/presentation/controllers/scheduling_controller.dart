import 'package:flutter/material.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/school_schedule.dart' as school;

/// Controlador para el sistema de agendamiento
class SchedulingController extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  final List<WorkSchedule> _workSchedules = [];
  final List<school.SchoolSchedule> _schoolSchedules = [];
  final List<TimeSlot> _availableSlots = [];
  DateTime _selectedDate = DateTime.now();
  DateRange _currentDateRange = DateRange.thisWeek();
  Appointment? _selectedAppointment;
  bool _isLoading = false;
  String? _error;
  String _viewMode = 'calendar'; // 'calendar', 'list', 'week'
  String _filterType =
      'all'; // 'all', 'consulta', 'reunion', 'evaluacion', 'seguimiento', 'emergencia'
  String _filterStatus =
      'all'; // 'all', 'programada', 'confirmada', 'enProgreso', 'completada', 'cancelada'
  String _filterPriority = 'all'; // 'all', 'baja', 'media', 'alta', 'urgente'
  bool _showSchoolSchedules = true;

  // Getters
  List<Appointment> get appointments => _appointments;
  List<WorkSchedule> get workSchedules => _workSchedules;
  List<school.SchoolSchedule> get schoolSchedules => _schoolSchedules;
  List<TimeSlot> get availableSlots => _availableSlots;
  DateTime get selectedDate => _selectedDate;
  DateRange get currentDateRange => _currentDateRange;
  Appointment? get selectedAppointment => _selectedAppointment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get viewMode => _viewMode;
  String get filterType => _filterType;
  String get filterStatus => _filterStatus;
  String get filterPriority => _filterPriority;
  bool get showSchoolSchedules => _showSchoolSchedules;

  /// Obtiene las citas filtradas según los criterios actuales
  List<Appointment> get filteredAppointments {
    return _appointments.where((appointment) {
      // Filtro por tipo
      if (_filterType != 'all' && appointment.type.name != _filterType) {
        return false;
      }

      // Filtro por estado
      if (_filterStatus != 'all' && appointment.status.name != _filterStatus) {
        return false;
      }

      // Filtro por prioridad
      if (_filterPriority != 'all' &&
          appointment.priority.name != _filterPriority) {
        return false;
      }

      // Filtro por rango de fechas
      if (!_currentDateRange.contains(appointment.startTime)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Obtiene las citas para una fecha específica
  List<Appointment> getAppointmentsForDate(DateTime date) {
    return _appointments.where((appointment) {
      return appointment.startTime.year == date.year &&
          appointment.startTime.month == date.month &&
          appointment.startTime.day == date.day;
    }).toList();
  }

  /// Obtiene las citas para hoy
  List<Appointment> get todayAppointments {
    return getAppointmentsForDate(DateTime.now());
  }

  /// Obtiene las citas para mañana
  List<Appointment> get tomorrowAppointments {
    return getAppointmentsForDate(DateTime.now().add(const Duration(days: 1)));
  }

  /// Obtiene las citas de esta semana
  List<Appointment> get thisWeekAppointments {
    return _appointments.where((appointment) {
      return _currentDateRange.contains(appointment.startTime);
    }).toList();
  }

  /// Obtiene las citas pendientes
  List<Appointment> get pendingAppointments {
    return _appointments.where((appointment) => appointment.isPending).toList();
  }

  /// Obtiene las citas activas
  List<Appointment> get activeAppointments {
    return _appointments.where((appointment) => appointment.isActive).toList();
  }

  /// Obtiene las citas por tipo
  Map<AppointmentType, List<Appointment>> get appointmentsByType {
    final Map<AppointmentType, List<Appointment>> grouped = {};
    for (final appointment in _appointments) {
      grouped.putIfAbsent(appointment.type, () => []).add(appointment);
    }
    return grouped;
  }

  /// Obtiene las citas por estado
  Map<AppointmentStatus, List<Appointment>> get appointmentsByStatus {
    final Map<AppointmentStatus, List<Appointment>> grouped = {};
    for (final appointment in _appointments) {
      grouped.putIfAbsent(appointment.status, () => []).add(appointment);
    }
    return grouped;
  }

  /// Obtiene las citas por prioridad
  Map<AppointmentPriority, List<Appointment>> get appointmentsByPriority {
    final Map<AppointmentPriority, List<Appointment>> grouped = {};
    for (final appointment in _appointments) {
      grouped.putIfAbsent(appointment.priority, () => []).add(appointment);
    }
    return grouped;
  }

  /// Obtiene estadísticas de las citas
  Map<String, dynamic> get appointmentStatistics {
    final total = _appointments.length;
    final pending = pendingAppointments.length;
    final completed = _appointments
        .where((a) => a.status == AppointmentStatus.completada)
        .length;
    final cancelled = _appointments
        .where((a) => a.status == AppointmentStatus.cancelada)
        .length;
    final today = todayAppointments.length;
    final thisWeek = thisWeekAppointments.length;

    return {
      'total': total,
      'pending': pending,
      'completed': completed,
      'cancelled': cancelled,
      'today': today,
      'thisWeek': thisWeek,
      'completionRate': total > 0 ? (completed / total * 100).round() : 0,
    };
  }

  /// Establece la fecha seleccionada
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Establece el rango de fechas actual
  void setCurrentDateRange(DateRange range) {
    _currentDateRange = range;
    notifyListeners();
  }

  /// Establece la cita seleccionada
  void setSelectedAppointment(Appointment? appointment) {
    _selectedAppointment = appointment;
    notifyListeners();
  }

  /// Cambia el modo de vista
  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  /// Establece el filtro de tipo
  void setFilterType(String type) {
    _filterType = type;
    notifyListeners();
  }

  /// Establece el filtro de estado
  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  /// Establece el filtro de prioridad
  void setFilterPriority(String priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  /// Limpia todos los filtros
  void clearFilters() {
    _filterType = 'all';
    _filterStatus = 'all';
    _filterPriority = 'all';
    notifyListeners();
  }

  /// Crea una nueva cita
  Future<void> createAppointment({
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
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final appointment = Appointment.create(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        type: type,
        priority: priority,
        studentId: studentId,
        studentName: studentName,
        teacherId: teacherId,
        teacherName: teacherName,
        location: location,
        notes: notes,
        isRecurring: isRecurring,
        recurrencePattern: recurrencePattern,
      );

      _appointments.add(appointment);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al crear la cita: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza una cita existente
  Future<void> updateAppointment(
    String appointmentId, {
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
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index == -1) {
        throw Exception('Cita no encontrada');
      }

      final appointment = _appointments[index].update(
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
      );

      _appointments[index] = appointment;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al actualizar la cita: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina una cita
  Future<void> deleteAppointment(String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _appointments.removeWhere((a) => a.id == appointmentId);
      if (_selectedAppointment?.id == appointmentId) {
        _selectedAppointment = null;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar la cita: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Confirma una cita
  Future<void> confirmAppointment(String appointmentId) async {
    await updateAppointment(
      appointmentId,
      status: AppointmentStatus.confirmada,
    );
  }

  /// Cancela una cita
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointment(appointmentId, status: AppointmentStatus.cancelada);
  }

  /// Completa una cita
  Future<void> completeAppointment(String appointmentId) async {
    await updateAppointment(
      appointmentId,
      status: AppointmentStatus.completada,
    );
  }

  /// Genera slots de tiempo disponibles para una fecha específica
  void generateAvailableSlots(DateTime date, {String? teacherId}) {
    _availableSlots.clear();

    // Obtener horarios de trabajo para el profesor específico o todos
    final schedules = teacherId != null
        ? _workSchedules.where((s) => s.teacherId == teacherId && s.isActive)
        : _workSchedules.where((s) => s.isActive);

    for (final schedule in schedules) {
      final dayOfWeek = DayOfWeek.values[date.weekday - 1];
      if (!schedule.isWorkingDay(dayOfWeek)) continue;

      // Generar slots basados en la duración de las citas
      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        schedule.startTime.hour,
        schedule.startTime.minute,
      );

      final endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        schedule.endTime.hour,
        schedule.endTime.minute,
      );

      DateTime currentTime = startDateTime;
      while (currentTime
              .add(schedule.appointmentDuration)
              .isBefore(endDateTime) ||
          currentTime
              .add(schedule.appointmentDuration)
              .isAtSameMomentAs(endDateTime)) {
        final slotEndTime = currentTime.add(schedule.appointmentDuration);

        // Verificar si este slot está disponible (no hay citas existentes)
        final isAvailable = !_appointments.any((appointment) {
          return appointment.startTime.isBefore(slotEndTime) &&
              appointment.endTime.isAfter(currentTime) &&
              appointment.teacherId == schedule.teacherId;
        });

        _availableSlots.add(
          TimeSlot(
            startTime: currentTime,
            endTime: slotEndTime,
            isAvailable: isAvailable,
            teacherId: schedule.teacherId,
            teacherName: schedule.teacherName,
            duration: schedule.appointmentDuration,
          ),
        );

        currentTime = currentTime.add(schedule.appointmentDuration);
      }
    }

    notifyListeners();
  }

  /// Agrega un horario de trabajo
  void addWorkSchedule(WorkSchedule schedule) {
    _workSchedules.add(schedule);
    notifyListeners();
  }

  /// Actualiza un horario de trabajo
  void updateWorkSchedule(String scheduleId, WorkSchedule updatedSchedule) {
    final index = _workSchedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _workSchedules[index] = updatedSchedule;
      notifyListeners();
    }
  }

  /// Elimina un horario de trabajo
  void removeWorkSchedule(String scheduleId) {
    _workSchedules.removeWhere((s) => s.id == scheduleId);
    notifyListeners();
  }

  /// Carga datos de ejemplo para testing
  void loadSampleData() {
    _appointments.clear();
    _workSchedules.clear();
    _schoolSchedules.clear();
    _workSchedules.add(
      WorkSchedule.create(
        teacherId: 'teacher_1',
        teacherName: 'Prof. María González',
        workingDays: [
          DayOfWeek.monday,
          DayOfWeek.tuesday,
          DayOfWeek.wednesday,
          DayOfWeek.thursday,
          DayOfWeek.friday,
        ],
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        breakDuration: const Duration(minutes: 15),
        appointmentDuration: const Duration(minutes: 30),
      ),
    );

    // Crear citas de ejemplo
    _appointments.addAll([
      Appointment.create(
        title: 'Consulta Académica',
        description: 'Revisión de progreso académico',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
        type: AppointmentType.consulta,
        priority: AppointmentPriority.media,
        studentId: 'student_1',
        studentName: 'Juan Pérez',
        teacherId: 'teacher_1',
        teacherName: 'Prof. María González',
        location: 'Aula 101',
      ),
      Appointment.create(
        title: 'Evaluación Psicológica',
        description: 'Test de Holland - Seguimiento',
        startTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 11)),
        type: AppointmentType.evaluacion,
        priority: AppointmentPriority.alta,
        studentId: 'student_2',
        studentName: 'Ana García',
        teacherId: 'teacher_1',
        teacherName: 'Prof. María González',
        location: 'Oficina de Orientación',
      ),
      Appointment.create(
        title: 'Reunión de Padres',
        description: 'Reunión trimestral con padres',
        startTime: DateTime.now().add(const Duration(days: 2, hours: 15)),
        endTime: DateTime.now().add(const Duration(days: 2, hours: 16)),
        type: AppointmentType.reunion,
        priority: AppointmentPriority.media,
        studentId: 'student_3',
        studentName: 'Carlos López',
        teacherId: 'teacher_1',
        teacherName: 'Prof. María González',
        location: 'Sala de Juntas',
      ),
    ]);

    // Agregar horarios escolares de ejemplo
    _schoolSchedules.addAll([
      school.SchoolSchedule.create(
        subject: 'Matemáticas',
        teacherName: 'Prof. Ana García',
        teacherId: 'teacher_math',
        classroom: 'Aula 101',
        grade: '5to',
        section: 'A',
        startTime: DateTime(2024, 1, 1, 8, 0), // 8:00 AM
        endTime: DateTime(2024, 1, 1, 9, 0), // 9:00 AM
        daysOfWeek: [
          school.DayOfWeek.monday,
          school.DayOfWeek.wednesday,
          school.DayOfWeek.friday,
        ],
        description: 'Clase de matemáticas para 5to A',
      ),
      school.SchoolSchedule.create(
        subject: 'Lengua',
        teacherName: 'Prof. Carlos López',
        teacherId: 'teacher_lang',
        classroom: 'Aula 102',
        grade: '5to',
        section: 'A',
        startTime: DateTime(2024, 1, 1, 9, 0), // 9:00 AM
        endTime: DateTime(2024, 1, 1, 10, 0), // 10:00 AM
        daysOfWeek: [
          school.DayOfWeek.monday,
          school.DayOfWeek.wednesday,
          school.DayOfWeek.friday,
        ],
        description: 'Clase de lengua para 5to A',
      ),
      school.SchoolSchedule.create(
        subject: 'Ciencias',
        teacherName: 'Prof. María Rodríguez',
        teacherId: 'teacher_science',
        classroom: 'Laboratorio 1',
        grade: '5to',
        section: 'B',
        startTime: DateTime(2024, 1, 1, 10, 30), // 10:30 AM
        endTime: DateTime(2024, 1, 1, 11, 30), // 11:30 AM
        daysOfWeek: [school.DayOfWeek.tuesday, school.DayOfWeek.thursday],
        description: 'Clase de ciencias para 5to B',
      ),
      school.SchoolSchedule.create(
        subject: 'Historia',
        teacherName: 'Prof. Juan Pérez',
        teacherId: 'teacher_history',
        classroom: 'Aula 103',
        grade: '6to',
        section: 'A',
        startTime: DateTime(2024, 1, 1, 8, 30), // 8:30 AM
        endTime: DateTime(2024, 1, 1, 9, 30), // 9:30 AM
        daysOfWeek: [
          school.DayOfWeek.monday,
          school.DayOfWeek.wednesday,
          school.DayOfWeek.friday,
        ],
        description: 'Clase de historia para 6to A',
      ),
      school.SchoolSchedule.create(
        subject: 'Educación Física',
        teacherName: 'Prof. Laura Martínez',
        teacherId: 'teacher_pe',
        classroom: 'Gimnasio',
        grade: '5to',
        section: 'A',
        startTime: DateTime(2024, 1, 1, 14, 0), // 2:00 PM
        endTime: DateTime(2024, 1, 1, 15, 0), // 3:00 PM
        daysOfWeek: [school.DayOfWeek.tuesday, school.DayOfWeek.thursday],
        description: 'Clase de educación física para 5to A',
      ),
    ]);

    notifyListeners();
  }

  /// Limpia todos los datos
  void clearAllData() {
    _appointments.clear();
    _workSchedules.clear();
    _schoolSchedules.clear();
    _availableSlots.clear();
    _selectedAppointment = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // ========== MÉTODOS PARA HORARIOS ESCOLARES ==========

  /// Agrega un nuevo horario escolar
  void addSchoolSchedule(school.SchoolSchedule schedule) {
    _schoolSchedules.add(schedule);
    notifyListeners();
  }

  /// Actualiza un horario escolar existente
  void updateSchoolSchedule(
    String scheduleId,
    school.SchoolSchedule updatedSchedule,
  ) {
    final index = _schoolSchedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schoolSchedules[index] = updatedSchedule;
      notifyListeners();
    }
  }

  /// Elimina un horario escolar
  void removeSchoolSchedule(String scheduleId) {
    _schoolSchedules.removeWhere((s) => s.id == scheduleId);
    notifyListeners();
  }

  /// Obtiene horarios escolares para una fecha específica
  List<school.SchoolSchedule> getSchoolSchedulesForDate(DateTime date) {
    final dayOfWeek = _getDayOfWeek(date);
    return _schoolSchedules.where((schedule) {
      return schedule.isActiveOnDay(dayOfWeek) && schedule.isActive;
    }).toList();
  }

  /// Obtiene horarios escolares para un rango de fechas
  List<school.SchoolSchedule> getSchoolSchedulesForRange(
    DateTime start,
    DateTime end,
  ) {
    final schedules = <school.SchoolSchedule>[];
    final current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      schedules.addAll(getSchoolSchedulesForDate(current));
      current.add(const Duration(days: 1));
    }

    return schedules;
  }

  /// Convierte un horario escolar a una cita para el calendario
  Appointment schoolScheduleToAppointment(
    school.SchoolSchedule schedule,
    DateTime date,
  ) {
    final startTime = DateTime(
      date.year,
      date.month,
      date.day,
      schedule.startTime.hour,
      schedule.startTime.minute,
    );
    final endTime = DateTime(
      date.year,
      date.month,
      date.day,
      schedule.endTime.hour,
      schedule.endTime.minute,
    );

    return Appointment.create(
      title: schedule.subject,
      description:
          '${schedule.grade} - ${schedule.section}\n${schedule.classroom}',
      startTime: startTime,
      endTime: endTime,
      type:
          AppointmentType.reunion, // Usar tipo reunión para horarios escolares
      priority: AppointmentPriority.media,
      location: schedule.classroom,
      notes: schedule.description,
      studentId: schedule.grade,
      studentName: '${schedule.grade} - ${schedule.section}',
      teacherId: schedule.teacherId,
      teacherName: schedule.teacherName,
    );
  }

  /// Obtiene todas las citas (incluyendo horarios escolares) para una fecha
  List<Appointment> getAllAppointmentsForDate(DateTime date) {
    final appointments = <Appointment>[];

    // Agregar citas normales
    appointments.addAll(
      _appointments.where((apt) {
        return apt.startTime.year == date.year &&
            apt.startTime.month == date.month &&
            apt.startTime.day == date.day;
      }),
    );

    // Agregar horarios escolares convertidos a citas
    final schoolSchedules = getSchoolSchedulesForDate(date);
    for (final schedule in schoolSchedules) {
      appointments.add(schoolScheduleToAppointment(schedule, date));
    }

    return appointments;
  }

  /// Obtiene el día de la semana de una fecha
  school.DayOfWeek _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return school.DayOfWeek.monday;
      case 2:
        return school.DayOfWeek.tuesday;
      case 3:
        return school.DayOfWeek.wednesday;
      case 4:
        return school.DayOfWeek.thursday;
      case 5:
        return school.DayOfWeek.friday;
      case 6:
        return school.DayOfWeek.saturday;
      case 7:
        return school.DayOfWeek.sunday;
      default:
        return school.DayOfWeek.monday;
    }
  }

  // ========== MÉTODOS ADICIONALES ==========

  /// Alterna la visualización de horarios escolares
  void toggleSchoolSchedules() {
    _showSchoolSchedules = !_showSchoolSchedules;
    notifyListeners();
  }

  /// Exporta las citas a un formato específico
  Map<String, dynamic> exportAppointments() {
    return {
      'appointments': _appointments.map((a) => a.toMap()).toList(),
      'workSchedules': _workSchedules.map((s) => s.toMap()).toList(),
      'statistics': appointmentStatistics,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// Busca citas por término
  List<Appointment> searchAppointments(String query) {
    if (query.isEmpty) return filteredAppointments;

    final lowercaseQuery = query.toLowerCase();
    return filteredAppointments.where((appointment) {
      return appointment.title.toLowerCase().contains(lowercaseQuery) ||
          appointment.description.toLowerCase().contains(lowercaseQuery) ||
          appointment.studentName.toLowerCase().contains(lowercaseQuery) ||
          appointment.teacherName?.toLowerCase().contains(lowercaseQuery) ==
              true ||
          appointment.location?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }
}
