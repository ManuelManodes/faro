import '../entities/reglamento_section.dart';
import 'embedding_service.dart';

/// Servicio para buscar información en el reglamento usando embeddings
class ReglamentoSearchService {
  final List<ReglamentoSection> _sections = [];
  static const double _similarityThreshold =
      0.3; // Aumentado para mayor precisión

  /// Inicializa el servicio cargando las secciones del reglamento
  Future<void> initialize() async {
    _sections.clear();
    _sections.addAll(await EmbeddingService.processReglamento());
  }

  /// Busca la sección más relevante para una pregunta
  Future<ReglamentoSearchResult> search(String question) async {
    print('DEBUG: Buscando respuesta para: "$question"');
    
    if (_sections.isEmpty) {
      await initialize();
    }

    if (_sections.isEmpty) {
      return ReglamentoSearchResult(
        found: false,
        content: 'No se pudo cargar el reglamento interno.',
        sectionTitle: '',
        similarity: 0.0,
      );
    }

    // Filtrar saludos y preguntas no relacionadas con el reglamento
    if (_isGreetingOrUnrelated(question)) {
      print('DEBUG: Detectado saludo o pregunta no relacionada');
      return ReglamentoSearchResult(
        found: true, // Cambiado a true para que se muestre la respuesta
        content:
            'Hola! Soy el asistente virtual del reglamento interno del colegio. Puedo ayudarte con información sobre normas, derechos, deberes, asistencia, disciplina y procedimientos del colegio. ¿En qué puedo ayudarte?',
        sectionTitle: 'Asistente Virtual',
        similarity: 1.0, // Máxima similitud para respuestas de presentación
      );
    }

    // Primero intentar búsqueda directa por palabras clave
    print('DEBUG: Intentando búsqueda directa...');
    final directResult = _searchDirectKeywords(question);
    if (directResult.found) {
      print('DEBUG: Búsqueda directa exitosa');
      return directResult;
    }
    print('DEBUG: Búsqueda directa no encontró resultados');

    // Luego usar embeddings para búsqueda semántica
    final questionEmbedding = await EmbeddingService.generateEmbedding(
      question,
    );

    // Buscar la sección con mayor similitud
    ReglamentoSection? bestSection;
    double bestSimilarity = 0.0;

    for (final section in _sections) {
      final similarity = section.calculateSimilarity(questionEmbedding);
      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestSection = section;
      }
    }

    // Verificar si la similitud supera el umbral
    if (bestSection == null || bestSimilarity < _similarityThreshold) {
      return ReglamentoSearchResult(
        found: false,
        content:
            'No encontré información sobre eso en el reglamento interno del colegio.',
        sectionTitle: '',
        similarity: bestSimilarity,
      );
    }

    // Formatear la respuesta
    final response = _formatResponse(bestSection, question);

