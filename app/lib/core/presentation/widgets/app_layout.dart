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
  String _selected = 'Panel Principal';

  @override
  void initState() {
    super.initState();
    // Registrar el callback para mostrar el modal de navegación
    SearchFocusManager().registerNavigationModal(_showNavigationModal);
  }

  @override
  void dispose() {
    SearchFocusManager().unregisterNavigationModal();
    super.dispose();
  }

  void _onSelect(String label) {
    setState(() {
      _selected = label;
    });
  }

  void _showNavigationModal() {
    NavigationModal.show(
      context,
      navigationItems: HeaderWidget.navItems,
      selectedItem: _selected,
      onItemSelected: _onSelect,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: AppColors.backgroundPrimary(isDarkMode),
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

              // Para Control de Asistencia, usar layout especial
              if (_selected == 'Control de Asistencia')
                Expanded(
                  child: ViewHeaderWidget(title: _selected),
                )
              else ...[
                // Espacio debajo del navbar horizontal para otras vistas
                Container(
                  color: AppColors.backgroundPrimary(isDarkMode),
                  child: ViewHeaderWidget(title: _selected),
                ),
                // Contenedor flexible para contenido dinámico
                Expanded(child: ContentContainer(child: widget.child)),
              ],

              // Footer moderno y minimalista
              const FooterWidget(),
            ],
          ),
        );
      },
    );
  }
}
