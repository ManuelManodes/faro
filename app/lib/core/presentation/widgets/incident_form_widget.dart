import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/incident_form_controller.dart';
import '../../domain/entities/incident.dart';
import 'common/common.dart';

class IncidentFormWidget extends StatelessWidget {
  const IncidentFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IncidentFormController(),
      child: const _IncidentFormContent(),
    );
  }
}

class _IncidentFormContent extends StatelessWidget {
  const _IncidentFormContent();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, IncidentFormController>(
      builder: (context, themeProvider, controller, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.dividerTheme(isDarkMode),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del formulario
                _buildFormHeader(isDarkMode),
                AppSpacing.xxlV,

                // Campos del formulario
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título de la incidencia
                        _buildTitleField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Tipo
                        _buildTypeField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Estudiante y Reportante
                        Row(
                          children: [
                            Expanded(
                              child: _buildStudentField(controller, isDarkMode),
                            ),
                            AppSpacing.lgH,
                            Expanded(
                              child: _buildReportedByField(
                                controller,
                                isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.lgV,

                        // Ubicación y Categoría
                        Row(
                          children: [
                            Expanded(
                              child: _buildLocationField(
                                controller,
                                isDarkMode,
                              ),
                            ),
                            AppSpacing.lgH,
                            Expanded(
                              child: _buildCategoryField(
                                controller,
                                isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.lgV,

                        // Prioridad
                        _buildPriorityField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Descripción
                        _buildDescriptionField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Testigos
                        _buildWitnessesField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Derivación
                        _buildDerivationField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Notificar a apoderado
                        _buildNotifyParentField(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Notas adicionales
                        _buildNotesField(controller, isDarkMode),
                        AppSpacing.xxlV,

                        // Mensaje de error
                        if (controller.errorMessage != null)
                          _buildErrorMessage(
                            controller.errorMessage!,
                            isDarkMode,
                          ),
                        AppSpacing.lgV,

                        // Botones de acción
                        _buildActionButtons(controller, context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormHeader(bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.report_problem, color: AppColors.primary, size: 24),
        ),
        AppSpacing.mdH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reportar Incidencia',
                style: AppTextStyles.titlePrimary(isDarkMode),
              ),
              Text(
                'Complete todos los campos para reportar una incidencia educacional',
                style: AppTextStyles.secondaryText(isDarkMode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(IncidentFormController controller, bool isDarkMode) {
    return _buildFormField(
      label: 'Título de la Incidencia *',
      icon: Icons.title,
      isDarkMode: isDarkMode,
      controller: TextEditingController(text: controller.title),
      onChanged: controller.setTitle,
      errorText: controller.getFieldError('title'),
      hintText: 'Ej: Acoso escolar en el patio',
    );
  }

  Widget _buildTypeField(IncidentFormController controller, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Incidencia *',
          style: AppTextStyles.controlText(isDarkMode),
        ),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.shouldShowFieldError('type')
                  ? AppColors.error
                  : AppColors.dividerTheme(isDarkMode),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<IncidentType>(
              value: controller.type,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seleccionar tipo',
                      style: AppTextStyles.placeholderText(isDarkMode),
                    ),
                  ],
                ),
              ),
              items: IncidentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      type.displayName,
                      style: AppTextStyles.controlText(isDarkMode),
                    ),
                  ),
                );
              }).toList(),
              onChanged: controller.setType,
              dropdownColor: AppColors.surface(isDarkMode),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.iconSecondary(isDarkMode),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return _buildFormField(
      label: 'Estudiante Involucrado *',
      icon: Icons.person,
      isDarkMode: isDarkMode,
      controller: TextEditingController(text: controller.studentName),
      onChanged: controller.setStudentName,
      errorText: controller.getFieldError('studentName'),
      hintText: 'Nombre completo del estudiante',
    );
  }

  Widget _buildReportedByField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return _buildFormField(
      label: 'Reportado Por *',
      icon: Icons.person_add,
      isDarkMode: isDarkMode,
      controller: TextEditingController(text: controller.reportedBy),
      onChanged: controller.setReportedBy,
      errorText: controller.getFieldError('reportedBy'),
      hintText: 'Nombre del reportante',
    );
  }

  Widget _buildLocationField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ubicación *', style: AppTextStyles.controlText(isDarkMode)),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.shouldShowFieldError('location')
                  ? AppColors.error
                  : AppColors.dividerTheme(isDarkMode),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.location.isNotEmpty
                  ? controller.location
                  : null,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seleccionar ubicación',
                      style: AppTextStyles.placeholderText(isDarkMode),
                    ),
                  ],
                ),
              ),
              items: IncidentFormController.availableLocations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      location,
                      style: AppTextStyles.controlText(isDarkMode),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  controller.setLocation(value);
                }
              },
              dropdownColor: AppColors.surface(isDarkMode),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.iconSecondary(isDarkMode),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return _buildFormField(
      label: 'Descripción Detallada *',
      icon: Icons.description,
      isDarkMode: isDarkMode,
      controller: TextEditingController(text: controller.description),
      onChanged: controller.setDescription,
      errorText: controller.getFieldError('description'),
      hintText: 'Describa los detalles del incidente...',
      isMultiline: true,
      maxLines: 4,
    );
  }

  Widget _buildWitnessesField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Testigos (Opcional)',
          style: AppTextStyles.controlText(isDarkMode),
        ),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Column(
            children: [
              // Lista de testigos seleccionados
              if (controller.witnesses.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.witnesses.map((witness) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              witness,
                              style: AppTextStyles.controlText(isDarkMode),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => controller.removeWitness(witness),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              // Selector de testigos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: null,
                          hint: Text(
                            'Agregar testigo',
                            style: AppTextStyles.secondaryText(isDarkMode),
                          ),
                          items: IncidentFormController.availableWitnesses
                              .where(
                                (witness) =>
                                    !controller.witnesses.contains(witness),
                              )
                              .map((witness) {
                                return DropdownMenuItem(
                                  value: witness,
                                  child: Text(
                                    witness,
                                    style: AppTextStyles.controlText(
                                      isDarkMode,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              controller.addWitness(value);
                            }
                          },
                          dropdownColor: AppColors.surface(isDarkMode),
                          icon: Icon(
                            Icons.add,
                            color: AppColors.iconSecondary(isDarkMode),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField(IncidentFormController controller, bool isDarkMode) {
    return _buildFormField(
      label: 'Notas Adicionales (Opcional)',
      icon: Icons.note,
      isDarkMode: isDarkMode,
      controller: TextEditingController(text: controller.notes),
      onChanged: controller.setNotes,
      hintText: 'Información adicional relevante...',
      isMultiline: true,
      maxLines: 3,
    );
  }

  Widget _buildErrorMessage(String message, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20),
          AppSpacing.smH,
          Expanded(
            child: Text(message, style: AppTextStyles.errorText(isDarkMode)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    IncidentFormController controller,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton.surface(
          text: 'Cancelar',
          onPressed: () {
            controller.clearForm();
            AppSnackBar.showInfo(context, 'Formulario cancelado');
          },
        ),
        AppSpacing.lgH,
        AppButton.elegantGreen(
          text: controller.isLoading ? 'Enviando...' : 'Enviar Reporte',
          onPressed: controller.isLoading
              ? null
              : () async {
                  final success = await controller.submitForm();
                  if (success) {
                    AppSnackBar.showSuccess(
                      context,
                      'Incidencia reportada exitosamente',
                    );
                    controller.clearForm();
                  } else {
                    AppSnackBar.showError(
                      context,
                      controller.errorMessage ?? 'Error al enviar el reporte',
                    );
                  }
                },
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required bool isDarkMode,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String? errorText,
    String? hintText,
    bool isMultiline = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.controlText(isDarkMode)),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : AppColors.dividerTheme(isDarkMode),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.compact,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    maxLines: isMultiline ? maxLines : 1,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: AppTextStyles.placeholderText(isDarkMode),
                    ),
                    style: AppTextStyles.controlText(isDarkMode),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          AppSpacing.microV,
          Text(errorText, style: AppTextStyles.errorText(isDarkMode)),
        ],
      ],
    );
  }

  Widget _buildCategoryField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categoría *', style: AppTextStyles.controlText(isDarkMode)),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.shouldShowFieldError('category')
                  ? AppColors.error
                  : AppColors.dividerTheme(isDarkMode),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.category,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seleccionar categoría',
                      style: AppTextStyles.placeholderText(isDarkMode),
                    ),
                  ],
                ),
              ),
              items: IncidentFormController.availableCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.controlText(isDarkMode),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  controller.setCategory(value);
                }
              },
              dropdownColor: AppColors.surface(isDarkMode),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.iconSecondary(isDarkMode),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prioridad', style: AppTextStyles.controlText(isDarkMode)),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.priority,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seleccionar prioridad',
                      style: AppTextStyles.placeholderText(isDarkMode),
                    ),
                  ],
                ),
              ),
              items: IncidentFormController.availablePriorities.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        _getPriorityIcon(priority),
                        const SizedBox(width: 8),
                        Text(
                          priority,
                          style: AppTextStyles.controlText(isDarkMode),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  controller.setPriority(value);
                }
              },
              dropdownColor: AppColors.surface(isDarkMode),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.iconSecondary(isDarkMode),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDerivationField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Derivar a', style: AppTextStyles.controlText(isDarkMode)),
        AppSpacing.compactV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.derivateTo.isNotEmpty
                  ? controller.derivateTo
                  : null,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.forward,
                      size: 16,
                      color: AppColors.iconSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seleccionar derivación',
                      style: AppTextStyles.placeholderText(isDarkMode),
                    ),
                  ],
                ),
              ),
              items: IncidentFormController.availableDerivations.map((
                derivation,
              ) {
                return DropdownMenuItem(
                  value: derivation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      derivation,
                      style: AppTextStyles.controlText(isDarkMode),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  controller.setDerivateTo(value);
                }
              },
              dropdownColor: AppColors.surface(isDarkMode),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.iconSecondary(isDarkMode),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotifyParentField(
    IncidentFormController controller,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.fieldContainer(isDarkMode),
      child: Row(
        children: [
          Checkbox(
            value: controller.notifyParent,
            onChanged: (value) {
              controller.setNotifyParent(value ?? false);
            },
            activeColor: AppColors.primary,
          ),
          AppSpacing.smH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notificar a Apoderado',
                  style: AppTextStyles.sectionTitle(isDarkMode),
                ),
                Text(
                  'Enviar notificación automática al apoderado del estudiante',
                  style: AppTextStyles.secondaryText(isDarkMode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Baja':
        return Icon(Icons.arrow_downward, size: 12, color: AppColors.success);
      case 'Normal':
        return Icon(Icons.remove, size: 12, color: Colors.orange);
      case 'Alta':
        return Icon(Icons.arrow_upward, size: 12, color: Colors.red);
      case 'Urgente':
        return Icon(Icons.priority_high, size: 12, color: Colors.red);
      default:
        return Icon(Icons.remove, size: 12, color: Colors.grey);
    }
  }
}
