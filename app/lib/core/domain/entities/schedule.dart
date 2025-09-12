import 'package:flutter/material.dart';

/// Patrones de recurrencia para citas
enum RecurrencePattern {
  none('Sin repetición'),
  daily('Diario'),
  weekly('Semanal'),
  monthly('Mensual'),
  yearly('Anual');

  const RecurrencePattern(this.displayName);
  final String displayName;
}

/// Días de la semana para programación
enum DayOfWeek {
  monday('Lunes'),
  tuesday('Martes'),
  wednesday('Miércoles'),
  thursday('Jueves'),
  friday('Viernes'),
  saturday('Sábado'),
  sunday('Domingo');

  const DayOfWeek(this.displayName);
  final String displayName;
}

/// Configuración de horarios de trabajo
class WorkSchedule {
  final String id;
  final String teacherId;
  final String teacherName;
  final List<DayOfWeek> workingDays;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Duration breakDuration;
  final Duration appointmentDuration;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkSchedule({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    required this.breakDuration,
    required this.appointmentDuration,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea un nuevo horario de trabajo
  factory WorkSchedule.create({
    required String teacherId,
    required String teacherName,
    required List<DayOfWeek> workingDays,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    Duration breakDuration = const Duration(minutes: 15),
    Duration appointmentDuration = const Duration(minutes: 30),
  }) {
    final now = DateTime.now();
    return WorkSchedule(
      id: 'schedule_${teacherId}_${now.millisecondsSinceEpoch}',
      teacherId: teacherId,
      teacherName: teacherName,
      workingDays: workingDays,
      startTime: startTime,
      endTime: endTime,
      breakDuration: breakDuration,
      appointmentDuration: appointmentDuration,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Verifica si un día específico es día de trabajo
  bool isWorkingDay(DayOfWeek day) {
    return workingDays.contains(day);
  }

  /// Verifica si una hora específica está dentro del horario de trabajo
  bool isWithinWorkingHours(TimeOfDay time) {
    final timeInMinutes = time.hour * 60 + time.minute;
    final startInMinutes = startTime.hour * 60 + startTime.minute;
    final endInMinutes = endTime.hour * 60 + endTime.minute;

    return timeInMinutes >= startInMinutes && timeInMinutes <= endInMinutes;
  }

  /// Obtiene el número total de horas de trabajo por semana
  double get weeklyWorkingHours {
    final dailyHours =
        endTime.hour -
        startTime.hour +
        (endTime.minute - startTime.minute) / 60.0;
    return dailyHours * workingDays.length;
  }

  /// Obtiene el número de citas que se pueden programar por día
  int get appointmentsPerDay {
    final totalMinutes =
        (endTime.hour * 60 + endTime.minute) -
        (startTime.hour * 60 + startTime.minute);
    final availableMinutes = totalMinutes - breakDuration.inMinutes;
    return (availableMinutes / appointmentDuration.inMinutes).floor();
  }

  /// Convierte el horario a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'workingDays': workingDays.map((day) => day.name).toList(),
      'startTime':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'endTime':
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'breakDuration': breakDuration.inMinutes,
      'appointmentDuration': appointmentDuration.inMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea un horario desde un mapa
  factory WorkSchedule.fromMap(Map<String, dynamic> map) {
    final startTimeParts = (map['startTime'] as String).split(':');
    final endTimeParts = (map['endTime'] as String).split(':');

    return WorkSchedule(
      id: map['id'] ?? '',
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? '',
      workingDays: (map['workingDays'] as List<dynamic>)
          .map(
            (day) => DayOfWeek.values.firstWhere(
              (e) => e.name == day,
              orElse: () => DayOfWeek.monday,
            ),
          )
          .toList(),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      breakDuration: Duration(minutes: map['breakDuration'] ?? 15),
      appointmentDuration: Duration(minutes: map['appointmentDuration'] ?? 30),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

/// Representa un bloque de tiempo disponible para citas
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? teacherId;
  final String? teacherName;
  final Duration duration;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.teacherId,
    this.teacherName,
    required this.duration,
  });

  /// Verifica si este slot está disponible en una fecha específica
  bool isAvailableOn(DateTime date) {
    return isAvailable &&
        startTime.year == date.year &&
        startTime.month == date.month &&
        startTime.day == date.day;
  }

  /// Obtiene la duración del slot en minutos
  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Verifica si este slot se superpone con otro
  bool overlapsWith(TimeSlot other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }

  /// Verifica si este slot contiene un tiempo específico
  bool contains(DateTime time) {
    return time.isAfter(startTime.subtract(const Duration(milliseconds: 1))) &&
        time.isBefore(endTime.add(const Duration(milliseconds: 1)));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;

  @override
  String toString() {
    return 'TimeSlot(startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable)';
  }
}

/// Representa un rango de fechas para consultas
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  const DateRange({required this.startDate, required this.endDate});

  /// Crea un rango para hoy
  factory DateRange.today() {
    final now = DateTime.now();
    return DateRange(
      startDate: DateTime(now.year, now.month, now.day),
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  /// Crea un rango para esta semana
  factory DateRange.thisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
    return DateRange(startDate: startOfWeek, endDate: endOfWeek);
  }

  /// Crea un rango para este mes
  factory DateRange.thisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return DateRange(startDate: startOfMonth, endDate: endOfMonth);
  }

  /// Crea un rango para el próximo mes
  factory DateRange.nextMonth() {
    final now = DateTime.now();
    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    final endOfNextMonth = DateTime(now.year, now.month + 2, 0, 23, 59, 59);
    return DateRange(startDate: startOfNextMonth, endDate: endOfNextMonth);
  }

  /// Verifica si una fecha está dentro del rango
  bool contains(DateTime date) {
    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)));
  }

  /// Obtiene el número de días en el rango
  int get daysCount {
    return endDate.difference(startDate).inDays + 1;
  }

  /// Obtiene la duración del rango
  Duration get duration {
    return endDate.difference(startDate);
  }

  @override
  String toString() {
    return 'DateRange(startDate: $startDate, endDate: $endDate)';
  }
}
