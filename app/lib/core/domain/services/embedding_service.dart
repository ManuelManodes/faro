import 'dart:math';
import 'package:flutter/services.dart';
import '../entities/reglamento_section.dart';
import 'tflite_embedding_service.dart';

/// Servicio para generar embeddings usando TensorFlow Lite
/// Utiliza un modelo de sentence transformers para embeddings semánticos avanzados
class EmbeddingService {
  static const int _embeddingDimension =
      384; // Dimensión de sentence-transformers
  static bool _tfliteInitialized = false;

  /// Inicializa TensorFlow Lite si está disponible
  static Future<void> initializeTFLite() async {
    if (!_tfliteInitialized) {
      await TFLiteEmbeddingService.initialize();
      _tfliteInitialized = TFLiteEmbeddingService.isInitialized;
    }
  }

  /// Genera un embedding usando TensorFlow Lite o fallback simple
  static Future<List<double>> generateEmbedding(String text) async {
    // Intentar usar TensorFlow Lite si está disponible
    if (_tfliteInitialized && TFLiteEmbeddingService.isInitialized) {
      return await TFLiteEmbeddingService.generateEmbedding(text);
    }

    // Fallback al método simple
    return _generateSimpleEmbedding(text);
  }

  /// Genera un embedding simple como fallback
  static List<double> _generateSimpleEmbedding(String text) {
    final normalizedText = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();

    final words = normalizedText
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    final embedding = List<double>.filled(_embeddingDimension, 0.0);

    // Generar embedding basado en características del texto
    for (int i = 0; i < _embeddingDimension; i++) {
      double value = 0.0;

      // Características basadas en palabras clave
      for (final word in words) {
        final hash = word.hashCode;
        final seed = (hash + i) % _embeddingDimension;
        value += sin(seed * 0.1) * word.length * 0.01;
      }

      // Características basadas en longitud y estructura
      value += sin(i * 0.1) * normalizedText.length * 0.001;
      value += cos(i * 0.2) * words.length * 0.01;

      embedding[i] = value;
    }

    // Normalizar el vector
    return _normalizeVector(embedding);
  }

  /// Normaliza un vector para que tenga magnitud 1
  static List<double> _normalizeVector(List<double> vector) {
    double magnitude = 0.0;
    for (final value in vector) {
      magnitude += value * value;
    }
    magnitude = sqrt(magnitude);

    if (magnitude == 0.0) return vector;

    return vector.map((value) => value / magnitude).toList();
  }

  /// Procesa el reglamento completo y lo divide en secciones
  static Future<List<ReglamentoSection>> processReglamento() async {
    // Inicializar TensorFlow Lite si está disponible
    await initializeTFLite();

    // Cargar el reglamento desde assets
    final reglamentoText = await rootBundle.loadString(
      'assets/reglamento_interno.md',
    );

    // Dividir en secciones basadas en los títulos
    final sections = <ReglamentoSection>[];
    final lines = reglamentoText.split('\n');

    String currentTitle = '';
    String currentContent = '';
    int sectionIndex = 0;

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Detectar títulos (líneas que empiezan con ##)
      if (trimmedLine.startsWith('##')) {
        // Guardar sección anterior si existe
        if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
          sections.add(
            await _createSection(
              sectionIndex++,
              currentTitle,
              currentContent.trim(),
            ),
          );
        }

        // Iniciar nueva sección
        currentTitle = trimmedLine.replaceFirst('##', '').trim();
        currentContent = '';
      } else if (trimmedLine.isNotEmpty && currentTitle.isNotEmpty) {
        currentContent += '$trimmedLine\n';
      }
    }

    // Agregar la última sección
    if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
      sections.add(
        await _createSection(
          sectionIndex++,
          currentTitle,
          currentContent.trim(),
        ),
      );
    }

    return sections;
  }

  /// Crea una sección del reglamento con su embedding
  static Future<ReglamentoSection> _createSection(
    int index,
    String title,
    String content,
  ) async {
    final fullText = '$title: $content';
    final embedding = await generateEmbedding(fullText);

    return ReglamentoSection(
      id: 'section_$index',
      title: title,
      content: content,
      embedding: embedding,
      sectionType: _getSectionType(title),
    );
  }

  /// Determina el tipo de sección basado en el título
  static String _getSectionType(String title) {
    final lowerTitle = title.toLowerCase();

    if (lowerTitle.contains('derechos')) return 'derechos';
    if (lowerTitle.contains('deberes')) return 'deberes';
    if (lowerTitle.contains('asistencia')) return 'asistencia';
    if (lowerTitle.contains('disciplina')) return 'disciplina';
    if (lowerTitle.contains('instalaciones')) return 'instalaciones';
    if (lowerTitle.contains('actividades')) return 'actividades';
    if (lowerTitle.contains('quejas')) return 'quejas';
    if (lowerTitle.contains('normas')) return 'normas';

    return 'general';
  }
}
