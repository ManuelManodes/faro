import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/common.dart';

/// Contenedor flexible para contenido dinámico de las vistas secundarias.
/// Simplemente expone un `child` y asegura que ocupe el espacio restante.
class ContentContainer extends StatelessWidget {
  final Widget child;
  const ContentContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Expanded(
          child: Container(
            color: isDarkMode
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFFAFAFA),
            child: FigmaGridContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
