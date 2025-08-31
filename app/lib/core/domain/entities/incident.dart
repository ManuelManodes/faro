class Incident {
  final String id;
  final String title;
  final String description;
  final IncidentType type;
  final IncidentSeverity severity;
  final String studentId;
  final String studentName;
  final String reportedBy;
  final String location;
  final DateTime incidentDate;
  final DateTime reportedDate;
  final IncidentStatus status;
  final List<String> witnesses;
  final List<String> attachments;
  final String? resolution;
  final DateTime? resolvedDate;
  final String? resolvedBy;
  final String? notes;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.studentId,
    required this.studentName,
    required this.reportedBy,
    required this.location,
    required this.incidentDate,
    required this.reportedDate,
    required this.status,
    this.witnesses = const [],

    this.attachments = const [],
    this.resolution,
    this.resolvedDate,
    this.resolvedBy,
    this.notes,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: IncidentType.values.firstWhere(
        (e) => e.toString() == 'IncidentType.${json['type']}',
      ),
      severity: IncidentSeverity.values.firstWhere(
        (e) => e.toString() == 'IncidentSeverity.${json['severity']}',
      ),
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      reportedBy: json['reportedBy'] as String,
      location: json['location'] as String,
      incidentDate: DateTime.parse(json['incidentDate'] as String),
      reportedDate: DateTime.parse(json['reportedDate'] as String),
      status: IncidentStatus.values.firstWhere(
        (e) => e.toString() == 'IncidentStatus.${json['status']}',
      ),
      witnesses: List<String>.from(json['witnesses'] ?? []),
      attachments: List<String>.from(json['attachments'] ?? []),
      resolution: json['resolution'] as String?,
      resolvedDate: json['resolvedDate'] != null
          ? DateTime.parse(json['resolvedDate'] as String)
          : null,
      resolvedBy: json['resolvedBy'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'severity': severity.toString().split('.').last,
      'studentId': studentId,
      'studentName': studentName,
      'reportedBy': reportedBy,
      'location': location,
      'incidentDate': incidentDate.toIso8601String(),
      'reportedDate': reportedDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'witnesses': witnesses,
      'attachments': attachments,
      'resolution': resolution,
      'resolvedDate': resolvedDate?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'notes': notes,
    };
  }

  Incident copyWith({
    String? id,
    String? title,
    String? description,
    IncidentType? type,
    IncidentSeverity? severity,
    String? studentId,
    String? studentName,
    String? reportedBy,
    String? location,
    DateTime? incidentDate,
    DateTime? reportedDate,
    IncidentStatus? status,
    List<String>? witnesses,
    List<String>? attachments,
    String? resolution,
    DateTime? resolvedDate,
    String? resolvedBy,
    String? notes,
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      reportedBy: reportedBy ?? this.reportedBy,
      location: location ?? this.location,
      incidentDate: incidentDate ?? this.incidentDate,
      reportedDate: reportedDate ?? this.reportedDate,
      status: status ?? this.status,
      witnesses: witnesses ?? this.witnesses,
      attachments: attachments ?? this.attachments,
      resolution: resolution ?? this.resolution,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Incident && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Incident(id: $id, title: $title, type: $type, severity: $severity, status: $status)';
  }
}

enum IncidentType {
  academicMisconduct('Falta Académica'),
  behavioralIssue('Problema de Conducta'),
  bullying('Acoso Escolar'),
  vandalism('Vandalismo'),
  theft('Robo'),
  violence('Violencia'),
  healthEmergency('Emergencia de Salud'),
  safetyConcern('Preocupación de Seguridad'),
  technologyIssue('Problema Tecnológico'),
  other('Otro');

  const IncidentType(this.displayName);
  final String displayName;
}

enum IncidentSeverity {
  low('Baja'),
  medium('Media'),
  high('Alta'),
  critical('Crítica');

  const IncidentSeverity(this.displayName);
  final String displayName;
}

enum IncidentStatus {
  reported('Reportada'),
  underInvestigation('En Investigación'),
  resolved('Resuelta'),
  closed('Cerrada'),
  escalated('Escalada');

  const IncidentStatus(this.displayName);
  final String displayName;
}
