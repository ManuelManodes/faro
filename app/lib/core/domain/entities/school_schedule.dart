import 'package:flutter/material.dart';

/// Entidad para horarios escolares
class SchoolSchedule {
  final String id;
  final String subject;
  final String teacherName;
  final String teacherId;
  final String classroom;
  final String grade;
  final String section;
  final DateTime startTime;
  final DateTime endTime;
  final List<DayOfWeek> daysOfWeek;
  final String color;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SchoolSchedule({
    required this.id,
    required this.subject,
    required this.teacherName,
    required this.teacherId,
    required this.classroom,
    required this.grade,
    required this.section,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
    required this.color,
    required this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor para crear un nuevo horario
  factory SchoolSchedule.create({
    required String subject,
    required String teacherName,
    required String teacherId,
    required String classroom,
    required String grade,
    required String section,
    required DateTime startTime,
    required DateTime endTime,
    required List<DayOfWeek> daysOfWeek,
    String? color,
    String? description,
  }) {
    final now = DateTime.now();
    return SchoolSchedule(
      id: 'school_schedule_${now.millisecondsSinceEpoch}',
      subject: subject,
      teacherName: teacherName,
      teacherId: teacherId,
      classroom: classroom,
      grade: grade,
      section: section,
      startTime: startTime,
      endTime: endTime,
      daysOfWeek: daysOfWeek,
      color: color ?? _getDefaultColor(subject),
      description: description ?? '',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Factory constructor desde Map
  factory SchoolSchedule.fromMap(Map<String, dynamic> map) {
    return SchoolSchedule(
      id: map['id'] ?? '',
      subject: map['subject'] ?? '',
      teacherName: map['teacherName'] ?? '',
      teacherId: map['teacherId'] ?? '',
      classroom: map['classroom'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      daysOfWeek: (map['daysOfWeek'] as List<dynamic>)
          .map((day) => DayOfWeek.values[day])
          .toList(),
      color: map['color'] ?? _getDefaultColor(map['subject'] ?? ''),
      description: map['description'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  /// Convierte a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'teacherName': teacherName,
      'teacherId': teacherId,
      'classroom': classroom,
      'grade': grade,
      'section': section,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'daysOfWeek': daysOfWeek.map((day) => day.index).toList(),
      'color': color,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea una copia con campos modificados
  SchoolSchedule copyWith({
    String? id,
    String? subject,
    String? teacherName,
    String? teacherId,
    String? classroom,
    String? grade,
    String? section,
    DateTime? startTime,
    DateTime? endTime,
    List<DayOfWeek>? daysOfWeek,
    String? color,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SchoolSchedule(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      teacherName: teacherName ?? this.teacherName,
      teacherId: teacherId ?? this.teacherId,
      classroom: classroom ?? this.classroom,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      color: color ?? this.color,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Obtiene el color por defecto basado en la asignatura
  static String _getDefaultColor(String subject) {
    final colors = {
      'Matemáticas': '#FF6B6B',
      'Lengua': '#4ECDC4',
      'Ciencias': '#45B7D1',
      'Historia': '#96CEB4',
      'Geografía': '#FFEAA7',
      'Inglés': '#DDA0DD',
      'Educación Física': '#98D8C8',
      'Arte': '#F7DC6F',
      'Música': '#BB8FCE',
      'Informática': '#85C1E9',
    };

    return colors[subject] ?? '#95A5A6';
  }

  /// Convierte el color string a Color
  Color get colorValue {
    return Color(int.parse(color.replaceFirst('#', '0xFF')));
  }

  /// Obtiene la duración del horario
  Duration get duration {
    return endTime.difference(startTime);
  }

  /// Verifica si el horario está activo en un día específico
  bool isActiveOnDay(DayOfWeek day) {
    return daysOfWeek.contains(day);
  }

  /// Obtiene el horario formateado
  String get formattedTime {
    final start =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  @override
  String toString() {
    return 'SchoolSchedule(id: $id, subject: $subject, teacher: $teacherName, time: $formattedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SchoolSchedule && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Días de la semana
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Lunes';
      case DayOfWeek.tuesday:
        return 'Martes';
      case DayOfWeek.wednesday:
        return 'Miércoles';
      case DayOfWeek.thursday:
        return 'Jueves';
      case DayOfWeek.friday:
        return 'Viernes';
      case DayOfWeek.saturday:
        return 'Sábado';
      case DayOfWeek.sunday:
        return 'Domingo';
    }
  }

  String get shortName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Lun';
      case DayOfWeek.tuesday:
        return 'Mar';
      case DayOfWeek.wednesday:
        return 'Mié';
      case DayOfWeek.thursday:
        return 'Jue';
      case DayOfWeek.friday:
        return 'Vie';
      case DayOfWeek.saturday:
        return 'Sáb';
      case DayOfWeek.sunday:
        return 'Dom';
    }
  }
}
