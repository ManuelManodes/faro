import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/common.dart';
import 'content_container.dart';
import 'footer_widget.dart';
import 'header_widget.dart';
import 'view_header_widget.dart';

/// Layout general que compone el Header, un título de vista y un contenedor
/// para el contenido. Mantiene el item seleccionado del navbar para mostrar
/// el título correspondiente.
class AppLayout extends StatefulWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  String _selected = HeaderWidget.navItems.contains('Flags')
      ? 'Flags'
      : HeaderWidget.navItems.first;
  OverlayEntry? _navigationOverlay;

  @override
  void initState() {
    super.initState();
    // Registrar el callback para mostrar el dropdown de navegación
    SearchFocusManager().registerNavigationDropdown(_showNavigationDropdown);
  }

  @override
  void dispose() {
    _removeNavigationOverlay();
    SearchFocusManager().unregisterNavigationDropdown();
    super.dispose();
  }

  void _onSelect(String label) {
    setState(() {
      _selected = label;
    });
    _removeNavigationOverlay();
  }

  void _showNavigationDropdown() {
    _removeNavigationOverlay();

    final overlay = Overlay.of(context);
    _showCenteredDropdown(overlay);
  }

  void _showCenteredDropdown(OverlayState overlay) {
    _navigationOverlay = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeNavigationOverlay,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: NavigationDropdown(
                  navigationItems: HeaderWidget.navItems,
                  selectedItem: _selected,
                  onItemSelected: _onSelect,
                  onClose: _removeNavigationOverlay,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_navigationOverlay!);
  }

  void _removeNavigationOverlay() {
    _navigationOverlay?.remove();
    _navigationOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
          body: Column(
            children: [
              // Header que llega hasta el tope de la pantalla
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1.0,
                    ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: HeaderWidget(selected: _selected, onSelect: _onSelect),
                ),
              ),

              // Espacio debajo del navbar horizontal
              Container(
                color: isDarkMode ? const Color(0xFF121212) : AppColors.white,
                child: ViewHeaderWidget(title: _selected),
              ),

              // Contenedor flexible para contenido dinámico
              Expanded(child: ContentContainer(child: widget.child)),

              // Footer moderno y minimalista
              const FooterWidget(),
            ],
          ),
        );
      },
    );
  }
}
