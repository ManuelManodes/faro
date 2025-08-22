import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/common.dart';

/// Header en dos niveles: top bar con logo/acciones y una barra de navegación
/// horizontal justo debajo. Stateful para manejar el modo búsqueda (UI-only).
class HeaderWidget extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const HeaderWidget({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  // Lista pública de elementos de navegación (estructura visual solamente)
  static const List<String> navItems = [
    'Overview',
    'Integrations',
    'Deployments',
    'Activity',
    'Domains',
    'Usage',
    'Observability',
    'Storage',
    'Flags',
    'AI Gateway',
    'Support',
    'Settings',
  ];

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);
        final isDarkMode = themeProvider.isDarkMode;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top bar
            Container(
              height: MediaQuery.of(context).size.height > 800 ? 64 : 56,
              alignment: Alignment.centerLeft,
              color: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : AppColors.primaryDark,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 1200
                      ? AppSpacing.xl
                      : MediaQuery.of(context).size.width > 800
                      ? AppSpacing.lg
                      : AppSpacing.md,
                ),
                child: Row(
                  children: [
                    // Left group
                    _buildLeftGroup(theme, isDarkMode),
                    const Spacer(),

                    // Right controls
                    _buildRightControls(theme, isDarkMode),
                  ],
                ),
              ),
            ),

            // Secondary nav
            _buildNavigationBar(isDarkMode),
          ],
        );
      },
    );
  }

  Widget _buildLeftGroup(ThemeData theme, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;
    final isMediumScreen = screenWidth < 1024;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.light_mode,
          size: isSmallScreen
              ? 24
              : isMediumScreen
              ? 26
              : 28,
          color: isDarkMode ? Colors.orangeAccent : Colors.orangeAccent,
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        if (!isSmallScreen) // Ocultar texto en pantallas pequeñas
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMediumScreen ? 150 : 200),
            child: Text(
              'manodesdev',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: isMediumScreen ? 14 : 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        SizedBox(width: isSmallScreen ? 4 : 8),
        AppBadge.primary(text: isSmallScreen ? 'H' : 'Hobby'),
      ],
    );
  }

  Widget _buildRightControls(ThemeData theme, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isSmallScreen) // Ocultar botón de feedback en pantallas pequeñas
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.feedback_outlined,
              size: isSmallScreen ? 20 : 24,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            tooltip: 'Feedback',
          ),
        if (!isSmallScreen) SizedBox(width: 8),
        AppAvatar.user(radius: isSmallScreen ? 12 : 14),
      ],
    );
  }

  Widget _buildNavigationBar(bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;
    final isMediumScreen = screenWidth < 1024;

    return Container(
      height: isSmallScreen ? 44 : 48,
      color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.primaryDark,
      width: double.infinity, // Asegurar que vaya de borde a borde
      child: Center(
        // Centrar el contenido
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 1200 ? 1200 : screenWidth,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 1200
                    ? AppSpacing.xl
                    : screenWidth > 800
                    ? AppSpacing.lg
                    : AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: HeaderWidget.navItems.map((label) {
                  final bool isActive = label == widget.selected;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen
                          ? 4
                          : isMediumScreen
                          ? 6
                          : 8,
                    ),
                    child: _buildNavItem(label, isActive, isDarkMode),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;
    final isMediumScreen = screenWidth < 1024;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => widget.onSelect(label),
          style: TextButton.styleFrom(
            foregroundColor: isActive
                ? (isDarkMode ? Colors.white : Colors.black)
                : (isDarkMode ? Colors.white70 : Colors.black87),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen
                  ? 8
                  : isMediumScreen
                  ? 12
                  : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            textStyle: TextStyle(
              fontSize: isSmallScreen
                  ? 12
                  : isMediumScreen
                  ? 13
                  : 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          child: Text(label),
        ),
        if (isActive)
          Container(
            height: isSmallScreen ? 2 : 3,
            width: isSmallScreen
                ? 20
                : isMediumScreen
                ? 24
                : 28,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Colors.black,
              borderRadius: AppBorderRadius.xs,
            ),
          )
        else
          SizedBox(height: isSmallScreen ? 2 : 3),
      ],
    );
  }
}
