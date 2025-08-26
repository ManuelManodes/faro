import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/common.dart';

/// Widget flexible que permite agregar widgets dinámicamente
/// sin necesidad de layouts específicos para cada vista
class FlexibleViewWidget extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Widget? headerControls;
  final Widget? content;
  final bool showHeader;

  const FlexibleViewWidget({
    super.key,
    required this.title,
    this.children = const [],
    this.headerControls,
    this.content,
    this.showHeader = true,
  });

  @override
  State<FlexibleViewWidget> createState() => _FlexibleViewWidgetState();
}

class _FlexibleViewWidgetState extends State<FlexibleViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          color: AppColors.backgroundPrimary(isDarkMode),
          child: Column(
            children: [
              // Header flexible
              if (widget.showHeader) _buildFlexibleHeader(isDarkMode),
              
              // Contenido flexible
              Expanded(
                child: _buildFlexibleContent(isDarkMode),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlexibleHeader(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary(isDarkMode),
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerTheme(isDarkMode),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(isDarkMode),
              ),
            ),
            
            // Controles del header (opcional)
            if (widget.headerControls != null) ...[
              const SizedBox(height: 16),
              widget.headerControls!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleContent(bool isDarkMode) {
    // Si hay contenido específico, usarlo
    if (widget.content != null) {
      return widget.content!;
    }

    // Si hay children, mostrarlos en un layout flexible
    if (widget.children.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.children,
        ),
      );
    }

    // Contenido por defecto
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard,
            size: 64,
            color: AppColors.textSecondary(isDarkMode),
          ),
          const SizedBox(height: 16),
          Text(
            'Vista: ${widget.title}',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega widgets usando el sistema flexible',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }
}
