import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_header_controller.dart';
import '../controllers/assistant_header_controller.dart';
import 'attendance_table_widget.dart';
import 'assistant_chat_widget.dart';
import 'common/common.dart';

/// Widget simplificado que maneja solo Control de Asistencia y Asistente Virtual
class SimplifiedViewHeaderWidget extends StatefulWidget {
  final String title;

  const SimplifiedViewHeaderWidget({super.key, required this.title});

  @override
  State<SimplifiedViewHeaderWidget> createState() => _SimplifiedViewHeaderWidgetState();
}

class _SimplifiedViewHeaderWidgetState extends State<SimplifiedViewHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        // Para Control de Asistencia, usar layout especializado
        if (widget.title == 'Control de Asistencia') {
          return _buildAttendanceView(isDarkMode);
        }

        // Para Asistente Virtual, usar layout especializado
        if (widget.title == 'Asistente Virtual') {
          return _buildAssistantView(isDarkMode);
        }

        // Para otras vistas, usar layout simple
        return _buildSimpleView(isDarkMode);
      },
    );
  }

  Widget _buildAttendanceView(bool isDarkMode) {
    return Container(
      color: AppColors.backgroundPrimary(isDarkMode),
      child: Column(
        children: [
          // Header con controles
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerTheme(isDarkMode),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAttendanceControls(),
                ],
              ),
            ),
          ),
          // Contenido de la tabla
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: const AttendanceTableWidget(
                  level: '1ero Básico',
                  course: 'A',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantView(bool isDarkMode) {
    return Container(
      color: AppColors.backgroundPrimary(isDarkMode),
      child: Column(
        children: [
          // Header con controles
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerTheme(isDarkMode),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAssistantControls(),
                ],
              ),
            ),
          ),
          // Contenido del chat
          const Expanded(
            child: AssistantChatWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleView(bool isDarkMode) {
    return Container(
      color: AppColors.backgroundPrimary(isDarkMode),
      child: Column(
        children: [
          // Header simple
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerTheme(isDarkMode),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(isDarkMode),
                ),
              ),
            ),
          ),
          // Contenido por defecto
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard,
                    size: 64,
                    color: AppColors.textSecondary(isDarkMode),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vista: ${widget.title}',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usa el sistema flexible para agregar contenido',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary(isDarkMode),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceControls() {
    return Consumer<AttendanceHeaderController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            // Selector de fecha
            Expanded(
              child: AppCard.outlined(
                child: InkWell(
                  onTap: () => _showDatePicker(context, controller),
                  borderRadius: AppBorderRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(controller.getFormattedDate()),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Selector de año
            Expanded(
              child: AppCard.outlined(
                child: InkWell(
                  onTap: () => _showYearSelector(context, controller),
                  borderRadius: AppBorderRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.school, size: 16),
                        const SizedBox(width: 8),
                        Text(controller.selectedLevel),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Selector de curso
            Expanded(
              child: AppCard.outlined(
                child: InkWell(
                  onTap: () => _showCourseSelector(context, controller),
                  borderRadius: AppBorderRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.class_, size: 16),
                        const SizedBox(width: 8),
                        Text(controller.selectedCourse),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAssistantControls() {
    return Consumer<AssistantHeaderController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            // Selector de documento
            Expanded(
              child: AppCard.outlined(
                child: InkWell(
                  onTap: () => _showDocumentSelector(context, controller),
                  borderRadius: AppBorderRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.description, size: 16),
                        const SizedBox(width: 8),
                        Text(controller.selectedDocument),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Selector de modelo
            Expanded(
              child: AppCard.outlined(
                child: InkWell(
                  onTap: () => _showModelSelector(context, controller),
                  borderRadius: AppBorderRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.psychology, size: 16),
                        const SizedBox(width: 8),
                        Text(controller.selectedModel),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, AttendanceHeaderController controller) {
    showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((date) {
      if (date != null) {
        controller.setDate(date);
      }
    });
  }

  void _showYearSelector(BuildContext context, AttendanceHeaderController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Nivel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AttendanceHeaderController.availableLevels.map((level) {
            return ListTile(
              title: Text(level),
              onTap: () {
                controller.setLevel(level);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCourseSelector(BuildContext context, AttendanceHeaderController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Curso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AttendanceHeaderController.availableCourses.map((course) {
            return ListTile(
              title: Text(course),
              onTap: () {
                controller.setCourse(course);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDocumentSelector(BuildContext context, AssistantHeaderController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Documento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AssistantHeaderController.availableDocuments.map((document) {
            return ListTile(
              title: Text(document),
              onTap: () {
                controller.setDocument(document);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showModelSelector(BuildContext context, AssistantHeaderController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Modelo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AssistantHeaderController.availableModels.map((model) {
            return ListTile(
              title: Text(model),
              onTap: () {
                controller.setModel(model);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
