import 'dart:math';

/// Entidad que representa una sección del reglamento interno
class ReglamentoSection {
  final String id;
  final String title;
  final String content;
  final List<double> embedding;
  final String sectionType;

  ReglamentoSection({
    required this.id,
    required this.title,
    required this.content,
    required this.embedding,
    required this.sectionType,
  });

  /// Calcula la similitud coseno con otro embedding
  double calculateSimilarity(List<double> otherEmbedding) {
    if (embedding.length != otherEmbedding.length) return 0.0;

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < embedding.length; i++) {
      dotProduct += embedding[i] * otherEmbedding[i];
      normA += embedding[i] * embedding[i];
      normB += otherEmbedding[i] * otherEmbedding[i];
    }

    if (normA == 0.0 || normB == 0.0) return 0.0;

    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'embedding': embedding,
      'sectionType': sectionType,
    };
  }

  factory ReglamentoSection.fromJson(Map<String, dynamic> json) {
    return ReglamentoSection(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      embedding: List<double>.from(json['embedding']),
      sectionType: json['sectionType'],
    );
  }
}
