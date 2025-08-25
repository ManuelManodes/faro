import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_header_controller.dart';
import '../controllers/attendance_list_controller.dart';
import '../controllers/assistant_header_controller.dart';
import '../controllers/assistant_chat_controller.dart';
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

class _ViewHeaderWidgetState extends State<ViewHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildViewControls() {
    // Si el título es "Control de Asistencia", mostrar controles específicos
    if (widget.title == 'Control de Asistencia') {
      return _buildAttendanceControls();
    }

    // Si el título es "Asistente Virtual", mostrar controles específicos
    if (widget.title == 'Asistente Virtual') {
      return _buildAssistantControls();
    }

    return Row(
      children: [
        // Ejemplo: botones de acciones de la vista
        AppSpacing.mdH,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);
        final isDarkMode = themeProvider.isDarkMode;

        // Para Control de Asistencia, usar layout especializado
        if (widget.title == 'Control de Asistencia') {
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
                  height: 80,
                  child: FigmaGridContainer(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary(isDarkMode),
                          ),
                        ),
                        const Spacer(),
                        _buildViewControls(),
                      ],
                    ),
                  ),
                ),
                // Contenido de asistencia expandido
                Expanded(child: _buildAttendanceContent(context, isDarkMode)),
              ],
            ),
          );
        }

        // Layout normal para otras vistas
        return Column(
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
              height: 80,
              child: FigmaGridContainer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary(isDarkMode),
                      ),
                    ),
                    const Spacer(),
                    _buildViewControls(),
                  ],
                ),
              ),
            ),
            // Contenido expandido para Asistente Virtual
            if (widget.title == 'Asistente Virtual')
              Expanded(child: _buildAssistantContent(context, isDarkMode)),
          ],
        );
      },
    );
  }

  Widget _buildAttendanceContent(BuildContext context, bool isDarkMode) {
    return Consumer2<AttendanceHeaderController, AttendanceListController>(
      builder: (context, headerController, listController, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabla de estudiantes
                  AttendanceTableWidget(
                    level: headerController.selectedLevel,
                    course: headerController.selectedCourse,
                  ),
                  AppSpacing.lgV,
                  // Botones de acción
                  _buildActionButtons(context, isDarkMode, listController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isDarkMode,
    AttendanceListController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de ausencias
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.smH,
                Text(
                  '${controller.absentStudentIds.length} ausencias marcadas',
                  style: TextStyle(
                    color: AppColors.textSecondary(isDarkMode),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Botones de acción
          Row(
            children: [
              AppButton.surface(
                text: 'Limpiar Todo',
                onPressed: controller.clearAbsences,
              ),
              AppSpacing.lgH,
              AppButton.elegantGreen(
                text: 'Guardar Asistencia',
                onPressed: () {
                  // Contar las ausencias antes de limpiar
                  final absentCount = controller.absentStudentIds.length;

                  // TODO: Implementar guardado de asistencia en Firebase

                  // Limpiar las ausencias después de guardar
                  controller.clearAbsences();

                  // Mostrar mensaje de confirmación
                  _showElegantSnackBar(
                    context,
                    isDarkMode,
                    'Asistencia guardada exitosamente',
                    '$absentCount ausencias registradas',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceControls() {
    return Consumer2<ThemeProvider, AttendanceHeaderController>(
      builder: (context, themeProvider, attendanceController, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Row(
          children: [
            // Selector de Fecha
            _buildDateSelector(context, isDarkMode, attendanceController),
            AppSpacing.mdH,

            // Selector de Nivel Escolar
            _buildLevelSelector(context, isDarkMode, attendanceController),
            AppSpacing.mdH,

            // Selector de Curso
            _buildCourseSelector(context, isDarkMode, attendanceController),
          ],
        );
      },
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    bool isDarkMode,
    AttendanceHeaderController controller,
  ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          controller.setDate(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              controller.getFormattedDate(),
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
    );
  }

  Widget _buildLevelSelector(
    BuildContext context,
    bool isDarkMode,
    AttendanceHeaderController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _showLevelPicker(context, isDarkMode, controller);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }

  Widget _buildCourseSelector(
    BuildContext context,
    bool isDarkMode,
    AttendanceHeaderController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _showCoursePicker(context, isDarkMode, controller);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }

  void _showLevelPicker(
    BuildContext context,
    bool isDarkMode,
    AttendanceHeaderController controller,
  ) {
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
                // Lista de opciones
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
                          Text(
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
                          const Spacer(),
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCoursePicker(
    BuildContext context,
    bool isDarkMode,
    AttendanceHeaderController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 200,
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
                // Lista de opciones
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
                          Text(
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
                          const Spacer(),
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showElegantSnackBar(
    BuildContext context,
    bool isDarkMode,
    String title,
    String subtitle,
  ) {
    // Iniciar la animación de latido
    _pulseController.repeat(reverse: true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Icono con efecto de latido
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              AppSpacing.mdH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      AppSpacing.xsV,
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary(isDarkMode),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.surface(isDarkMode),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        elevation: 8,
      ),
    );
  }

  // ===== MÉTODOS PARA ASISTENTE VIRTUAL =====

  Widget _buildAssistantControls() {
    return Consumer2<ThemeProvider, AssistantHeaderController>(
      builder: (context, themeProvider, assistantController, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Row(
          children: [
            // Indicador de documento activo o botón para seleccionar
            if (assistantController.hasDocumentSelected) ...[
              GestureDetector(
                onTap: () => _showDocumentPicker(
                  context,
                  isDarkMode,
                  assistantController,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description,
                        size: 12,
                        color: Colors.green.shade600,
                      ),
                      AppSpacing.xsH,
                      Text(
                        assistantController.documentName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.xsH,
                      Icon(Icons.edit, size: 10, color: Colors.green.shade600),
                    ],
                  ),
                ),
              ),
              AppSpacing.mdH,
            ] else ...[
              // Botón para seleccionar documento
              GestureDetector(
                onTap: () => _showDocumentPicker(
                  context,
                  isDarkMode,
                  assistantController,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface(isDarkMode),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.dividerTheme(isDarkMode),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description,
                        size: 16,
                        color: AppColors.iconSecondary(isDarkMode),
                      ),
                      AppSpacing.xsH,
                      Text(
                        'Seleccionar documento',
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
            ],

            // Selector de Modelo de IA
            _buildModelSelector(context, isDarkMode, assistantController),
          ],
        );
      },
    );
  }

  Widget _buildModelSelector(
    BuildContext context,
    bool isDarkMode,
    AssistantHeaderController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _showModelPicker(context, isDarkMode, controller);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface(isDarkMode),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology,
              size: 16,
              color: AppColors.iconSecondary(isDarkMode),
            ),
            AppSpacing.xsH,
            Text(
              controller.selectedModel,
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
    );
  }

  void _showDocumentPicker(
    BuildContext context,
    bool isDarkMode,
    AssistantHeaderController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 320,
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
                      Icons.description,
                      size: 20,
                      color: AppColors.iconPrimary(isDarkMode),
                    ),
                    AppSpacing.smH,
                    Text(
                      'Seleccionar Documento',
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
                // Lista de documentos
                ...AssistantHeaderController.availableDocuments.map((document) {
                  final isSelected = document == controller.selectedDocument;
                  return GestureDetector(
                    onTap: () {
                      controller.setDocument(document);
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
                            Icons.description,
                            size: 16,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.iconSecondary(isDarkMode),
                          ),
                          AppSpacing.smH,
                          Expanded(
                            child: Text(
                              document,
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showModelPicker(
    BuildContext context,
    bool isDarkMode,
    AssistantHeaderController controller,
  ) {
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
                      Icons.psychology,
                      size: 20,
                      color: AppColors.iconPrimary(isDarkMode),
                    ),
                    AppSpacing.smH,
                    Text(
                      'Modelo de IA',
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
                // Lista de modelos
                ...AssistantHeaderController.availableModels.map((model) {
                  final isSelected = model == controller.selectedModel;
                  return GestureDetector(
                    onTap: () {
                      controller.setModel(model);
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
                            Icons.psychology,
                            size: 16,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.iconSecondary(isDarkMode),
                          ),
                          AppSpacing.smH,
                          Expanded(
                            child: Text(
                              model,
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssistantContent(BuildContext context, bool isDarkMode) {
    return Consumer2<AssistantHeaderController, AssistantChatController>(
      builder: (context, headerController, chatController, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: AssistantChatWidget(),
            ),
          ),
        );
      },
    );
  }
}
