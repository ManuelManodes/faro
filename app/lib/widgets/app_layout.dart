import 'package:flutter/material.dart';
import 'header_widget.dart';
import 'content_container.dart';
import 'view_header_widget.dart';
import 'common/common.dart';

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

  void _onSelect(String label) {
    setState(() {
      _selected = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco puro para toda la pantalla
      // Sin SafeArea para que el header llegue hasta arriba
      body: Column(
        children: [
          // Header que llega hasta el tope de la pantalla
          Container(
            decoration: BoxDecoration(
              // Línea más delgada y suave entre el header y el área blanca
              border: Border(
                bottom: BorderSide(
                  // Línea más marcada: mayor alpha y grosor 1.0
                  color: Theme.of(context).dividerColor.withAlpha(60),
                  width: 1.0,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false, // Solo aplicar SafeArea abajo, no arriba
              child: HeaderWidget(selected: _selected, onSelect: _onSelect),
            ),
          ),

          // Espacio debajo del navbar horizontal que replica el nombre seleccionado
          // en un título blanco, y con un área para controles específicos.
          // Además el fondo del resto del layout será blanco.
          Container(
            color: AppColors.white,
            child: ViewHeaderWidget(title: _selected),
          ),

          // Contenedor flexible para contenido dinámico con fondo blanco
          ContentContainer(child: widget.child),
        ],
      ),
    );
  }
}
