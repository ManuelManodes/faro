import 'package:flutter/material.dart';

import 'flexible_view_widget.dart';
import 'attendance_table_widget.dart';
import 'assistant_chat_widget.dart';
import 'common/common.dart';

/// Fábrica de vistas que permite crear vistas dinámicamente
/// basadas en el tipo de vista solicitada
class ViewFactory {
  /// Crea una vista basada en el tipo especificado
  static Widget createView({
    required String viewType,
    required String title,
    Map<String, dynamic>? parameters,
  }) {
    switch (viewType) {
      case 'attendance':
        return _createAttendanceView(title, parameters);
      case 'assistant':
        return _createAssistantView(title, parameters);
      case 'flexible':
        return _createFlexibleView(title, parameters);
      default:
        return _createDefaultView(title);
    }
  }

  /// Crea vista de control de asistencia
  static Widget _createAttendanceView(String title, Map<String, dynamic>? parameters) {
    return FlexibleViewWidget(
      title: title,
      headerControls: _buildAttendanceControls(),
      content: const AttendanceTableWidget(
        level: '1ero Básico',
        course: 'A',
      ),
    );
  }

  /// Crea vista de asistente virtual
  static Widget _createAssistantView(String title, Map<String, dynamic>? parameters) {
    return FlexibleViewWidget(
      title: title,
      headerControls: _buildAssistantControls(),
      content: const AssistantChatWidget(),
    );
  }

  /// Crea vista flexible genérica
  static Widget _createFlexibleView(String title, Map<String, dynamic>? parameters) {
    final children = parameters?['children'] as List<Widget>? ?? [];
    
    return FlexibleViewWidget(
      title: title,
      children: children,
      headerControls: parameters?['headerControls'] as Widget?,
    );
  }

  /// Crea vista por defecto
  static Widget _createDefaultView(String title) {
    return FlexibleViewWidget(
      title: title,
      children: [
        AppCard.elevated(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vista: $title',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Esta es una vista por defecto. Usa ViewFactory.createView() para crear vistas específicas.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Construye controles de asistencia
  static Widget _buildAttendanceControls() {
    return Row(
      children: [
        // Selector de fecha
        Expanded(
          child: AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  const Text('25/12/2024'),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Selector de año
        Expanded(
          child: AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 16),
                  const SizedBox(width: 8),
                  const Text('2024'),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Selector de curso
        Expanded(
          child: AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.class_, size: 16),
                  const SizedBox(width: 8),
                  const Text('A'),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye controles de asistente
  static Widget _buildAssistantControls() {
    return Row(
      children: [
        // Selector de documento
        Expanded(
          child: AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.description, size: 16),
                  const SizedBox(width: 8),
                  const Text('Seleccionar documento'),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Selector de modelo
        Expanded(
          child: AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.psychology, size: 16),
                  const SizedBox(width: 8),
                  const Text('GPT-4'),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
