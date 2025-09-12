import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/scheduling_controller.dart';
import '../../domain/entities/appointment.dart' as domain;
import '../../domain/entities/schedule.dart';
import 'common/common.dart';

/// Widget de formulario para crear/editar citas
class AppointmentFormWidget extends StatefulWidget {
  final domain.Appointment? appointment;
  final DateTime? selectedDate;
  final VoidCallback? onSaved;
  final VoidCallback? onCancelled;

  const AppointmentFormWidget({
    super.key,
    this.appointment,
    this.selectedDate,
    this.onSaved,
    this.onCancelled,
  });

  @override
  State<AppointmentFormWidget> createState() => _AppointmentFormWidgetState();
}

class _AppointmentFormWidgetState extends State<AppointmentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  domain.AppointmentType _selectedType = domain.AppointmentType.consulta;
  domain.AppointmentPriority _selectedPriority =
      domain.AppointmentPriority.media;
  String? _selectedTeacherId;
  String? _selectedTeacherName;
  bool _isRecurring = false;
  RecurrencePattern _recurrencePattern = RecurrencePattern.none;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _studentNameController.dispose();
    _studentIdController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.appointment != null) {
      final appointment = widget.appointment!;
      _titleController.text = appointment.title;
      _descriptionController.text = appointment.description;
      _studentNameController.text = appointment.studentName;
      _studentIdController.text = appointment.studentId;
      _locationController.text = appointment.location ?? '';
      _notesController.text = appointment.notes ?? '';
      _selectedStartTime = appointment.startTime;
      _selectedEndTime = appointment.endTime;
      _selectedType = appointment.type;
      _selectedPriority = appointment.priority;
      _selectedTeacherId = appointment.teacherId;
      _selectedTeacherName = appointment.teacherName;
      _isRecurring = appointment.isRecurring;
      _recurrencePattern = appointment.recurrencePattern != null
          ? RecurrencePattern.values.firstWhere(
              (e) => e.name == appointment.recurrencePattern,
              orElse: () => RecurrencePattern.none,
            )
          : RecurrencePattern.none;
    } else if (widget.selectedDate != null) {
      _selectedStartTime = DateTime(
        widget.selectedDate!.year,
        widget.selectedDate!.month,
        widget.selectedDate!.day,
        9, // 9:00 AM por defecto
      );
      _selectedEndTime = _selectedStartTime!.add(const Duration(hours: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return AppContainer.elevated(
          isDarkMode: isDarkMode,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDarkMode),
                  AppSpacing.lgV,

                  // Información básica
                  _buildBasicInfoSection(isDarkMode),
                  AppSpacing.lgV,

                  // Fecha y hora
                  _buildDateTimeSection(isDarkMode),
                  AppSpacing.lgV,

                  // Tipo y prioridad
                  _buildTypePrioritySection(isDarkMode),
                  AppSpacing.lgV,

                  // Profesor asignado
                  _buildTeacherSection(isDarkMode),
                  AppSpacing.lgV,

                  // Ubicación y notas
                  _buildLocationNotesSection(isDarkMode),
                  AppSpacing.lgV,

                  // Recurrencia
                  _buildRecurrenceSection(isDarkMode),
                  AppSpacing.lgV,

                  // Botones de acción
                  _buildActionButtons(isDarkMode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          widget.appointment != null ? Icons.edit : Icons.add,
          size: 24,
          color: AppColors.textPrimary(isDarkMode),
        ),
        AppSpacing.smH,
        Text(
          widget.appointment != null ? 'Editar Cita' : 'Nueva Cita',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        const Spacer(),
        if (_error != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _error!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBasicInfoSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Básica',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        // Título
        _buildTextField(
          controller: _titleController,
          label: 'Título de la cita',
          hint: 'Ej: Consulta académica, Evaluación psicológica',
          icon: Icons.title,
          isDarkMode: isDarkMode,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El título es obligatorio';
            }
            return null;
          },
        ),
        AppSpacing.mdV,

        // Descripción
        _buildTextField(
          controller: _descriptionController,
          label: 'Descripción',
          hint: 'Describe el propósito de la cita',
          icon: Icons.description,
          isDarkMode: isDarkMode,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La descripción es obligatoria';
            }
            return null;
          },
        ),
        AppSpacing.mdV,

        // Información del estudiante
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _studentNameController,
                label: 'Nombre del estudiante',
                hint: 'Nombre completo',
                icon: Icons.person,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
            ),
            AppSpacing.mdH,
            Expanded(
              child: _buildTextField(
                controller: _studentIdController,
                label: 'ID del estudiante',
                hint: 'Número de identificación',
                icon: Icons.badge,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El ID es obligatorio';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha y Hora',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        Row(
          children: [
            Expanded(
              child: _buildDateTimeField(
                label: 'Fecha y hora de inicio',
                value: _selectedStartTime,
                onTap: () => _selectStartTime(isDarkMode),
                icon: Icons.access_time,
                isDarkMode: isDarkMode,
              ),
            ),
            AppSpacing.mdH,
            Expanded(
              child: _buildDateTimeField(
                label: 'Fecha y hora de fin',
                value: _selectedEndTime,
                onTap: () => _selectEndTime(isDarkMode),
                icon: Icons.schedule,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypePrioritySection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo y Prioridad',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Tipo de cita',
                value: _selectedType.displayName,
                onTap: () => _showTypeSelector(isDarkMode),
                icon: Icons.category,
                isDarkMode: isDarkMode,
              ),
            ),
            AppSpacing.mdH,
            Expanded(
              child: _buildDropdownField(
                label: 'Prioridad',
                value: _selectedPriority.displayName,
                onTap: () => _showPrioritySelector(isDarkMode),
                icon: Icons.priority_high,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeacherSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profesor Asignado',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        _buildDropdownField(
          label: 'Profesor',
          value: _selectedTeacherName ?? 'Seleccionar profesor',
          onTap: () => _showTeacherSelector(isDarkMode),
          icon: Icons.person_outline,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildLocationNotesSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ubicación y Notas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        _buildTextField(
          controller: _locationController,
          label: 'Ubicación',
          hint: 'Ej: Aula 101, Oficina de Orientación',
          icon: Icons.location_on,
          isDarkMode: isDarkMode,
        ),
        AppSpacing.mdV,

        _buildTextField(
          controller: _notesController,
          label: 'Notas adicionales',
          hint: 'Información adicional sobre la cita',
          icon: Icons.note,
          isDarkMode: isDarkMode,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildRecurrenceSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recurrencia',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        Row(
          children: [
            Checkbox(
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value ?? false;
                });
              },
              activeColor: AppColors.textPrimary(isDarkMode),
            ),
            Text(
              'Cita recurrente',
              style: TextStyle(
                color: AppColors.textPrimary(isDarkMode),
                fontSize: 14,
              ),
            ),
          ],
        ),

        if (_isRecurring) ...[
          AppSpacing.mdV,
          _buildDropdownField(
            label: 'Patrón de recurrencia',
            value: _recurrencePattern.displayName,
            onTap: () => _showRecurrenceSelector(isDarkMode),
            icon: Icons.repeat,
            isDarkMode: isDarkMode,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton.surface(text: 'Cancelar', onPressed: widget.onCancelled),
        AppSpacing.mdH,
        AppButton.elegantGreen(
          text: widget.appointment != null ? 'Actualizar' : 'Crear',
          onPressed: _isLoading ? null : () => _saveAppointment(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.xsV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.smH,
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    maxLines: maxLines,
                    validator: validator,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(isDarkMode),
                      ),
                    ),
                    style: TextStyle(color: AppColors.textPrimary(isDarkMode)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.xsV,
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.smH,
                Expanded(
                  child: Text(
                    value != null
                        ? '${_formatDate(value)} ${_formatTime(value)}'
                        : 'Seleccionar fecha y hora',
                    style: TextStyle(
                      color: value != null
                          ? AppColors.textPrimary(isDarkMode)
                          : AppColors.textSecondary(isDarkMode),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.xsV,
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface(isDarkMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                AppSpacing.smH,
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(color: AppColors.textPrimary(isDarkMode)),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectStartTime(bool isDarkMode) async {
    final date = await AppDatePicker.show(
      context: context,
      initialDate: _selectedStartTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await _showTimePicker(
        initialTime: TimeOfDay.fromDateTime(
          _selectedStartTime ?? DateTime.now(),
        ),
      );

      if (time != null && mounted) {
        setState(() {
          _selectedStartTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          // Actualizar la hora de fin automáticamente
          if (_selectedEndTime == null ||
              _selectedEndTime!.isBefore(_selectedStartTime!)) {
            _selectedEndTime = _selectedStartTime!.add(
              const Duration(hours: 1),
            );
          }
        });
      }
    }
  }

  void _selectEndTime(bool isDarkMode) async {
    if (_selectedStartTime == null) {
      AppSnackBar.showError(context, 'Primero selecciona la hora de inicio');
      return;
    }

    final date = await AppDatePicker.show(
      context: context,
      initialDate: _selectedEndTime ?? _selectedStartTime!,
      firstDate: _selectedStartTime!,
      lastDate: _selectedStartTime!.add(const Duration(days: 1)),
    );

    if (date != null && mounted) {
      final time = await _showTimePicker(
        initialTime: TimeOfDay.fromDateTime(
          _selectedEndTime ?? _selectedStartTime!,
        ),
      );

      if (time != null && mounted) {
        final endDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        if (endDateTime.isAfter(_selectedStartTime!)) {
          setState(() {
            _selectedEndTime = endDateTime;
          });
        } else {
          AppSnackBar.showError(
            context,
            'La hora de fin debe ser posterior a la hora de inicio',
          );
        }
      }
    }
  }

  Future<TimeOfDay?> _showTimePicker({required TimeOfDay initialTime}) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
                    primary: AppColors.textPrimary(isDarkMode),
                    onPrimary: AppColors.backgroundPrimary(isDarkMode),
                    surface: AppColors.surface(isDarkMode),
                    onSurface: AppColors.textPrimary(isDarkMode),
                  )
                : ColorScheme.light(
                    primary: AppColors.textPrimary(isDarkMode),
                    onPrimary: AppColors.backgroundPrimary(isDarkMode),
                    surface: AppColors.surface(isDarkMode),
                    onSurface: AppColors.textPrimary(isDarkMode),
                  ),
          ),
          child: child!,
        );
      },
    );
  }

  void _showTypeSelector(bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Seleccionar Tipo',
          style: TextStyle(
            color: AppColors.textPrimary(isDarkMode),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface(isDarkMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: domain.AppointmentType.values.map((type) {
            return ListTile(
              leading: Icon(_getTypeIcon(type), color: _getTypeColor(type)),
              title: Text(
                type.displayName,
                style: TextStyle(
                  color: AppColors.textPrimary(isDarkMode),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedType = type;
                });
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
      ),
    );
  }

  void _showPrioritySelector(bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Seleccionar Prioridad',
          style: TextStyle(
            color: AppColors.textPrimary(isDarkMode),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface(isDarkMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: domain.AppointmentPriority.values.map((priority) {
            return ListTile(
              leading: Icon(Icons.circle, color: _getPriorityColor(priority)),
              title: Text(
                priority.displayName,
                style: TextStyle(
                  color: AppColors.textPrimary(isDarkMode),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedPriority = priority;
                });
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
      ),
    );
  }

  void _showTeacherSelector(bool isDarkMode) {
    final teachers = Provider.of<SchedulingController>(context, listen: false)
        .workSchedules
        .map(
          (schedule) => {
            'id': schedule.teacherId,
            'name': schedule.teacherName,
          },
        )
        .toList();

    if (teachers.isEmpty) {
      AppSnackBar.showError(context, 'No hay profesores disponibles');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Seleccionar Profesor',
          style: TextStyle(
            color: AppColors.textPrimary(isDarkMode),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface(isDarkMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: teachers.map((teacher) {
            return ListTile(
              leading: Icon(
                Icons.person_outline,
                color: AppColors.iconSecondary(isDarkMode),
              ),
              title: Text(
                teacher['name']!,
                style: TextStyle(
                  color: AppColors.textPrimary(isDarkMode),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedTeacherId = teacher['id'];
                  _selectedTeacherName = teacher['name'];
                });
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
      ),
    );
  }

  void _showRecurrenceSelector(bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Seleccionar Recurrencia',
          style: TextStyle(
            color: AppColors.textPrimary(isDarkMode),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface(isDarkMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: RecurrencePattern.values.map((pattern) {
            return ListTile(
              leading: Icon(
                _getRecurrenceIcon(pattern),
                color: AppColors.iconSecondary(isDarkMode),
              ),
              title: Text(
                pattern.displayName,
                style: TextStyle(
                  color: AppColors.textPrimary(isDarkMode),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                setState(() {
                  _recurrencePattern = pattern;
                });
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
      ),
    );
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedStartTime == null || _selectedEndTime == null) {
      AppSnackBar.showError(context, 'Selecciona la fecha y hora de la cita');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (widget.appointment != null) {
        // Actualizar cita existente
        await Provider.of<SchedulingController>(
          context,
          listen: false,
        ).updateAppointment(
          widget.appointment!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startTime: _selectedStartTime!,
          endTime: _selectedEndTime!,
          type: _selectedType,
          priority: _selectedPriority,
          teacherId: _selectedTeacherId,
          teacherName: _selectedTeacherName,
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
      } else {
        // Crear nueva cita
        await Provider.of<SchedulingController>(
          context,
          listen: false,
        ).createAppointment(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startTime: _selectedStartTime!,
          endTime: _selectedEndTime!,
          type: _selectedType,
          priority: _selectedPriority,
          studentId: _studentIdController.text.trim(),
          studentName: _studentNameController.text.trim(),
          teacherId: _selectedTeacherId,
          teacherName: _selectedTeacherName,
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          isRecurring: _isRecurring,
          recurrencePattern: _isRecurring ? _recurrencePattern.name : null,
        );
      }

      if (mounted) {
        AppSnackBar.showSuccess(
          context,
          widget.appointment != null
              ? 'Cita actualizada exitosamente'
              : 'Cita creada exitosamente',
        );

        widget.onSaved?.call();
      }
    } catch (e) {
      setState(() {
        _error = 'Error al guardar la cita: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  IconData _getTypeIcon(domain.AppointmentType type) {
    switch (type) {
      case domain.AppointmentType.consulta:
        return Icons.psychology;
      case domain.AppointmentType.reunion:
        return Icons.people;
      case domain.AppointmentType.evaluacion:
        return Icons.quiz;
      case domain.AppointmentType.seguimiento:
        return Icons.track_changes;
      case domain.AppointmentType.emergencia:
        return Icons.warning;
    }
  }

  IconData _getRecurrenceIcon(RecurrencePattern pattern) {
    switch (pattern) {
      case RecurrencePattern.none:
        return Icons.block;
      case RecurrencePattern.daily:
        return Icons.today;
      case RecurrencePattern.weekly:
        return Icons.date_range;
      case RecurrencePattern.monthly:
        return Icons.calendar_month;
      case RecurrencePattern.yearly:
        return Icons.event;
    }
  }

  Color _getTypeColor(domain.AppointmentType type) {
    switch (type) {
      case domain.AppointmentType.consulta:
        return const Color(0xFF2196F3); // Azul
      case domain.AppointmentType.reunion:
        return const Color(0xFF4CAF50); // Verde
      case domain.AppointmentType.evaluacion:
        return const Color(0xFFFF9800); // Naranja
      case domain.AppointmentType.seguimiento:
        return const Color(0xFF9C27B0); // Púrpura
      case domain.AppointmentType.emergencia:
        return const Color(0xFFF44336); // Rojo
    }
  }

  Color _getPriorityColor(domain.AppointmentPriority priority) {
    switch (priority) {
      case domain.AppointmentPriority.baja:
        return const Color(0xFF4CAF50); // Verde
      case domain.AppointmentPriority.media:
        return const Color(0xFFFF9800); // Naranja
      case domain.AppointmentPriority.alta:
        return const Color(0xFFFF5722); // Rojo oscuro
      case domain.AppointmentPriority.urgente:
        return const Color(0xFFF44336); // Rojo
    }
  }
}
