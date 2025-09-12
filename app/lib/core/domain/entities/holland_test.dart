/// Entidad para el Test de Holland - Orientación Vocacional
/// Basado en la teoría de tipos de personalidad de John Holland
class HollandTest {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime testDate;
  final DateTime completedDate;
  final HollandTestStatus status;
  final Map<String, int> answers; // questionId -> answerIndex
  final HollandTestResult? result;

  const HollandTest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.testDate,
    required this.completedDate,
    required this.status,
    required this.answers,
    this.result,
  });

  /// Crea una nueva instancia del test
  factory HollandTest.create({
    required String studentId,
    required String studentName,
  }) {
    final now = DateTime.now();
    return HollandTest(
      id: 'holland_${studentId}_${now.millisecondsSinceEpoch}',
      studentId: studentId,
      studentName: studentName,
      testDate: now,
      completedDate: now,
      status: HollandTestStatus.inProgress,
      answers: {},
    );
  }

  /// Marca el test como completado
  HollandTest complete() {
    return copyWith(
      status: HollandTestStatus.completed,
      completedDate: DateTime.now(),
    );
  }

  /// Actualiza una respuesta
  HollandTest updateAnswer(String questionId, int answerIndex) {
    final newAnswers = Map<String, int>.from(answers);
    newAnswers[questionId] = answerIndex;
    return copyWith(answers: newAnswers);
  }

  /// Calcula el resultado del test
  HollandTest calculateResult() {
    if (status != HollandTestStatus.completed) {
      return this;
    }

    final result = HollandTestResult.calculate(answers);
    return copyWith(result: result);
  }

  /// Obtiene el progreso del test (0.0 a 1.0)
  double get progress {
    return answers.length / HollandTestData.totalQuestions;
  }

  /// Verifica si el test está completo
  bool get isComplete {
    return answers.length == HollandTestData.totalQuestions;
  }

  /// Obtiene el porcentaje de completado
  int get completionPercentage {
    return (progress * 100).round();
  }

  HollandTest copyWith({
    String? id,
    String? studentId,
    String? studentName,
    DateTime? testDate,
    DateTime? completedDate,
    HollandTestStatus? status,
    Map<String, int>? answers,
    HollandTestResult? result,
  }) {
    return HollandTest(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      testDate: testDate ?? this.testDate,
      completedDate: completedDate ?? this.completedDate,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      result: result ?? this.result,
    );
  }
}

/// Estados del test de Holland
enum HollandTestStatus { inProgress, completed, cancelled }

/// Resultado del test de Holland
class HollandTestResult {
  final Map<HollandType, int> scores;
  final HollandType primaryType;
  final HollandType secondaryType;
  final HollandType tertiaryType;
  final String interpretation;
  final List<String> careerSuggestions;
  final List<String> personalityTraits;

  const HollandTestResult({
    required this.scores,
    required this.primaryType,
    required this.secondaryType,
    required this.tertiaryType,
    required this.interpretation,
    required this.careerSuggestions,
    required this.personalityTraits,
  });

  /// Calcula el resultado basado en las respuestas
  factory HollandTestResult.calculate(Map<String, int> answers) {
    final scores = <HollandType, int>{};

    // Inicializar scores
    for (final type in HollandType.values) {
      scores[type] = 0;
    }

    // Calcular scores por tipo
    for (final entry in answers.entries) {
      final questionId = entry.key;
      final answerIndex = entry.value;

      // Obtener el tipo de la pregunta
      final questionType = HollandTestData.getQuestionType(questionId);
      if (questionType != null) {
        // Sumar puntos según la respuesta (0: No me gusta, 1: Neutral, 2: Me gusta)
        scores[questionType] = (scores[questionType] ?? 0) + answerIndex;
      }
    }

    // Ordenar tipos por score
    final sortedTypes = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primaryType = sortedTypes[0].key;
    final secondaryType = sortedTypes.length > 1
        ? sortedTypes[1].key
        : primaryType;
    final tertiaryType = sortedTypes.length > 2
        ? sortedTypes[2].key
        : secondaryType;

    return HollandTestResult(
      scores: scores,
      primaryType: primaryType,
      secondaryType: secondaryType,
      tertiaryType: tertiaryType,
      interpretation: _getInterpretation(primaryType, secondaryType),
      careerSuggestions: _getCareerSuggestions(primaryType, secondaryType),
      personalityTraits: _getPersonalityTraits(primaryType),
    );
  }

