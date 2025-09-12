import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/school_schedule.dart';
import '../controllers/scheduling_controller.dart';
import 'common/common.dart';

/// Widget para crear y editar horarios escolares
class SchoolScheduleFormWidget extends StatefulWidget {
  final SchoolSchedule? schedule;
  final VoidCallback? onSaved;
  final SchedulingController? controller;

  const SchoolScheduleFormWidget({
    super.key,
    this.schedule,
    this.onSaved,
    this.controller,
  });

  @override
  State<SchoolScheduleFormWidget> createState() =>
      _SchoolScheduleFormWidgetState();
}

class _SchoolScheduleFormWidgetState extends State<SchoolScheduleFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _teacherNameController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _classroomController = TextEditingController();
  final _gradeController = TextEditingController();
  final _sectionController = TextEditingController();
  final _descriptionController = TextEditingController();

  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 0);
  List<DayOfWeek> _selectedDays = [];
  String _selectedColor = '#FF6B6B';
  bool _isActive = true;

  final List<String> _availableColors = [
    '#FF6B6B', // Rojo
    '#4ECDC4', // Turquesa
    '#45B7D1', // Azul
    '#96CEB4', // Verde
    '#FFEAA7', // Amarillo
    '#DDA0DD', // Púrpura
    '#98D8C8', // Verde claro
    '#F7DC6F', // Amarillo claro
    '#BB8FCE', // Púrpura claro
    '#85C1E9', // Azul claro
  ];

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _loadScheduleData();
    }
  }

  void _loadScheduleData() {
    final schedule = widget.schedule!;
    _subjectController.text = schedule.subject;
    _teacherNameController.text = schedule.teacherName;
    _teacherIdController.text = schedule.teacherId;
    _classroomController.text = schedule.classroom;
    _gradeController.text = schedule.grade;
    _sectionController.text = schedule.section;
    _descriptionController.text = schedule.description;
    _startTime = TimeOfDay.fromDateTime(schedule.startTime);
    _endTime = TimeOfDay.fromDateTime(schedule.endTime);
    _selectedDays = List.from(schedule.daysOfWeek);
    _selectedColor = schedule.color;
    _isActive = schedule.isActive;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherNameController.dispose();
    _teacherIdController.dispose();
    _classroomController.dispose();
    _gradeController.dispose();
    _sectionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  widget.schedule == null
                      ? 'Nuevo Horario Escolar'
                      : 'Editar Horario Escolar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                AppSpacing.lgV,

                // Información básica
                _buildSectionTitle('Información Básica', isDarkMode),
                AppSpacing.mdV,

                // Asignatura
                _buildTextField(
                  controller: _subjectController,
                  label: 'Asignatura',
                  hint: 'Ej: Matemáticas, Lengua, Ciencias...',
                  isDarkMode: isDarkMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La asignatura es obligatoria';
                    }
                    return null;
                  },
                ),
                AppSpacing.mdV,

                // Profesor
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _teacherNameController,
                        label: 'Nombre del Profesor',
                        hint: 'Ej: Prof. Ana García',
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre del profesor es obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.mdH,
                    Expanded(
                      child: _buildTextField(
                        controller: _teacherIdController,
                        label: 'ID del Profesor',
                        hint: 'Ej: teacher_001',
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El ID del profesor es obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                AppSpacing.mdV,

                // Aula y Grado
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _classroomController,
                        label: 'Aula',
                        hint: 'Ej: Aula 101, Laboratorio 1...',
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El aula es obligatoria';
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.mdH,
                    Expanded(
                      child: _buildTextField(
                        controller: _gradeController,
                        label: 'Grado',
                        hint: 'Ej: 5to, 6to, 1ro...',
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El grado es obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.mdH,
                    Expanded(
                      child: _buildTextField(
                        controller: _sectionController,
                        label: 'Sección',
                        hint: 'Ej: A, B, C...',
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La sección es obligatoria';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Horario
                _buildSectionTitle('Horario', isDarkMode),
                AppSpacing.mdV,

                // Días de la semana
                Text(
                  'Días de la semana',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                AppSpacing.smV,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: DayOfWeek.values.map((day) {
                    final isSelected = _selectedDays.contains(day);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedDays.remove(day);
                          } else {
                            _selectedDays.add(day);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.backgroundSecondary(isDarkMode),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.dividerTheme(isDarkMode),
                          ),
                        ),
                        child: Text(
                          day.shortName,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary(isDarkMode),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                AppSpacing.mdV,

                // Horas
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeSelector(
                        'Hora de inicio',
                        _startTime,
                        (time) => setState(() => _startTime = time),
                        isDarkMode,
                      ),
                    ),
                    AppSpacing.mdH,
                    Expanded(
                      child: _buildTimeSelector(
                        'Hora de fin',
                        _endTime,
                        (time) => setState(() => _endTime = time),
                        isDarkMode,
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Apariencia
                _buildSectionTitle('Apariencia', isDarkMode),
                AppSpacing.mdV,

                // Color
                Text(
                  'Color del horario',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                AppSpacing.smV,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(color.replaceFirst('#', '0xFF')),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.textPrimary(isDarkMode)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: isSelected
                            ? Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                AppSpacing.lgV,

                // Descripción
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Descripción (opcional)',
                  hint: 'Información adicional sobre el horario...',
                  isDarkMode: isDarkMode,
                  maxLines: 3,
                ),
                AppSpacing.lgV,

                // Estado activo
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (value) =>
                          setState(() => _isActive = value ?? true),
                      activeColor: AppColors.primary,
                    ),
                    AppSpacing.smH,
                    Text(
                      'Horario activo',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                AppSpacing.xlV,

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: AppButton.secondary(
                        text: 'Cancelar',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    AppSpacing.mdH,
                    Expanded(
                      child: AppButton.primary(
                        text: widget.schedule == null
                            ? 'Crear Horario'
                            : 'Actualizar Horario',
                        onPressed: _saveSchedule,
                        icon: widget.schedule == null ? Icons.add : Icons.save,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(isDarkMode),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isDarkMode = false,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.xsV,
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(color: AppColors.textPrimary(isDarkMode)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondary(isDarkMode)),
            filled: true,
            fillColor: AppColors.backgroundSecondary(isDarkMode),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.dividerTheme(isDarkMode)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.dividerTheme(isDarkMode)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(
    String label,
    TimeOfDay time,
    ValueChanged<TimeOfDay> onChanged,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.xsV,
        GestureDetector(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (selectedTime != null && mounted) {
              onChanged(selectedTime);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.iconSecondary(isDarkMode),
                  size: 20,
                ),
                AppSpacing.smH,
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: AppColors.textPrimary(isDarkMode),
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _saveSchedule() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona al menos un día de la semana'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final controller =
        widget.controller ??
        Provider.of<SchedulingController>(context, listen: false);

    final schedule = SchoolSchedule.create(
      subject: _subjectController.text.trim(),
      teacherName: _teacherNameController.text.trim(),
      teacherId: _teacherIdController.text.trim(),
      classroom: _classroomController.text.trim(),
      grade: _gradeController.text.trim(),
      section: _sectionController.text.trim(),
      startTime: DateTime(2024, 1, 1, _startTime.hour, _startTime.minute),
      endTime: DateTime(2024, 1, 1, _endTime.hour, _endTime.minute),
      daysOfWeek: _selectedDays,
      color: _selectedColor,
      description: _descriptionController.text.trim(),
    );

    if (widget.schedule == null) {
      controller.addSchoolSchedule(schedule);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Horario escolar creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      controller.updateSchoolSchedule(widget.schedule!.id, schedule);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Horario escolar actualizado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }

    widget.onSaved?.call();
    Navigator.of(context).pop();
  }
}
