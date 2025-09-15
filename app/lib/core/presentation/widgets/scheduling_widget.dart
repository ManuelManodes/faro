import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sf;

import '../controllers/scheduling_controller.dart';
import '../../domain/entities/appointment.dart' as domain;
import '../../domain/entities/school_schedule.dart' as school;
import 'common/common.dart';
import 'common/theme_provider.dart';

/// Widget principal del sistema de agendamiento
class SchedulingWidget extends StatelessWidget {
  const SchedulingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SchedulingController>(
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
      child: _buildCalendarView(controller, isDarkMode),
    );
  }

  Widget _buildCalendarView(SchedulingController controller, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _CalendarWidget(controller: controller),
      ),
    );
  }
}

/// Widget del calendario que se actualiza cuando cambian las citas
class _CalendarWidget extends StatefulWidget {
  final SchedulingController controller;

  const _CalendarWidget({required this.controller});

  @override
  State<_CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<_CalendarWidget> {
  late _SimpleAppointmentDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _SimpleAppointmentDataSource(widget.controller);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {
        _dataSource = _SimpleAppointmentDataSource(widget.controller);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          surface: AppColors.surface(isDarkMode),
          onSurface: isDarkMode
              ? AppColors.textPrimary(isDarkMode)
              : Colors.black.withValues(alpha: 0.7),
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primary.withValues(alpha: 0.1),
          onSecondary: isDarkMode
              ? AppColors.textPrimary(isDarkMode)
              : Colors.black.withValues(alpha: 0.7),
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyLarge: TextStyle(
            color: isDarkMode
                ? AppColors.textPrimary(isDarkMode)
                : Colors.black.withValues(alpha: 0.7),
          ),
          bodyMedium: TextStyle(
            color: isDarkMode
                ? AppColors.textPrimary(isDarkMode)
                : Colors.black.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: sf.SfCalendar(
        view: sf.CalendarView.month,
        dataSource: _dataSource,
        monthViewSettings: sf.MonthViewSettings(
          appointmentDisplayMode: sf.MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
          agendaViewHeight: 200,
        ),
        headerStyle: sf.CalendarHeaderStyle(
          backgroundColor: AppColors.surface(isDarkMode),
          textStyle: TextStyle(
            color: isDarkMode
                ? AppColors.textPrimary(isDarkMode)
                : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        viewHeaderStyle: sf.ViewHeaderStyle(
          backgroundColor: AppColors.surface(isDarkMode),
          dayTextStyle: TextStyle(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.black.withValues(
                    alpha: 0.4,
                  ), // Sin contraste en ambos temas
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        cellBorderColor: AppColors.dividerTheme(isDarkMode),
        backgroundColor: AppColors.surface(isDarkMode),
        todayHighlightColor: isDarkMode
            ? const Color(0xFF3D3D3D) // Gris elegante para modo oscuro
            : const Color(0xFF3D3D3D), // Gris elegante para modo claro
        todayTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        selectionDecoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: (sf.CalendarTapDetails details) {
          if (details.targetElement == sf.CalendarElement.appointment) {
            final appointment = details.appointments?.first;
            if (appointment != null) {
              // Implementar diálogo de detalles de cita
            }
          }
        },
      ),
    );
  }
}

/// DataSource simplificado para el calendario
class _SimpleAppointmentDataSource
    extends sf.CalendarDataSource<domain.Appointment> {
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

  /// Actualiza las citas cuando el controller cambia
  void refreshAppointments() {
    _loadAppointments();
    // No necesitamos notifyListeners aquí ya que el widget se reconstruye automáticamente
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

  @override
  List<dynamic> get appointments => _appointments;

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