    return ReglamentoSearchResult(
      found: true,
      content: response,
      sectionTitle: bestSection.title,
      similarity: bestSimilarity,
    );
  }

  /// Detecta si es un saludo o pregunta no relacionada con el reglamento
  bool _isGreetingOrUnrelated(String question) {
    final lowerQuestion = question.toLowerCase().trim();

    // Saludos comunes
    final greetings = [
      'hola',
      'hi',
      'hello',
      'buenos días',
      'buenas tardes',
      'buenas noches',
      'saludos',
      'hey',
      'qué tal',
      'cómo estás',
      'cómo te va',
    ];

    // Preguntas no relacionadas con el reglamento
    final unrelated = [
      'qué hora es',
      'qué día es',
      'qué tiempo hace',
      'cómo está el clima',
      'cuéntame un chiste',
      'qué haces',
      'cómo te llamas',
      'quién eres',
      'cuál es tu nombre',
      'de dónde eres',
      'cuántos años tienes',
    ];

    // Verificar saludos
    for (final greeting in greetings) {
      if (lowerQuestion == greeting || lowerQuestion.startsWith(greeting)) {
        return true;
      }
    }

    // Verificar preguntas no relacionadas
    for (final unrelatedPhrase in unrelated) {
      if (lowerQuestion.contains(unrelatedPhrase)) {
        return true;
      }
    }

    // Verificar si es muy corta (menos de 3 palabras) y no contiene palabras del reglamento
    final words = lowerQuestion
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.length < 3) {
      final reglamentoKeywords = [
        'colegio',
        'estudiante',
        'profesor',
        'asistencia',
        'disciplina',
        'derecho',
        'deber',
        'norma',
        'reglamento',
        'uniforme',
        'celular',
        'queja',
        'sugerencia',
        'actividad',
        'deporte',
        'cultural',
      ];

      bool hasReglamentoKeyword = false;
      for (final word in words) {
        for (final keyword in reglamentoKeywords) {
          if (word.contains(keyword) || keyword.contains(word)) {
            hasReglamentoKeyword = true;
            break;
          }
        }
        if (hasReglamentoKeyword) break;
      }

      return !hasReglamentoKeyword;
    }

    return false;
  }

  /// Búsqueda directa por palabras clave (más confiable)
  ReglamentoSearchResult _searchDirectKeywords(String question) {
    final lowerQuestion = question.toLowerCase();

    // Respuestas específicas para preguntas sobre el nombre del colegio
    if (lowerQuestion.contains('nombre') && lowerQuestion.contains('colegio')) {
      print('DEBUG: Encontrada pregunta sobre nombre del colegio');
      return ReglamentoSearchResult(
        found: true,
        content: 'El nombre del colegio es "Aldo de las cumbres italianas".',
        sectionTitle: 'Información del Colegio',
        similarity: 1.0,
      );
    }

    if (lowerQuestion.contains('cómo se llama') && lowerQuestion.contains('colegio')) {
      print('DEBUG: Encontrada pregunta "cómo se llama el colegio"');
      return ReglamentoSearchResult(
        found: true,
        content: 'El nombre del colegio es "Aldo de las cumbres italianas".',
        sectionTitle: 'Información del Colegio',
        similarity: 1.0,
      );
    }

    if (lowerQuestion.contains('cuál es el nombre') && lowerQuestion.contains('colegio')) {
      print('DEBUG: Encontrada pregunta "cuál es el nombre del colegio"');
      return ReglamentoSearchResult(
        found: true,
        content: 'El nombre del colegio es "Aldo de las cumbres italianas".',
        sectionTitle: 'Información del Colegio',
        similarity: 1.0,
      );
    }

    // Agregar más patrones de búsqueda
    if (lowerQuestion.contains('como se llama') && lowerQuestion.contains('colegio')) {
      print('DEBUG: Encontrada pregunta "como se llama el colegio" (sin acento)');
      return ReglamentoSearchResult(
        found: true,
        content: 'El nombre del colegio es "Aldo de las cumbres italianas".',
        sectionTitle: 'Información del Colegio',
        similarity: 1.0,
      );
    }

    if (lowerQuestion.contains('cual es el nombre') && lowerQuestion.contains('colegio')) {
      print('DEBUG: Encontrada pregunta "cual es el nombre del colegio" (sin acento)');
      return ReglamentoSearchResult(
        found: true,
        content: 'El nombre del colegio es "Aldo de las cumbres italianas".',
        sectionTitle: 'Información del Colegio',
        similarity: 1.0,
      );
    }

    // Búsqueda específica por palabras clave
    for (final section in _sections) {
      final lowerTitle = section.title.toLowerCase();
      final lowerContent = section.content.toLowerCase();

      // Buscar coincidencias en título y contenido
      if (_hasKeywordMatch(lowerQuestion, lowerTitle, lowerContent)) {
        return ReglamentoSearchResult(
          found: true,
          content: _formatResponse(section, question),
          sectionTitle: section.title,
          similarity: 1.0, // Máxima similitud para búsqueda directa
        );
      }
    }

    return ReglamentoSearchResult(
      found: false,
      content: '',
      sectionTitle: '',
      similarity: 0.0,
    );
  }

  /// Verifica si hay coincidencia de palabras clave
  bool _hasKeywordMatch(String question, String title, String content) {
    final keywords = question
        .split(' ')
        .where((word) => word.length > 2)
        .toList();

    for (final keyword in keywords) {
      if (title.contains(keyword) || content.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  /// Formatea la respuesta basada en la sección encontrada
  String _formatResponse(ReglamentoSection section, String question) {
    final lowerQuestion = question.toLowerCase();

    // Respuestas específicas para preguntas comunes
    if (lowerQuestion.contains('nombre') && lowerQuestion.contains('colegio')) {
      return 'El nombre del colegio es "Aldo de las cumbres italianas".';
    }

    if (lowerQuestion.contains('cómo se llama') && lowerQuestion.contains('colegio')) {
      return 'El nombre del colegio es "Aldo de las cumbres italianas".';
    }

    if (lowerQuestion.contains('cuál es el nombre') && lowerQuestion.contains('colegio')) {
      return 'El nombre del colegio es "Aldo de las cumbres italianas".';
    }

    if (lowerQuestion.contains('qué es') &&
        lowerQuestion.contains('reglamento')) {
      return 'El reglamento interno es el documento que establece las normas y procedimientos que regulan la convivencia, los derechos y deberes de los estudiantes, docentes y personal administrativo del colegio.';
    }

    if (lowerQuestion.contains('para qué sirve') &&
        lowerQuestion.contains('reglamento')) {
      return 'El reglamento interno sirve para establecer las normas de convivencia, definir los derechos y deberes de la comunidad educativa, y regular los procedimientos del colegio.';
    }

    if (lowerQuestion.contains('asistencia') ||
        lowerQuestion.contains('falta')) {
      return _getAttendanceResponse(section);
    }

    if (lowerQuestion.contains('disciplina') ||
        lowerQuestion.contains('falta')) {
      return _getDisciplineResponse(section);
    }

    if (lowerQuestion.contains('derecho')) {
      return _getRightsResponse(section);
    }

    if (lowerQuestion.contains('deber')) {
      return _getDutiesResponse(section);
    }

    if (lowerQuestion.contains('celular') ||
        lowerQuestion.contains('dispositivo')) {
      return 'El uso de dispositivos electrónicos debe limitarse a actividades educativas y bajo la supervisión de los docentes.';
    }

    if (lowerQuestion.contains('uniforme') ||
        lowerQuestion.contains('vestimenta')) {
      return 'La vestimenta debe cumplir con el uniforme oficial del colegio.';
    }

    if (lowerQuestion.contains('queja') ||
        lowerQuestion.contains('sugerencia')) {
      return 'Cualquier queja o sugerencia deberá ser presentada ante la dirección o el encargado designado. Se garantiza la confidencialidad y el tratamiento justo de cada caso.';
    }

    if (lowerQuestion.contains('actividad') ||
        lowerQuestion.contains('deportiva') ||
        lowerQuestion.contains('cultural')) {
      return 'Los estudiantes podrán participar voluntariamente en actividades deportivas, culturales y recreativas. El comportamiento durante estas actividades debe ser acorde con las normas del colegio.';
    }

    if (lowerQuestion.contains('norma') || lowerQuestion.contains('normas')) {
      return 'Las normas generales del colegio incluyen: actuar con respeto, honestidad y responsabilidad; prohibir cualquier forma de discriminación, acoso o violencia; limitar el uso de dispositivos electrónicos a actividades educativas; y cumplir con el uniforme oficial del colegio.';
    }

    if (lowerQuestion.contains('convivencia')) {
      return 'La convivencia en el colegio se basa en el respeto, honestidad y responsabilidad. Se prohíbe cualquier forma de discriminación, acoso o violencia. Todos los miembros de la comunidad educativa deben cumplir con estas normas.';
    }

    if (lowerQuestion.contains('comunidad educativa')) {
      return 'La comunidad educativa está formada por estudiantes, docentes y personal administrativo del colegio. Todos deben cumplir con el reglamento interno y actuar con respeto, honestidad y responsabilidad.';
    }

    if (lowerQuestion.contains('procedimiento') ||
        lowerQuestion.contains('procedimientos')) {
      return 'Los procedimientos del colegio incluyen: justificación de faltas por escrito, presentación de quejas ante la dirección, uso responsable de instalaciones, y cumplimiento de normas de convivencia.';
    }

    if (lowerQuestion.contains('objetivo') ||
        lowerQuestion.contains('para qué')) {
      return 'El objetivo del reglamento es establecer las normas y procedimientos que regulan la convivencia, los derechos y deberes de estudiantes, docentes y personal administrativo del colegio.';
    }

    if (lowerQuestion.contains('cumplimiento') ||
        lowerQuestion.contains('obligatorio')) {
      return 'El cumplimiento del reglamento es obligatorio para toda la comunidad educativa. El desconocimiento del reglamento no exime del cumplimiento del mismo.';
    }

    // Respuesta genérica basada en la sección
    return _summarizeContent(section.content);
  }

  String _getAttendanceResponse(ReglamentoSection section) {
    return 'La asistencia a clases es obligatoria. Las faltas deben ser justificadas por escrito por los padres o tutores, y la puntualidad es fundamental. Las ausencias injustificadas pueden tener consecuencias académicas y disciplinarias.';
  }

  String _getDisciplineResponse(ReglamentoSection section) {
    return 'Se considerará falta toda conducta que afecte la convivencia, el respeto o la seguridad de la comunidad escolar. Las medidas disciplinarias pueden incluir amonestación verbal, notificación a los padres, suspensión temporal o expulsión en casos graves.';
  }

  String _getRightsResponse(ReglamentoSection section) {
    return 'Los estudiantes tienen derecho a recibir educación de calidad en un ambiente seguro, expresar sus ideas de manera respetuosa, ser escuchados por los docentes y participar en actividades culturales y deportivas del colegio.';
  }

  String _getDutiesResponse(ReglamentoSection section) {
    return 'Los estudiantes deben asistir puntualmente a clases, cumplir con las tareas asignadas, mantener el orden y limpieza en las instalaciones, respetar a compañeros y docentes, y utilizar los recursos del colegio de manera responsable.';
  }

  /// Resume el contenido de una sección
  String _summarizeContent(String content) {
    final sentences = content
        .split('.')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    if (sentences.length <= 2) {
      return content.trim();
    }

    // Filtrar oraciones muy largas o poco relevantes
    final relevantSentences = sentences.where((sentence) {
      final trimmed = sentence.trim();
      return trimmed.length > 20 &&
          trimmed.length < 200 &&
          !trimmed.startsWith('-') &&
          !trimmed.contains('[') &&
          !trimmed.contains(']');
    }).toList();

    if (relevantSentences.isEmpty) {
      return sentences.take(2).join('. ').trim() + '.';
    }

    // Tomar las primeras 2 oraciones más relevantes
    final selectedSentences = relevantSentences.take(2).toList();
    return selectedSentences.join('. ').trim() + '.';
  }

  /// Obtiene todas las secciones disponibles
  List<ReglamentoSection> getAllSections() {
    return List.unmodifiable(_sections);
  }

  /// Obtiene secciones por tipo
  List<ReglamentoSection> getSectionsByType(String type) {
    return _sections.where((section) => section.sectionType == type).toList();
  }
}

/// Resultado de una búsqueda en el reglamento
class ReglamentoSearchResult {
  final bool found;
  final String content;
  final String sectionTitle;
  final double similarity;

  ReglamentoSearchResult({
    required this.found,
    required this.content,
    required this.sectionTitle,
    required this.similarity,
  });
}
