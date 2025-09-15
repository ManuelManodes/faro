import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/student.dart';
import '../controllers/attendance_list_controller.dart';
import 'common/common.dart';

/// Widget que muestra una tabla elegante de estudiantes con checkboxes para marcar ausencias
class AttendanceTableWidget extends StatefulWidget {
  final String level;
  final String course;

  const AttendanceTableWidget({
    super.key,
    required this.level,
    required this.course,
  });

  @override
  State<AttendanceTableWidget> createState() => _AttendanceTableWidgetState();
}

/// Widget para una fila de estudiante con navegación por teclado
class FocusableStudentRow extends StatefulWidget {
  final Student student;
  final int index;
  final bool isAbsent;
  final Function(String) onToggleAbsence;
  final bool isDarkMode;

  const FocusableStudentRow({
    super.key,
    required this.student,
    required this.index,
    required this.isAbsent,
    required this.onToggleAbsence,
    required this.isDarkMode,
  });

  @override
  State<FocusableStudentRow> createState() => _FocusableStudentRowState();
}

class _FocusableStudentRowState extends State<FocusableStudentRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: widget.isAbsent
            ? AppColors.error.withValues(alpha: 0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Número de estudiante
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surface(widget.isDarkMode),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.dividerTheme(widget.isDarkMode),
              ),
            ),
            child: Center(
              child: Text(
                '${widget.index + 1}',
                style: TextStyle(
                  color: AppColors.textSecondary(widget.isDarkMode),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          AppSpacing.mdH,
          // Información del estudiante
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student.fullName,
                  style: TextStyle(
                    color: AppColors.textPrimary(widget.isDarkMode),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.xsV,
                Text(
                  '${widget.student.level} - Curso ${widget.student.course}',
                  style: TextStyle(
                    color: AppColors.textSecondary(widget.isDarkMode),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Checkbox de ausencia
          Expanded(
            flex: 1,
            child: Center(
              child: GestureDetector(
                onTap: () => widget.onToggleAbsence(widget.student.id),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.isAbsent
                        ? AppColors.error
                        : AppColors.surface(widget.isDarkMode),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: widget.isAbsent
                          ? AppColors.error
                          : AppColors.dividerTheme(widget.isDarkMode),
                      width: 2,
                    ),
                  ),
                  child: widget.isAbsent
                      ? Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que maneja la navegación por teclado de toda la tabla
class KeyboardNavigationTable extends StatefulWidget {
  final bool isDarkMode;
  final AttendanceListController controller;

  const KeyboardNavigationTable({
    super.key,
    required this.isDarkMode,
    required this.controller,
  });

  @override
  State<KeyboardNavigationTable> createState() =>
      _KeyboardNavigationTableState();
}

class _KeyboardNavigationTableState extends State<KeyboardNavigationTable> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      final itemHeight = 60.0; // Altura aproximada de cada fila
      final offset = index * itemHeight;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowDown:
              if (_currentIndex < widget.controller.students.length - 1) {
                setState(() {
                  _currentIndex++;
                });
                _scrollToIndex(_currentIndex);
              }
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowUp:
              if (_currentIndex > 0) {
                setState(() {
                  _currentIndex--;
                });
                _scrollToIndex(_currentIndex);
              }
              return KeyEventResult.handled;
            case LogicalKeyboardKey.space:
            case LogicalKeyboardKey.enter:
              if (widget.controller.students.isNotEmpty) {
                final student = widget.controller.students[_currentIndex];
                widget.controller.toggleAbsence(student.id);
              }
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView.separated(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.controller.students.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: AppColors.dividerTheme(widget.isDarkMode),
          ),
          itemBuilder: (context, index) {
            final student = widget.controller.students[index];
            final isSelected = index == _currentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.isDarkMode
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : AppColors.primary.withValues(alpha: 0.12))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isSelected
                    ? Border.all(
                        color: widget.isDarkMode
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.primary.withValues(alpha: 0.3),
                        width: 1.0,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: widget.isDarkMode
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Indicador de foco en el lado izquierdo
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 3,
                    height: isSelected ? 50 : 0,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(1.5),
                        bottomRight: Radius.circular(1.5),
                      ),
                    ),
                  ),
                  // Contenido de la fila
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          // Información del estudiante
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.fullName,
                                  style: TextStyle(
                                    color: AppColors.textPrimary(
                                      widget.isDarkMode,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${student.level} - ${student.course}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary(
                                      widget.isDarkMode,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Checkbox para ausencia
                          GestureDetector(
                            onTap: () =>
                                widget.controller.toggleAbsence(student.id),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                widget.controller.isAbsent(student.id)
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: widget.controller.isAbsent(student.id)
                                    ? AppColors.error
                                    : AppColors.iconSecondary(
                                        widget.isDarkMode,
                                      ),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AttendanceTableWidgetState extends State<AttendanceTableWidget> {
  String? _currentLevel;
  String? _currentCourse;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AttendanceListController>(
      builder: (context, themeProvider, attendanceController, child) {
        final isDarkMode = themeProvider.isDarkMode;

        // Cargar estudiantes solo cuando cambien los parámetros
        if (_currentLevel != widget.level || _currentCourse != widget.course) {
          _currentLevel = widget.level;
          _currentCourse = widget.course;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            attendanceController.loadStudents(widget.level, widget.course);
          });
        }

        if (attendanceController.isLoading) {
          return _buildLoadingState(isDarkMode);
        }

        if (attendanceController.error != null) {
          return _buildErrorState(isDarkMode, attendanceController.error!);
        }

        if (attendanceController.students.isEmpty) {
          return _buildEmptyState(isDarkMode);
        }

        return _buildTable(isDarkMode, attendanceController);
      },
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            AppSpacing.mdV,
            Text(
              'Cargando estudiantes...',
              style: TextStyle(
                color: AppColors.textSecondary(isDarkMode),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDarkMode, String error) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.mdV,
            Text(
              'Error al cargar estudiantes',
              style: TextStyle(
                color: AppColors.textPrimary(isDarkMode),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.smV,
            Text(
              error,
              style: TextStyle(
                color: AppColors.textSecondary(isDarkMode),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: AppColors.iconSecondary(isDarkMode),
            ),
            AppSpacing.mdV,
            Text(
              'No hay estudiantes',
              style: TextStyle(
                color: AppColors.textPrimary(isDarkMode),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.smV,
            Text(
              'Selecciona un nivel y curso para ver los estudiantes',
              style: TextStyle(
                color: AppColors.textSecondary(isDarkMode),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(bool isDarkMode, AttendanceListController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerTheme(isDarkMode), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la tabla
          _buildTableHeader(isDarkMode, controller),
          AppSpacing.mdV,
          // Contenido de la tabla
          _buildTableContent(isDarkMode, controller),
        ],
      ),
    );
  }

  Widget _buildTableHeader(
    bool isDarkMode,
    AttendanceListController controller,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Estudiantes (${controller.students.length})',
            style: TextStyle(
              color: AppColors.textPrimary(isDarkMode),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ausente',
                style: TextStyle(
                  color: AppColors.textSecondary(isDarkMode),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.xsH,
              Icon(
                Icons.help_outline,
                size: 16,
                color: AppColors.iconSecondary(isDarkMode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableContent(
    bool isDarkMode,
    AttendanceListController controller,
  ) {
    return KeyboardNavigationTable(
      isDarkMode: isDarkMode,
      controller: controller,
    );
  }
}