  static String _getInterpretation(HollandType primary, HollandType secondary) {
    return 'Tu perfil vocacional es ${primary.displayName} con influencia de ${secondary.displayName}. '
        'Esto indica que tienes una personalidad ${primary.description} con tendencias hacia ${secondary.description}.';
  }

  static List<String> _getCareerSuggestions(
    HollandType primary,
    HollandType secondary,
  ) {
    final suggestions = <String>[];
    suggestions.addAll(primary.careerSuggestions);
    suggestions.addAll(secondary.careerSuggestions);
    return suggestions.take(6).toList();
  }

  static List<String> _getPersonalityTraits(HollandType type) {
    return type.personalityTraits;
  }
}

/// Tipos de personalidad de Holland
enum HollandType {
  realistic,
  investigative,
  artistic,
  social,
  enterprising,
  conventional;

  String get displayName {
    switch (this) {
      case HollandType.realistic:
        return 'Realista';
      case HollandType.investigative:
        return 'Investigador';
      case HollandType.artistic:
        return 'Artístico';
      case HollandType.social:
        return 'Social';
      case HollandType.enterprising:
        return 'Emprendedor';
      case HollandType.conventional:
        return 'Convencional';
    }
  }

  String get description {
    switch (this) {
      case HollandType.realistic:
        return 'práctica y orientada a resultados concretos';
      case HollandType.investigative:
        return 'analítica y orientada a la investigación';
      case HollandType.artistic:
        return 'creativa y orientada a la expresión';
      case HollandType.social:
        return 'colaborativa y orientada a ayudar a otros';
      case HollandType.enterprising:
        return 'liderazgo y orientada a los negocios';
      case HollandType.conventional:
        return 'organizada y orientada a la estructura';
    }
  }

  List<String> get careerSuggestions {
    switch (this) {
      case HollandType.realistic:
        return [
          'Ingeniero',
          'Mecánico',
          'Arquitecto',
          'Agricultor',
          'Piloto',
          'Carpintero',
        ];
      case HollandType.investigative:
        return [
          'Científico',
          'Médico',
          'Investigador',
          'Matemático',
          'Físico',
          'Químico',
        ];
      case HollandType.artistic:
        return [
          'Artista',
          'Músico',
          'Escritor',
          'Diseñador',
          'Actor',
          'Fotógrafo',
        ];
      case HollandType.social:
        return [
          'Profesor',
          'Psicólogo',
          'Trabajador Social',
          'Enfermero',
          'Consejero',
          'Terapeuta',
        ];
      case HollandType.enterprising:
        return [
          'Empresario',
          'Vendedor',
          'Abogado',
          'Gerente',
          'Político',
          'Ejecutivo',
        ];
      case HollandType.conventional:
        return [
          'Contador',
          'Secretario',
          'Analista',
          'Bibliotecario',
          'Administrador',
          'Auditor',
        ];
    }
  }

  List<String> get personalityTraits {
    switch (this) {
      case HollandType.realistic:
        return [
          'Práctico',
          'Mecánico',
          'Concreto',
          'Persistente',
          'Realista',
          'Técnico',
        ];
      case HollandType.investigative:
        return [
          'Analítico',
          'Curioso',
          'Lógico',
          'Preciso',
          'Científico',
          'Independiente',
        ];
      case HollandType.artistic:
        return [
          'Creativo',
          'Expresivo',
          'Intuitivo',
          'Original',
          'Imaginativo',
          'Sensible',
        ];
      case HollandType.social:
        return [
          'Cooperativo',
          'Empático',
          'Paciente',
          'Comunicativo',
          'Servicial',
          'Tolerante',
        ];
      case HollandType.enterprising:
        return [
          'Ambicioso',
          'Energético',
          'Dominante',
          'Persuasivo',
          'Aventurero',
          'Extrovertido',
        ];
      case HollandType.conventional:
        return [
          'Organizado',
          'Detallista',
          'Confiable',
          'Eficiente',
          'Práctico',
          'Conservador',
        ];
    }
  }
}

