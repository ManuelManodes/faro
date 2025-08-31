import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_header_controller.dart';
import '../controllers/attendance_list_controller.dart';
import '../controllers/assistant_header_controller.dart';
import '../controllers/incident_form_controller.dart';
import 'attendance_table_widget.dart';
import 'assistant_chat_widget.dart';
import 'incident_form_widget.dart';
import 'common/common.dart';
import '../../domain/entities/incident.dart';

/// Widget ultra-simplificado para máxima velocidad
class UltraSimplifiedViewWidget extends StatelessWidget {
  final String title;

  const UltraSimplifiedViewWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        // Control de Asistencia
        if (title == 'Control de Asistencia') {
          return _buildAttendanceView(isDarkMode);
        }

        // Asistente Virtual
        if (title == 'Asistente Virtual') {
          return _buildAssistantView(isDarkMode);
        }

        // Formulario de Incidencias
        if (title == 'Formulario de Incidencias') {
          return _buildIncidentFormView(isDarkMode);
        }

        // Otras vistas - ultra simple
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
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                  const Spacer(),
                  _buildAttendanceControls(),
                ],
              ),
            ),
          ),
          // Contenido de la tabla
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tabla de estudiantes
                      AttendanceTableWidget(level: '1ero Básico', course: 'A'),
                      AppSpacing.lgV,
                      // Botones de acción
                      _buildActionButtons(),
                    ],
                  ),
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
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                  const Spacer(),
                  _buildAssistantControls(),
                ],
              ),
            ),
          ),
          // Contenido del chat
          const Expanded(child: AssistantChatWidget()),
        ],
      ),
    );
  }

  Widget _buildIncidentFormView(bool isDarkMode) {
    return ChangeNotifierProvider(
      create: (context) => IncidentFormController(),
      child: Container(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(isDarkMode),
                      ),
                    ),
                    const Spacer(),
                    _buildIncidentFormControls(),
                  ],
                ),
              ),
            ),
            // Contenido del formulario
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const IncidentFormWidget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleView(bool isDarkMode) {
    return Container(
      color: AppColors.backgroundPrimary(isDarkMode),
      child: Column(
        children: [
          // Header con el mismo estilo que las otras vistas
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                  const Spacer(),
                  // Espacio para futuros controles si se necesitan
                ],
              ),
            ),
          ),
          // Contenido simple
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
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vista en desarrollo',
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
            _buildDateSelector(context, controller),
            const SizedBox(width: 12),
            _buildLevelSelector(context, controller),
            const SizedBox(width: 12),
            _buildCourseSelector(context, controller),
          ],
        );
      },
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showDatePicker(context, controller),
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
      },
    );
  }

  Widget _buildLevelSelector(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showLevelSelector(context, controller),
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
      },
    );
  }

  Widget _buildCourseSelector(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showCourseSelector(context, controller),
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
      },
    );
  }

  Widget _buildAssistantControls() {
    return Consumer<AssistantHeaderController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            _buildDocumentSelector(context, controller),
            const SizedBox(width: 12),
            _buildModelSelector(context, controller),
          ],
        );
      },
    );
  }

  Widget _buildDocumentSelector(
    BuildContext context,
    AssistantHeaderController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showDocumentSelector(context, controller),
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
                  Icons.description,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.xsH,
                Text(
                  controller.selectedDocument,
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
      },
    );
  }

  Widget _buildModelSelector(
    BuildContext context,
    AssistantHeaderController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showModelSelector(context, controller),
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
      },
    );
  }

  Widget _buildIncidentFormControls() {
    return Consumer<IncidentFormController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            _buildIncidentDateSelector(context, controller),
            const SizedBox(width: 12),
            _buildIncidentSeveritySelector(context, controller),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface(
                  Theme.of(context).brightness == Brightness.dark,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.dividerTheme(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  AppSnackBar.showInfo(
                    context,
                    'Formulario de incidencias educacionales mejorado',
                  );
                },
                icon: Icon(
                  Icons.info_outline,
                  color: AppColors.iconSecondary(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                  size: 20,
                ),
                tooltip: 'Información',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIncidentDateSelector(
    BuildContext context,
    IncidentFormController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showIncidentDatePicker(context, controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.shouldShowFieldError('incidentDate')
                    ? AppColors.error
                    : AppColors.dividerTheme(isDarkMode),
              ),
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
                  '${controller.incidentDate.day}/${controller.incidentDate.month}/${controller.incidentDate.year}',
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
      },
    );
  }

  Widget _buildIncidentSeveritySelector(
    BuildContext context,
    IncidentFormController controller,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return GestureDetector(
          onTap: () => _showIncidentSeveritySelector(context, controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.shouldShowFieldError('severity')
                    ? AppColors.error
                    : AppColors.dividerTheme(isDarkMode),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.priority_high,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.xsH,
                Text(
                  controller.severity?.displayName ?? 'Severidad',
                  style: TextStyle(
                    color: controller.severity != null
                        ? AppColors.textPrimary(isDarkMode)
                        : AppColors.textSecondary(isDarkMode),
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
      },
    );
  }

  void _showIncidentDatePicker(
    BuildContext context,
    IncidentFormController controller,
  ) async {
    final date = await AppDatePicker.show(
      context: context,
      initialDate: controller.incidentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (date != null) {
      controller.setIncidentDate(date);
    }
  }

  void _showIncidentSeveritySelector(
    BuildContext context,
    IncidentFormController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            'Seleccionar Severidad',
            style: TextStyle(
              color: AppColors.textPrimary(isDarkMode),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.surface(isDarkMode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: IncidentSeverity.values.map((severity) {
              return ListTile(
                leading: _getSeverityIcon(severity),
                title: Text(
                  severity.displayName,
                  style: TextStyle(
                    color: AppColors.textPrimary(isDarkMode),
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  controller.setSeverity(severity);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.textSecondary(isDarkMode)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getSeverityIcon(IncidentSeverity severity) {
    switch (severity) {
      case IncidentSeverity.low:
        return Icon(Icons.circle, size: 16, color: Colors.green);
      case IncidentSeverity.medium:
        return Icon(Icons.circle, size: 16, color: Colors.orange);
      case IncidentSeverity.high:
        return Icon(Icons.circle, size: 16, color: Colors.red);
      case IncidentSeverity.critical:
        return Icon(Icons.warning, size: 16, color: Colors.red);
    }
  }

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
                    primary: const Color(
                      0xFF2A2A2A,
                    ), // Fondo de fecha seleccionada más suave
                    onPrimary: Colors.white.withValues(
                      alpha: 0.9,
                    ), // Texto sobre fecha seleccionada más suave
                    surface: const Color(
                      0xFF1E1E1E,
                    ), // Fondo del calendario más suave
                    onSurface: Colors.white.withValues(
                      alpha: 0.87,
                    ), // Texto principal más suave
                    onSurfaceVariant: Colors.white.withValues(
                      alpha: 0.6,
                    ), // Texto secundario más suave
                    outline: Colors.white.withValues(
                      alpha: 0.12,
                    ), // Bordes más suaves
                    outlineVariant: Colors.white.withValues(
                      alpha: 0.08,
                    ), // Bordes secundarios más suaves
                    secondary: const Color(
                      0xFF2A2A2A,
                    ), // Color secundario más suave
                    onSecondary: Colors.white.withValues(
                      alpha: 0.9,
                    ), // Texto sobre secundario más suave
                  )
                : ColorScheme.light(
                    primary: AppColors.surface(
                      isDarkMode,
                    ), // Fondo de fecha seleccionada
                    onPrimary: AppColors.textPrimary(
                      isDarkMode,
                    ), // Texto sobre fecha seleccionada
                    surface: AppColors.backgroundPrimary(
                      isDarkMode,
                    ), // Fondo del calendario
                    onSurface: AppColors.textPrimary(
                      isDarkMode,
                    ), // Texto principal del calendario
                    onSurfaceVariant: AppColors.textSecondary(
                      isDarkMode,
                    ), // Texto secundario
                    outline: AppColors.dividerTheme(isDarkMode), // Bordes
                    outlineVariant: AppColors.dividerTheme(
                      isDarkMode,
                    ), // Bordes secundarios
                    secondary: AppColors.surface(
                      isDarkMode,
                    ), // Color secundario
                    onSecondary: AppColors.textPrimary(
                      isDarkMode,
                    ), // Texto sobre secundario
                  ),
            dialogTheme: DialogThemeData(
              backgroundColor: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : AppColors.backgroundPrimary(isDarkMode),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary(isDarkMode),
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        controller.setDate(date);
      }
    });
  }

  void _showLevelSelector(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
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

  void _showCourseSelector(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
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

  void _showDocumentSelector(
    BuildContext context,
    AssistantHeaderController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Documento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AssistantHeaderController.availableDocuments.map((
            document,
          ) {
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

  void _showModelSelector(
    BuildContext context,
    AssistantHeaderController controller,
  ) {
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

  Widget _buildActionButtons() {
    return Consumer2<ThemeProvider, AttendanceListController>(
      builder: (context, themeProvider, controller, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Información de ausencias
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
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
                      AppSnackBar.showSuccess(
                        context,
                        'Asistencia guardada exitosamente - $absentCount ausencias registradas',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
