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
        color: const Color(0xFFFAFAFA), // Fondo #FAFAFA
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(60),
            width: 1.0,
          ),
        ),
      ),
      height: 80,
      child: FigmaGridContainer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: theme.textTheme.headlineSmall),
            const Spacer(),
            _buildViewControls(),
          ],
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
