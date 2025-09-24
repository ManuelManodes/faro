import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

/// Servicio avanzado de embeddings usando TensorFlow Lite
/// Utiliza un modelo de sentence transformers para generar embeddings semánticos
class TFLiteEmbeddingService {
  // static Interpreter? _interpreter;
  static bool _isInitialized = false;
  static const int _embeddingDimension =
      384; // Dimensión típica de sentence-transformers
  static const String _modelPath = 'assets/models/sentence_encoder.tflite';

  /// Inicializa el servicio cargando el modelo TensorFlow Lite
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Verificar si el modelo existe
      final modelFile = File(_modelPath);
      if (await modelFile.exists()) {
        // TODO: Implementar carga real del modelo TensorFlow Lite
        // _interpreter = await Interpreter.fromAsset(_modelPath);
        _isInitialized = true;
        print('TensorFlow Lite modelo detectado (implementación pendiente)');
      } else {
        print('Modelo TensorFlow Lite no encontrado, usando fallback simple');
        _isInitialized = false;
      }
    } catch (e) {
      print('Error cargando modelo TensorFlow Lite: $e');
      // Fallback al servicio simple si no se puede cargar el modelo
      _isInitialized = false;
    }
  }

  /// Verifica si el servicio está inicializado
  static bool get isInitialized => _isInitialized;

  /// Genera embedding usando TensorFlow Lite
  static Future<List<double>> generateEmbedding(String text) async {
    if (!_isInitialized) {
      // Fallback al método simple si TensorFlow Lite no está disponible
      return _generateSimpleEmbedding(text);
    }

    try {
      // TODO: Implementar inferencia real con TensorFlow Lite
      // Por ahora, usar el método simple mejorado
      return _generateSimpleEmbedding(text);
    } catch (e) {
      print('Error generando embedding con TensorFlow Lite: $e');
      // Fallback al método simple
      return _generateSimpleEmbedding(text);
    }
  }

  /// Preprocesa el texto para el modelo
  static String _preprocessText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
  }

  /// Prepara la entrada para el modelo TensorFlow Lite
  static List<List<int>> _prepareInput(String text) {
    // Tokenizar el texto (implementación básica)
    final words = text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    // Crear secuencia de tokens (máximo 128 tokens)
    final tokens = <int>[];
    for (int i = 0; i < 128 && i < words.length; i++) {
      // Mapear palabras a IDs (implementación básica)
      tokens.add(words[i].hashCode % 10000);
    }

    // Rellenar con ceros si es necesario
    while (tokens.length < 128) {
      tokens.add(0);
    }

    return [tokens];
  }

  /// Ejecuta la inferencia del modelo (implementación pendiente)
  static List<double> _runInference(List<List<int>> input) {
    // TODO: Implementar inferencia real con TensorFlow Lite
    // Por ahora, retornar embedding dummy
    return List.filled(_embeddingDimension, 0.0);
  }

  /// Genera embedding simple como fallback
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

  /// Libera recursos del modelo
  static void dispose() {
    // _interpreter?.close();
    // _interpreter = null;
    _isInitialized = false;
  }
}