/// Datos del test de Holland
class HollandTestData {
  static const List<String> answerOptions = [
    'No me gusta',
    'Neutral',
    'Me gusta',
  ];

  static const List<Map<String, dynamic>> questionBlocks = [
    {
      'title': 'Bloque 1: Actividades Realistas',
      'type': HollandType.realistic,
      'questions': [
        'Armar muebles',
        'Reparar objetos eléctricos',
        'Trabajar en el jardín',
        'Construir modelos',
        'Usar herramientas manuales',
        'Trabajar con máquinas',
        'Hacer trabajos de carpintería',
        'Reparar automóviles',
        'Trabajar al aire libre',
        'Instalar equipos',
      ],
    },
    {
      'title': 'Bloque 2: Actividades Investigativas',
      'type': HollandType.investigative,
      'questions': [
        'Resolver problemas matemáticos',
        'Leer sobre ciencia',
        'Hacer experimentos',
        'Analizar datos',
        'Estudiar fenómenos naturales',
        'Investigar temas complejos',
        'Usar computadoras para análisis',
        'Leer artículos científicos',
        'Resolver acertijos',
        'Estudiar el comportamiento humano',
      ],
    },
    {
      'title': 'Bloque 3: Actividades Artísticas',
      'type': HollandType.artistic,
      'questions': [
        'Pintar o dibujar',
        'Tocar un instrumento musical',
        'Escribir historias o poemas',
        'Diseñar ropa',
        'Actuar en obras de teatro',
        'Crear artesanías',
        'Fotografiar paisajes',
        'Decorar espacios',
        'Bailar',
        'Crear videos o películas',
      ],
    },
    {
      'title': 'Bloque 4: Actividades Sociales',
      'type': HollandType.social,
      'questions': [
        'Enseñar a otros',
        'Ayudar a personas con problemas',
        'Trabajar en grupos',
        'Organizar actividades comunitarias',
        'Cuidar niños',
        'Dar consejos a amigos',
        'Participar en voluntariado',
        'Mediar en conflictos',
        'Trabajar con personas mayores',
        'Organizar eventos sociales',
      ],
    },
    {
      'title': 'Bloque 5: Actividades Emprendedoras',
      'type': HollandType.enterprising,
      'questions': [
        'Vender productos',
        'Dirigir un equipo',
        'Organizar eventos',
        'Hacer presentaciones',
        'Negociar acuerdos',
        'Planificar estrategias',
        'Motivar a otros',
        'Tomar decisiones importantes',
        'Competir en concursos',
        'Iniciar nuevos proyectos',
      ],
    },
    {
      'title': 'Bloque 6: Actividades Convencionales',
      'type': HollandType.conventional,
      'questions': [
        'Organizar archivos',
        'Llevar registros detallados',
        'Usar hojas de cálculo',
        'Seguir procedimientos establecidos',
        'Trabajar con números',
        'Mantener orden en el trabajo',
        'Procesar información',
        'Cumplir con fechas límite',
        'Revisar documentos',
        'Trabajar con sistemas informáticos',
      ],
    },
  ];

  static int get totalQuestions {
    return questionBlocks.fold(
      0,
      (sum, block) => sum + (block['questions'] as List).length,
    );
  }

  static HollandType? getQuestionType(String questionId) {
    final parts = questionId.split('_');
    if (parts.length >= 2) {
      final blockIndex = int.tryParse(parts[0]);
      if (blockIndex != null && blockIndex < questionBlocks.length) {
        return questionBlocks[blockIndex]['type'] as HollandType;
      }
    }
    return null;
  }

  static String getQuestionId(int blockIndex, int questionIndex) {
    return '${blockIndex}_$questionIndex';
  }
}
