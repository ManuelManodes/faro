import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'figma_grid_system.dart';
import 'theme_provider.dart';

/// Sistema de layout flexible que permite diferentes tipos de vistas
/// sin necesidad de modificar el ViewHeaderWidget central
class FlexibleLayout extends StatelessWidget {
  final String title;
  final Widget? headerControls;
  final Widget content;
  final LayoutType layoutType;
  final bool useFullWidth;
  final EdgeInsets? padding;

  const FlexibleLayout({
    super.key,
    required this.title,
    this.headerControls,
    required this.content,
    this.layoutType = LayoutType.standard,
    this.useFullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        switch (layoutType) {
          case LayoutType.fullscreen:
            return _buildFullscreenLayout(context, isDarkMode);
          case LayoutType.centered:
            return _buildCenteredLayout(context, isDarkMode);
          case LayoutType.standard:
            return _buildStandardLayout(context, isDarkMode);
        }
      },
    );
  }

  Widget _buildStandardLayout(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        // Header estándar
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary(isDarkMode),
            border: Border(
              bottom: BorderSide(
                color: AppColors.dividerTheme(isDarkMode),
                width: 1.0,
              ),
            ),
          ),
          height: 80,
          child: FigmaGridContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                const Spacer(),
                if (headerControls != null) headerControls!,
              ],
            ),
          ),
        ),
        // Contenido
        Expanded(
          child: useFullWidth
              ? content
              : FigmaGridContainer(
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(24.0),
                    child: content,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCenteredLayout(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        // Header minimalista
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary(isDarkMode),
            border: Border(
              bottom: BorderSide(
                color: AppColors.dividerTheme(isDarkMode),
                width: 1.0,
              ),
            ),
          ),
          height: 60,
          child: FigmaGridContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                const Spacer(),
                if (headerControls != null) headerControls!,
              ],
            ),
          ),
        ),
        // Contenido centrado
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(24.0),
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullscreenLayout(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        // Header con controles
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary(isDarkMode),
            border: Border(
              bottom: BorderSide(
                color: AppColors.dividerTheme(isDarkMode),
                width: 1.0,
              ),
            ),
          ),
          height: 80,
          child: FigmaGridContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                const Spacer(),
                if (headerControls != null) headerControls!,
              ],
            ),
          ),
        ),
        // Contenido fullscreen
        Expanded(child: content),
      ],
    );
  }
}

/// Tipos de layout disponibles
enum LayoutType {
  standard, // Layout estándar con grid
  centered, // Layout centrado para formularios
  fullscreen, // Layout fullscreen para dashboards
}

/// Widget simplificado para grid automático
class AutoGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final int? mobileColumns;
  final int? tabletColumns;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const AutoGrid({
    super.key,
    required this.children,
    this.columns = 3,
    this.mobileColumns,
    this.tabletColumns,
    this.spacing = 16.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determinar columnas efectivas
    int effectiveColumns = columns;
    if (screenWidth < FigmaGridSystem.tabletBreakpoint &&
        mobileColumns != null) {
      effectiveColumns = mobileColumns!;
    } else if (screenWidth < FigmaGridSystem.desktopBreakpoint &&
        tabletColumns != null) {
      effectiveColumns = tabletColumns!;
    }

    // Si es mobile o tablet, usar Wrap
    if (effectiveColumns == 1 ||
        screenWidth < FigmaGridSystem.tabletBreakpoint) {
      return Wrap(spacing: spacing, runSpacing: spacing, children: children);
    }

    // Para desktop, usar GridView
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: effectiveColumns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.2,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Widget para contenido simple sin grid
class SimpleContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool centerContent;
  final double? maxWidth;

  const SimpleContent({
    super.key,
    required this.child,
    this.padding,
    this.centerContent = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (maxWidth != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: content,
      );
    }

    if (centerContent) {
      content = Center(child: content);
    }

    return Padding(
      padding: padding ?? const EdgeInsets.all(24.0),
      child: content,
    );
  }
}

/// Mixin para facilitar la creación de vistas independientes
mixin FlexibleViewMixin {
  Widget buildFlexibleView({
    required String title,
    required Widget content,
    Widget? headerControls,
    LayoutType layoutType = LayoutType.standard,
    bool useFullWidth = false,
    EdgeInsets? padding,
  }) {
    return FlexibleLayout(
      title: title,
      headerControls: headerControls,
      content: content,
      layoutType: layoutType,
      useFullWidth: useFullWidth,
      padding: padding,
    );
  }
}
