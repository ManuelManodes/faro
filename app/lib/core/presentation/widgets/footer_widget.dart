import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/common.dart';

/// Footer moderno y minimalista con botón de cambio de tema
class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

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
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
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
        // Logo del sistema
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(Icons.location_on, size: 12, color: Colors.white),
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
    final footerLinks = [
      {'text': 'Documentación', 'url': 'https://docs.sistema-faro.com'},
      {'text': 'Soporte Técnico', 'url': 'https://support.sistema-faro.com'},
      {'text': 'Centro de Ayuda', 'url': 'https://help.sistema-faro.com'},
      {'text': 'Contacto', 'url': 'mailto:contacto@sistema-faro.com'},
      {
        'text': 'Política de Privacidad',
        'url': 'https://sistema-faro.com/privacy',
      },
      {'text': 'Términos de Uso', 'url': 'https://sistema-faro.com/terms'},
    ];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return footerLinks.map((link) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _openExternalLink(context, link['url']!, link['text']!);
          },
          child: Text(
            link['text']!,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _openExternalLink(
    BuildContext context,
    String url,
    String linkName,
  ) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Abre en nueva pestaña
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text('$linkName abierto en nueva pestaña')),
                ],
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('No se pudo abrir la URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('Error al abrir $linkName')),
              ],
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Copiar URL',
              textColor: Colors.white,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL copiada al portapapeles'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ),
        );
      }
    }
  }

  Widget _buildCopyright(bool isDarkMode) {
    return Text(
      '© 2025, Sistema de Gestión Faro',
      style: TextStyle(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.6)
            : Colors.black.withValues(alpha: 0.6),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSystemStatus(bool isDarkMode) {
    return Row(
      children: [
        // Indicador de estado parpadeante
        AnimatedBuilder(
          animation: _blinkAnimation,
          builder: (context, child) {
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: _blinkAnimation.value),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
        AppSpacing.smH,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sistema operativo',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.black.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'v1.0.0 - Estable',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
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
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.1),
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
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive
                ? Border.all(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? textColor : textColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
