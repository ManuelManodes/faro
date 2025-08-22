import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/common.dart';

/// Footer moderno y minimalista con botón de cambio de tema
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  void _toggleTheme(ThemeProvider themeProvider, ThemeType newTheme) {
    themeProvider.setTheme(newTheme);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFF8F9FA),
            border: Border(
              top: BorderSide(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
                width: 1.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: FigmaGridSystem.getMargin(context),
            vertical: AppSpacing.lg,
          ),
          child: FigmaGridContainer(
            centerContent: false,
            child: _buildFooterContent(context, themeProvider, isDarkMode),
          ),
        );
      },
    );
  }

  Widget _buildFooterContent(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDarkMode,
  ) {
    final isMobile =
        MediaQuery.of(context).size.width < FigmaGridSystem.tabletBreakpoint;

    if (isMobile) {
      return _buildMobileLayout(context, themeProvider, isDarkMode);
    } else {
      return _buildDesktopLayout(context, themeProvider, isDarkMode);
    }
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lado izquierdo: Logo, navegación y copyright
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoAndNavigation(context, isDarkMode),
              AppSpacing.mdV,
              _buildCopyright(isDarkMode),
            ],
          ),
        ),

        // Lado derecho: Estado del sistema y botones de tema
        Row(
          children: [
            _buildSystemStatus(isDarkMode),
            AppSpacing.lgH,
            _buildThemeToggle(context, themeProvider, isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo y navegación
        _buildLogoAndNavigation(context, isDarkMode),
        AppSpacing.lgV,

        // Estado del sistema y botones de tema
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSystemStatus(isDarkMode),
            _buildThemeToggle(context, themeProvider, isDarkMode),
          ],
        ),
        AppSpacing.lgV,

        // Copyright
        _buildCopyright(isDarkMode),
      ],
    );
  }

  Widget _buildLogoAndNavigation(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        // Logo triangular
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(Icons.play_arrow, size: 12, color: Colors.white),
        ),
        AppSpacing.mdH,

        // Enlaces de navegación
        Expanded(
          child: Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: _buildNavigationLinks(context, isDarkMode),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildNavigationLinks(BuildContext context, bool isDarkMode) {
    final links = ['Home', 'Docs', 'Guides', 'Help', 'Contact'];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return links.map((link) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // Aquí se implementaría la navegación
          },
          child: Text(
            link,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCopyright(bool isDarkMode) {
    return Text(
      '© 2025, Faro Inc.',
      style: TextStyle(
        color: isDarkMode
            ? Colors.white.withOpacity(0.6)
            : Colors.black.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSystemStatus(bool isDarkMode) {
    return Row(
      children: [
        // Indicador de estado
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.smH,
        Text(
          'All systems normal',
          style: TextStyle(
            color: isDarkMode
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeButton(
            context: context,
            themeProvider: themeProvider,
            icon: Icons.desktop_windows,
            themeType: ThemeType.system,
            isActive: themeProvider.currentTheme == ThemeType.system,
            isDarkMode: isDarkMode,
          ),
          AppSpacing.xsH,
          _buildThemeButton(
            context: context,
            themeProvider: themeProvider,
            icon: Icons.light_mode,
            themeType: ThemeType.light,
            isActive: themeProvider.currentTheme == ThemeType.light,
            isDarkMode: isDarkMode,
          ),
          AppSpacing.xsH,
          _buildThemeButton(
            context: context,
            themeProvider: themeProvider,
            icon: Icons.dark_mode,
            themeType: ThemeType.dark,
            isActive: themeProvider.currentTheme == ThemeType.dark,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required IconData icon,
    required ThemeType themeType,
    required bool isActive,
    required bool isDarkMode,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _toggleTheme(themeProvider, themeType),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? (isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive
                ? Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? textColor : textColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
