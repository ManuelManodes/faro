import 'package:flutter/material.dart';
import 'common/common.dart';

/// Widget que muestra el título actual seleccionado en la navegación y un
/// espacio para controlar elementos específicos de la vista (placeholders).
class ViewHeaderWidget extends StatelessWidget {
  final String title;

  const ViewHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(60),
            width: 1.0,
          ),
        ),
      ),
      child: FigmaGridContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: theme.textTheme.headlineSmall),
              const Spacer(),
              // Área para controles de vista específicos (placeholders)
              _buildViewControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewControls() {
    return Row(
      children: [
        // Ejemplo: botones de acciones de la vista
        AppSpacing.mdH,
      ],
    );
  }
}
