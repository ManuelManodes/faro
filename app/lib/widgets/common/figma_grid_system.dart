import 'package:flutter/material.dart';

/// Sistema de grillas basado en Figma - 12 columnas
class FigmaGridSystem {
  // Configuración de la grilla
  static const int totalColumns = 12;
  static const double gutterWidth = 16.0;
  static const double containerMaxWidth = 1200.0; // Ancho máximo del contenedor

  // Breakpoints responsive
  static const double mobileBreakpoint = 375.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;

  // Márgenes laterales según breakpoint
  static double getMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < tabletBreakpoint) {
      return 16.0; // Mobile
    } else if (screenWidth < desktopBreakpoint) {
      return 32.0; // Tablet
    } else {
      return 48.0; // Desktop
    }
  }

  // Ancho disponible para el contenido
  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final margin = getMargin(context) * 2; // Márgenes izquierdo y derecho
    final contentWidth = screenWidth - margin;

    // No exceder el ancho máximo del contenedor
    return contentWidth > containerMaxWidth ? containerMaxWidth : contentWidth;
  }

  // Ancho de una columna
  static double getColumnWidth(BuildContext context) {
    final contentWidth = getContentWidth(context);
    final totalGutters = (totalColumns - 1) * gutterWidth;
    return (contentWidth - totalGutters) / totalColumns;
  }
}

/// Widget contenedor que implementa la grilla de 12 columnas
class FigmaGridContainer extends StatelessWidget {
  final Widget child;
  final bool centerContent;

  const FigmaGridContainer({
    super.key,
    required this.child,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final margin = FigmaGridSystem.getMargin(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: centerContent
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: FigmaGridSystem.containerMaxWidth,
                ),
                child: child,
              ),
            )
          : child,
    );
  }
}

/// Widget de fila que contiene columnas
class FigmaRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool wrap;

  const FigmaRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.wrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (wrap) {
      return Wrap(
        spacing: FigmaGridSystem.gutterWidth,
        runSpacing: FigmaGridSystem.gutterWidth,
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _addGutters(children),
    );
  }

  List<Widget> _addGutters(List<Widget> children) {
    if (children.isEmpty) return children;

    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: FigmaGridSystem.gutterWidth));
      }
    }
    return result;
  }
}

/// Widget de columna que especifica cuántas columnas ocupa
class FigmaColumn extends StatelessWidget {
  final int columns;
  final Widget child;
  final int? mobileColumns;
  final int? tabletColumns;

  const FigmaColumn({
    super.key,
    required this.columns,
    required this.child,
    this.mobileColumns,
    this.tabletColumns,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determinar cuántas columnas usar según el breakpoint
    int effectiveColumns = columns;
    if (screenWidth < FigmaGridSystem.tabletBreakpoint &&
        mobileColumns != null) {
      effectiveColumns = mobileColumns!;
    } else if (screenWidth < FigmaGridSystem.desktopBreakpoint &&
        tabletColumns != null) {
      effectiveColumns = tabletColumns!;
    }

    // Calcular el ancho
    final columnWidth = FigmaGridSystem.getColumnWidth(context);
    final totalGutters = (effectiveColumns - 1) * FigmaGridSystem.gutterWidth;
    final width = (columnWidth * effectiveColumns) + totalGutters;

    return SizedBox(width: width, child: child);
  }
}

/// Widget helper para espacios entre columnas
class FigmaGutter extends StatelessWidget {
  final double? customWidth;

  const FigmaGutter({super.key, this.customWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: customWidth ?? FigmaGridSystem.gutterWidth);
  }
}

/// Mixin para obtener información de la grilla en cualquier widget
mixin FigmaGridMixin {
  double getColumnWidth(BuildContext context) =>
      FigmaGridSystem.getColumnWidth(context);
  double getContentWidth(BuildContext context) =>
      FigmaGridSystem.getContentWidth(context);
  double getMargin(BuildContext context) => FigmaGridSystem.getMargin(context);

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < FigmaGridSystem.tabletBreakpoint;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= FigmaGridSystem.tabletBreakpoint &&
      MediaQuery.of(context).size.width < FigmaGridSystem.desktopBreakpoint;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= FigmaGridSystem.desktopBreakpoint;
}
