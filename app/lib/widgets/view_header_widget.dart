import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/common.dart';

/// Widget que muestra el título actual seleccionado en la navegación y un
/// espacio para controlar elementos específicos de la vista (placeholders).
class ViewHeaderWidget extends StatelessWidget {
  final String title;

  const ViewHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFFAFAFA),
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 1.0),
            ),
          ),
          height: 80,
          child: FigmaGridContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                _buildViewControls(),
              ],
            ),
          ),
        );
      },
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
