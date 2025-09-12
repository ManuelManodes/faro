import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sf;

import '../controllers/scheduling_controller.dart';
import '../../domain/entities/appointment.dart' as domain;
import '../../domain/entities/school_schedule.dart' as school;
import 'appointment_form_widget.dart';
import 'school_schedule_form_widget.dart';
import 'common/common.dart';

/// Widget principal del sistema de agendamiento
class SchedulingWidget extends StatelessWidget {
  const SchedulingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SchedulingController()..loadSampleData(),
      child: Consumer<SchedulingController>(
        builder: (context, controller, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final isDarkMode = themeProvider.isDarkMode;

              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.error != null) {
                return _buildErrorView(controller.error!, isDarkMode);
              }

              return _buildMainView(controller, isDarkMode, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String error, bool isDarkMode) {
    return Center(
      child: AppContainer.elevated(
        isDarkMode: isDarkMode,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            AppSpacing.lgV,
            Text(
              'Error al cargar el agendamiento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(isDarkMode),
              ),
            ),
            AppSpacing.smV,
            Text(
              error,
              style: TextStyle(color: AppColors.textSecondary(isDarkMode)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView(
    SchedulingController controller,
    bool isDarkMode,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Barra de herramientas simplificada
          _buildToolbar(controller, isDarkMode, context),
          AppSpacing.lgV,

          // Contenido principal - Calendario simple
          Expanded(child: _buildCalendarView(controller, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildToolbar(
    SchedulingController controller,
    bool isDarkMode,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
      ),
      child: Row(
        children: [
          // Botón nueva cita
          AppButton.primary(
            text: 'Nueva Cita',
            onPressed: () => _showCreateAppointmentDialog(controller, context),
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

          const Spacer(),

          // Información
          Text(
            '${controller.appointments.length} citas • ${controller.schoolSchedules.length} horarios',
            style: TextStyle(
              color: AppColors.textSecondary(isDarkMode),
              fontSize: 14,
            ),
          ),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.backgroundSecondary(isDarkMode),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value
                ? AppColors.primary
                : AppColors.dividerTheme(isDarkMode),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: value
                  ? AppColors.primary
                  : AppColors.iconSecondary(isDarkMode),
            ),
            AppSpacing.xsH,
            Text(
              label,
              style: TextStyle(
                color: value
                    ? AppColors.primary
                    : AppColors.textPrimary(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView(SchedulingController controller, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
      ),
      child: sf.SfCalendar(
        view: sf.CalendarView.month,
        dataSource: _SimpleAppointmentDataSource(controller),
        monthViewSettings: sf.MonthViewSettings(
          appointmentDisplayMode: sf.MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
          agendaViewHeight: 200,
        ),
        onTap: (sf.CalendarTapDetails details) {
          if (details.targetElement == sf.CalendarElement.appointment) {
            final appointment = details.appointments?.first;
            if (appointment != null) {
              _showAppointmentDetails(appointment, controller);
            }
          }
        },
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

  void _showAppointmentDetails(
    domain.Appointment appointment,
    SchedulingController controller,
  ) {
    // Implementar diálogo de detalles
    print('Mostrar detalles de cita: ${appointment.title}');
  }
}

/// DataSource simplificado para el calendario
class _SimpleAppointmentDataSource extends sf.CalendarDataSource {
  final SchedulingController _controller;
  List<domain.Appointment> _appointments = [];

  _SimpleAppointmentDataSource(this._controller) {
    _loadAppointments();
  }

  void _loadAppointments() {
    _appointments.clear();

    // Agregar citas normales
    _appointments.addAll(_controller.appointments);

    // Agregar horarios escolares si están habilitados
    if (_controller.showSchoolSchedules) {
      final today = DateTime.now();
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

      // Solo agregar horarios para la semana actual
      for (final schedule in _controller.schoolSchedules) {
        for (int i = 0; i < 7; i++) {
          final date = startOfWeek.add(Duration(days: i));
          if (schedule.isActiveOnDay(_getDayOfWeek(date))) {
            final appointment = _controller.schoolScheduleToAppointment(
              schedule,
              date,
            );
            _appointments.add(appointment);
          }
        }
      }
    }
  }

  school.DayOfWeek _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return school.DayOfWeek.monday;
      case 2:
        return school.DayOfWeek.tuesday;
      case 3:
        return school.DayOfWeek.wednesday;
      case 4:
        return school.DayOfWeek.thursday;
      case 5:
        return school.DayOfWeek.friday;
      case 6:
        return school.DayOfWeek.saturday;
      case 7:
        return school.DayOfWeek.sunday;
      default:
        return school.DayOfWeek.monday;
    }
  }

  @override
  DateTime getStartTime(int index) {
    return _appointments[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return _appointments[index].endTime;
  }

  @override
  String getSubject(int index) {
    return _appointments[index].title;
  }

  @override
  Color getColor(int index) {
    return _getTypeColor(_appointments[index].type);
  }

  @override
  String getNotes(int index) {
    return _appointments[index].description;
  }

  @override
  String getLocation(int index) {
    return _appointments[index].location ?? '';
  }

  Color _getTypeColor(domain.AppointmentType type) {
    switch (type) {
      case domain.AppointmentType.consulta:
        return Colors.blue;
      case domain.AppointmentType.evaluacion:
        return Colors.red;
      case domain.AppointmentType.reunion:
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}
