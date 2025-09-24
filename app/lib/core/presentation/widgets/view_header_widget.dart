import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_header_controller.dart';
import 'attendance_table_widget.dart';
import 'assistant_chat_widget.dart';
import 'common/common.dart';

/// Widget que muestra el título actual seleccionado en la navegación y un
/// espacio para controlar elementos específicos de la vista (placeholders).
class ViewHeaderWidget extends StatefulWidget {
  final String title;

  const ViewHeaderWidget({super.key, required this.title});

  @override
  State<ViewHeaderWidget> createState() => _ViewHeaderWidgetState();
}

class _ViewHeaderWidgetState extends State<ViewHeaderWidget> {
  Widget _buildViewControls() {
    // Si el título es "Control de Asistencia", mostrar controles específicos
    if (widget.title == 'Control de Asistencia') {
      return _buildAttendanceControls();
    }

    // Si el título es "Asistente Virtual", mostrar controles específicos
    if (widget.title == 'Asistente Virtual') {
      return _buildAssistantControls();
    }

    // Para otras vistas, mostrar controles genéricos
    return _buildGenericControls();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          color: AppColors.backgroundPrimary(isDarkMode),
          child: Column(
            children: [
              // Header con título y controles
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDarkMode),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.dividerTheme(isDarkMode),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Título de la vista
                    Row(
                      children: [
                        Icon(
                          _getViewIcon(),
                          color: AppColors.iconPrimary(isDarkMode),
                          size: 24,
                        ),
                        AppSpacing.mdH,
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(isDarkMode),
                          ),
                        ),
                        const Spacer(),
                        // Botón de información
                        IconButton(
                          onPressed: () => _showInfoDialog(context, isDarkMode),
                          icon: Icon(
                            Icons.info_outline,
                            color: AppColors.iconSecondary(isDarkMode),
                            size: 20,
                          ),
                          tooltip: 'Información de la vista',
                        ),
                      ],
                    ),
                    AppSpacing.mdV,
                    // Controles específicos de la vista
                    _buildViewControls(),
                  ],
                ),
              ),

              // Contenido expandido
              Expanded(child: _buildViewContent(context, isDarkMode)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewContent(BuildContext context, bool isDarkMode) {
    // Contenido expandido para Control de Asistencia
    if (widget.title == 'Control de Asistencia') {
      return const AttendanceTableWidget(level: '1ero Básico', course: 'A');
    }

    // Contenido expandido para Asistente Virtual
    if (widget.title == 'Asistente Virtual') {
      return _buildAssistantContent(context, isDarkMode);
    }

    // Contenido expandido para Vista Independiente
    if (widget.title == 'Vista Independiente') {
      return Expanded(
        child: Center(
          child: Text(
            'Vista Independiente - Contenido personalizable',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
        ),
      );
    }

    // Contenido genérico para otras vistas
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getViewIcon(),
            size: 64,
            color: AppColors.iconSecondary(isDarkMode),
          ),
          AppSpacing.lgV,
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(isDarkMode),
            ),
          ),
          AppSpacing.smV,
          Text(
            'Contenido de la vista ${widget.title}',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericControls() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.iconSecondary(isDarkMode),
              ),
              const SizedBox(width: 8),
              Text(
                'Controles genéricos para ${widget.title}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary(isDarkMode),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceControls() {
    return Consumer2<ThemeProvider, AttendanceHeaderController>(
      builder: (context, themeProvider, controller, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return Row(
          children: [
            // Selector de fecha
            GestureDetector(
              onTap: () => _showDatePicker(context, controller),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDarkMode),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    AppSpacing.xsH,
                    Text(
                      _formatDate(controller.selectedDate),
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppSpacing.xsH,
                    Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.mdH,

            // Selector de nivel
            GestureDetector(
              onTap: () => _showLevelPicker(context, controller),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDarkMode),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    AppSpacing.xsH,
                    Text(
                      controller.selectedLevel,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppSpacing.xsH,
                    Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.mdH,

            // Selector de curso
            GestureDetector(
              onTap: () => _showCoursePicker(context, controller),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDarkMode),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.class_,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    AppSpacing.xsH,
                    Text(
                      controller.selectedCourse,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppSpacing.xsH,
                    Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }

  Widget _buildAssistantControls() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.iconSecondary(isDarkMode),
              ),
              const SizedBox(width: 8),
              Text(
                'Vista de demostración del asistente virtual',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary(isDarkMode),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssistantContent(BuildContext context, bool isDarkMode) {
    return const AssistantChatWidget();
  }

  IconData _getViewIcon() {
    switch (widget.title) {
      case 'Control de Asistencia':
        return Icons.people;
      case 'Asistente Virtual':
        return Icons.smart_toy;
      case 'Vista Independiente':
        return Icons.widgets;
      default:
        return Icons.dashboard;
    }
  }

  void _showInfoDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(isDarkMode),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(_getViewIcon(), color: AppColors.primary),
            AppSpacing.smH,
            Text(
              widget.title,
              style: TextStyle(
                color: AppColors.textPrimary(isDarkMode),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          _getViewDescription(),
          style: TextStyle(
            color: AppColors.textSecondary(isDarkMode),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  String _getViewDescription() {
    switch (widget.title) {
      case 'Control de Asistencia':
        return 'Gestiona la asistencia de estudiantes con controles de fecha, año académico y curso.';
      case 'Asistente Virtual':
        return 'Vista de demostración del asistente virtual. La funcionalidad de IA ha sido deshabilitada.';
      case 'Vista Independiente':
        return 'Vista flexible y personalizable para contenido específico.';
      default:
        return 'Vista genérica del sistema.';
    }
  }

  // ===== MÉTODOS PARA CONTROL DE ASISTENCIA =====

  void _showDatePicker(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
                    primary: const Color(0xFF6366F1),
                    surface: const Color(0xFF1F2937),
                  )
                : ColorScheme.light(
                    primary: const Color(0xFF6366F1),
                    surface: Colors.white,
                  ),
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        controller.setDate(selectedDate);
      }
    });
  }

  void _showLevelPicker(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 20,
                      color: AppColors.iconPrimary(isDarkMode),
                    ),
                    AppSpacing.smH,
                    Text(
                      'Nivel Escolar',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.iconSecondary(isDarkMode),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                // Lista de niveles
                ...AttendanceHeaderController.availableLevels.map((level) {
                  final isSelected = level == controller.selectedLevel;
                  return GestureDetector(
                    onTap: () {
                      controller.setLevel(level);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 1)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 16,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.iconSecondary(isDarkMode),
                          ),
                          AppSpacing.smH,
                          Expanded(
                            child: Text(
                              level,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary(isDarkMode),
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCoursePicker(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Row(
                  children: [
                    Icon(
                      Icons.class_,
                      size: 20,
                      color: AppColors.iconPrimary(isDarkMode),
                    ),
                    AppSpacing.smH,
                    Text(
                      'Curso',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.iconSecondary(isDarkMode),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                // Lista de cursos
                ...AttendanceHeaderController.availableCourses.map((course) {
                  final isSelected = course == controller.selectedCourse;
                  return GestureDetector(
                    onTap: () {
                      controller.setCourse(course);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 1)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.class_,
                            size: 16,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.iconSecondary(isDarkMode),
                          ),
                          AppSpacing.smH,
                          Expanded(
                            child: Text(
                              course,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary(isDarkMode),
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
