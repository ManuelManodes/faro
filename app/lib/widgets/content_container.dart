import 'package:flutter/material.dart';
import 'common/common.dart';

/// Contenedor flexible para contenido dinámico de las vistas secundarias.
/// Simplemente expone un `child` y asegura que ocupe el espacio restante.
class ContentContainer extends StatelessWidget {
  final Widget child;
  const ContentContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        // Fondo blanco para el área principal de contenido
        color: AppColors.white,
        child: child,
      ),
    );
  }
}
