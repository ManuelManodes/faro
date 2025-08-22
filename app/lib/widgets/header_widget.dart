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
              height: 56,
              alignment: Alignment.centerLeft,
              color: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : AppColors.primaryDark,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.light_mode,
          size: 28,
          color: isDarkMode ? Colors.orangeAccent : Colors.orangeAccent,
        ),
        AppSpacing.mdH,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            'manodesdev',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppSpacing.smH,
        AppBadge.primary(text: 'Hobby'),
      ],
    );
  }

  Widget _buildRightControls(ThemeData theme, bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.feedback_outlined,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          tooltip: 'Feedback',
        ),
        AppSpacing.smH,
        AppAvatar.user(radius: 14),
      ],
    );
  }

  Widget _buildNavigationBar(bool isDarkMode) {
    return Container(
      height: 48,
      color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.primaryDark,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: HeaderWidget.navItems.map((label) {
              final bool isActive = label == widget.selected;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: _buildNavItem(label, isActive, isDarkMode),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive, bool isDarkMode) {
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
          ),
          child: Text(label),
        ),
        if (isActive)
          Container(
            height: 3,
            width: 28,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Colors.black,
              borderRadius: AppBorderRadius.xs,
            ),
          )
        else
          const SizedBox(height: 3),
      ],
    );
  }
}
