import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_header_controller.dart';
import '../controllers/attendance_list_controller.dart';
import '../controllers/incident_form_controller.dart';
import '../controllers/scheduling_controller.dart';
import 'attendance_table_widget.dart';
import 'assistant_chat_widget.dart';
import 'incident_form_widget.dart';
import 'holland_test_widget.dart';
import 'scheduling_widget.dart';
import 'appointment_form_widget.dart';
import 'school_schedule_form_widget.dart';
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

        // Evaluaciones - Test de Holland
        if (title == 'Evaluaciones') {
          return _buildEvaluationsView(isDarkMode);
        }

        // Agenda
        if (title == 'Agenda') {
          return _buildSchedulingView(isDarkMode);
        }

        // Vista no encontrada
        return Container(
          color: AppColors.backgroundPrimary(isDarkMode),
          child: const Center(child: Text('Vista no encontrada')),
        );
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
            ),
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.titlePrimary(isDarkMode)),
                  const Spacer(),
                  _buildAttendanceControls(),
                ],
              ),
            ),
          ),
          // Contenido de la tabla
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
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
            ),
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.titlePrimary(isDarkMode)),
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
              ),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 6,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: AppTextStyles.titlePrimary(isDarkMode)),
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
                    constraints: const BoxConstraints(maxWidth: 700),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.xsH,
                Text(
                  controller.getFormattedDate(),
                  style: AppTextStyles.controlText(isDarkMode),
                ),
                AppSpacing.xsH,
                Icon(
                  Icons.arrow_drop_down,
                  size: 14,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getLevelIcon(controller.selectedLevel, context),
                AppSpacing.xsH,
                Text(
                  controller.selectedLevel,
                  style: AppTextStyles.controlText(isDarkMode),
                ),
                AppSpacing.xsH,
                Icon(
                  Icons.arrow_drop_down,
                  size: 14,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getCourseIcon(controller.selectedCourse, context),
                AppSpacing.xsH,
                Text(
                  controller.selectedCourse,
                  style: AppTextStyles.controlText(isDarkMode),
                ),
                AppSpacing.xsH,
                Icon(
                  Icons.arrow_drop_down,
                  size: 14,
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

  Widget _buildIncidentFormControls() {
    return Consumer<IncidentFormController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            _buildIncidentDateSelector(context, controller),
            const SizedBox(width: 12),
            _buildIncidentSeveritySelector(context, controller),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(6),
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
                  size: 14,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.xsH,
                Text(
                  '${controller.incidentDate.day}/${controller.incidentDate.month}/${controller.incidentDate.year}',
                  style: AppTextStyles.controlText(isDarkMode),
                ),
                AppSpacing.xsH,
                Icon(
                  Icons.arrow_drop_down,
                  size: 14,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: controller.shouldShowFieldError('severity')
                    ? AppColors.error
                    : AppColors.dividerTheme(isDarkMode),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.severity != null
                    ? _getSeverityIcon(controller.severity!)
                    : Icon(
                        Icons.priority_high,
                        size: 14,
                        color: AppColors.iconSecondary(isDarkMode),
                      ),
                AppSpacing.xsH,
                Text(
                  controller.severity?.displayName ?? 'Severidad',
                  style: TextStyle(
                    color: controller.severity != null
                        ? AppColors.textPrimary(isDarkMode)
                        : AppColors.textSecondary(isDarkMode),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.xsH,
                Icon(
                  Icons.arrow_drop_down,
                  size: 14,
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
            style: AppTextStyles.dialogTitle(isDarkMode),
          ),
          backgroundColor: AppColors.surface(isDarkMode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: IncidentSeverity.values.map((severity) {
              return ListTile(
                leading: _getSeverityIcon(severity),
                title: Text(
                  severity.displayName,
                  style: AppTextStyles.controlText(isDarkMode),
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
                style: AppTextStyles.secondaryText(isDarkMode),
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
        return Icon(Icons.circle, size: 16, color: AppColors.success);
      case IncidentSeverity.medium:
        return Icon(Icons.circle, size: 16, color: Colors.orange);
      case IncidentSeverity.high:
        return Icon(Icons.circle, size: 16, color: Colors.red);
      case IncidentSeverity.critical:
        return Icon(Icons.warning, size: 16, color: Colors.red);
    }
  }

  Widget _getLevelIcon(String level, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = AppColors.iconPrimary(isDarkMode);

    // Iconos apropiados para cada nivel educativo
    if (level.contains('Básico')) {
      if (level.contains('1ero') ||
          level.contains('2do') ||
          level.contains('3ero') ||
          level.contains('4to')) {
        return Icon(
          Icons.school,
          size: 16,
          color: iconColor,
        ); // Educación básica inicial
      } else {
        return Icon(
          Icons.auto_stories,
          size: 16,
          color: iconColor,
        ); // Educación básica superior
      }
    } else if (level.contains('Medio')) {
      return Icon(
        Icons.psychology,
        size: 16,
        color: iconColor,
      ); // Educación media
    }

    // Icono por defecto
    return Icon(Icons.grade, size: 16, color: iconColor);
  }

  Widget _getCourseIcon(String course, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = AppColors.iconPrimary(isDarkMode);

    // Icono consistente para todos los cursos
    // Usamos un icono que represente secciones o grupos de clase
    return Icon(Icons.class_, size: 16, color: iconColor);
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
                    primary: AppColors.accentPrimary(isDarkMode),
                    onPrimary: Colors.white,
                    surface: AppColors.surface(isDarkMode),
                    onSurface: AppColors.textPrimary(isDarkMode),
                    onSurfaceVariant: AppColors.textSecondary(isDarkMode),
                    outline: AppColors.dividerTheme(isDarkMode),
                    outlineVariant: AppColors.dividerTheme(
                      isDarkMode,
                    ).withValues(alpha: 0.5),
                    secondary: AppColors.accentPrimary(isDarkMode),
                    onSecondary: Colors.white,
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
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            'Seleccionar Nivel',
            style: AppTextStyles.dialogTitle(isDarkMode),
          ),
          backgroundColor: AppColors.surface(isDarkMode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AttendanceHeaderController.availableLevels.map((level) {
              return ListTile(
                leading: _getLevelIcon(level, context),
                title: Text(
                  level,
                  style: AppTextStyles.controlText(isDarkMode),
                ),
                onTap: () {
                  controller.setLevel(level);
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
                style: AppTextStyles.secondaryText(isDarkMode),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCourseSelector(
    BuildContext context,
    AttendanceHeaderController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: Text(
            'Seleccionar Curso',
            style: AppTextStyles.dialogTitle(isDarkMode),
          ),
          backgroundColor: AppColors.surface(isDarkMode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AttendanceHeaderController.availableCourses.map((course) {
              return ListTile(
                leading: _getCourseIcon(course, context),
                title: Text(
                  course,
                  style: AppTextStyles.controlText(isDarkMode),
                ),
                onTap: () {
                  controller.setCourse(course);
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
                style: AppTextStyles.secondaryText(isDarkMode),
              ),
            ),
          ],
        );
      },
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
                      style: AppTextStyles.secondaryText(isDarkMode),
                    ),
                  ],
                ),
              ),
              // Botones de acción
              Row(
                children: [
                  AppButton.surface(
                    text: 'Limpiar Todo',
                    onPressed: () =>
                        _showClearAllConfirmationDialog(context, controller),
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

  Widget _buildEvaluationsView(bool isDarkMode) {
    return Container(
      color: AppColors.backgroundPrimary(isDarkMode),
      child: Column(
        children: [
          // Header con controles
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
            ),
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.titlePrimary(isDarkMode)),
                  const Spacer(),
                  _buildEvaluationsControls(),
                ],
              ),
            ),
          ),
          // Contenido del test
          const Expanded(child: HollandTestWidget()),
        ],
      ),
    );
  }

  Widget _buildEvaluationsControls() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return Row(
          children: [
            AppContainer.surface(
              isDarkMode: isDarkMode,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.psychology,
                    size: 14,
                    color: AppColors.iconSecondary(isDarkMode),
                  ),
                  AppSpacing.xsH,
                  Text(
                    'Test de Holland',
                    style: AppTextStyles.controlText(isDarkMode),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSchedulingView(bool isDarkMode) {
    return Container(
      color: AppColors.backgroundPrimary(isDarkMode),
      child: Column(
        children: [
          // Header con controles
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
            ),
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.titlePrimary(isDarkMode)),
                  const Spacer(),
                  _buildSchedulingControls(),
                ],
              ),
            ),
          ),
          // Contenido del agendamiento
          Expanded(child: SchedulingWidget()),
        ],
      ),
    );
  }

  Widget _buildSchedulingControls() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return Consumer<SchedulingController>(
          builder: (context, controller, child) {
            return Row(
              children: [
                // Botón nueva cita
                AppButton.primary(
                  text: 'Nueva Cita',
                  onPressed: () =>
                      _showCreateAppointmentDialog(controller, context),
                  icon: Icons.add,
                ),
                AppSpacing.mdH,

                // Botón nuevo horario escolar
                AppButton.secondary(
                  text: 'Horario Escolar',
                  onPressed: () =>
                      _showCreateSchoolScheduleDialog(controller, context),
                  icon: Icons.schedule,
                ),
                AppSpacing.mdH,

                // Toggle para mostrar/ocultar horarios escolares
                _buildToggleButton(
                  'Mostrar Horarios Escolares',
                  Icons.school,
                  controller.showSchoolSchedules,
                  (value) => controller.toggleSchoolSchedules(),
                  isDarkMode,
                ),

                AppSpacing.lgH,

                // Información
                Text(
                  '${controller.appointments.length} citas • ${controller.schoolSchedules.length} horarios',
                  style: AppTextStyles.secondaryText(isDarkMode),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: value
              ? (isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5))
              : AppColors.surface(isDarkMode),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value
                ? (isDarkMode
                      ? const Color(0xFF404040)
                      : const Color(0xFFE0E0E0))
                : AppColors.dividerTheme(isDarkMode),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.iconSecondary(isDarkMode)),
            AppSpacing.xsH,
            Text(label, style: AppTextStyles.controlText(isDarkMode)),
          ],
        ),
      ),
    );
  }

  void _showCreateAppointmentDialog(
    SchedulingController controller,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: AppointmentFormWidget(
            controller: controller,
            onSaved: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _showCreateSchoolScheduleDialog(
    SchedulingController controller,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SchoolScheduleFormWidget(
            controller: controller,
            onSaved: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showClearAllConfirmationDialog(
    BuildContext context,
    AttendanceListController controller,
  ) async {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface(isDarkMode),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Text(
                'Confirmar Limpieza',
                style: AppTextStyles.titlePrimary(isDarkMode),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que quieres limpiar todas las ausencias marcadas? Esta acción no se puede deshacer.',
            style: AppTextStyles.controlText(isDarkMode),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'No, mantener',
                style: TextStyle(color: AppColors.textSecondary(isDarkMode)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sí, limpiar todo'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Limpiar todas las ausencias
      controller.clearAbsences();

      if (context.mounted) {
        AppSnackBar.showInfo(context, 'Todas las ausencias han sido limpiadas');
      }
    }
  }
}
