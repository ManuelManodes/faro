import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

/// Modal de navegación que se abre desde el centro de la pantalla
class NavigationModal extends StatefulWidget {
  /// Obtiene el shortcut correcto según la plataforma
  static String getShortcutText() {
    // Detectar macOS usando defaultTargetPlatform
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return '⌘ + b';
    } else {
      return 'Ctrl + b';
    }
  }

  final List<String> navigationItems;
  final String selectedItem;
  final ValueChanged<String> onItemSelected;

  const NavigationModal({
    super.key,
    required this.navigationItems,
    required this.selectedItem,
    required this.onItemSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required List<String> navigationItems,
    required String selectedItem,
    required ValueChanged<String> onItemSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => NavigationModal(
        navigationItems: navigationItems,
        selectedItem: selectedItem,
        onItemSelected: onItemSelected,
      ),
    );
  }

  @override
  State<NavigationModal> createState() => _NavigationModalState();
}

class _NavigationModalState extends State<NavigationModal>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late FocusNode _searchFocusNode;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  int _selectedIndex = 0;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    // Inicializar controladores
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    // Configurar animaciones
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Inicializar estado
    _filteredItems = List.from(widget.navigationItems);
    _selectedIndex = widget.navigationItems.indexOf(widget.selectedItem);
    if (_selectedIndex == -1) _selectedIndex = 0;

    // Configurar listeners
    _searchController.addListener(_onSearchChanged);

    // Iniciar animación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward().then((_) {
          if (mounted) {
            _searchFocusNode.requestFocus();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (!mounted) return;

    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.navigationItems);
        _selectedIndex = widget.navigationItems.indexOf(widget.selectedItem);
        if (_selectedIndex == -1) _selectedIndex = 0;
      } else {
        _filteredItems = widget.navigationItems
            .where((item) => item.toLowerCase().contains(query))
            .toList();
        if (_filteredItems.isNotEmpty) {
          _selectedIndex = 0;
        }
      }
    });

    // Scroll automático cuando se filtra
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _filteredItems.isNotEmpty) {
        _scrollToSelectedItem();
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          if (_filteredItems.isNotEmpty) {
            setState(() {
              _selectedIndex = (_selectedIndex - 1) % _filteredItems.length;
              if (_selectedIndex < 0) {
                _selectedIndex = _filteredItems.length - 1;
              }
            });
            _scrollToSelectedItem();
          }
          break;
        case LogicalKeyboardKey.arrowDown:
          if (_filteredItems.isNotEmpty) {
            setState(() {
              _selectedIndex = (_selectedIndex + 1) % _filteredItems.length;
            });
            _scrollToSelectedItem();
          }
          break;
        case LogicalKeyboardKey.enter:
          _selectCurrentItem();
          break;
        case LogicalKeyboardKey.escape:
          _closeModal();
          break;
        case LogicalKeyboardKey.tab:
          if (_filteredItems.isNotEmpty) {
            setState(() {
              _selectedIndex = (_selectedIndex + 1) % _filteredItems.length;
            });
            _scrollToSelectedItem();
          }
          break;
      }
    }
  }

  void _scrollToSelectedItem() {
    if (_filteredItems.isNotEmpty && _scrollController.hasClients) {
      // Calcular altura real del item incluyendo padding y separador
      final itemPadding = MediaQuery.of(context).size.height > 800
          ? 16.0
          : 12.0;
      final itemMargin = 1.0;
      final separatorHeight = 2.0;
      final itemHeight =
          (itemPadding * 2) +
          40 +
          itemMargin +
          separatorHeight; // 40 es altura del contenido del item

      // Obtener altura real del contenedor
      final containerHeight = MediaQuery.of(context).size.height * 0.4;
      final listPadding = 16.0;
      final availableHeight = containerHeight - (listPadding * 2);
      final visibleItems = (availableHeight / itemHeight).floor();

      // Calcular la posición para centrar el item seleccionado
      double targetScrollOffset;

      if (_selectedIndex < visibleItems / 2) {
        // Si está en la primera mitad, scroll al inicio
        targetScrollOffset = 0;
      } else if (_selectedIndex >= _filteredItems.length - (visibleItems / 2)) {
        // Si está en la última mitad, scroll al final
        targetScrollOffset = _scrollController.position.maxScrollExtent;
      } else {
        // Centrar el item
        targetScrollOffset =
            (_selectedIndex * itemHeight) -
            (availableHeight / 2) +
            (itemHeight / 2);
      }

      // Aplicar límites para evitar scroll fuera de rango
      final clampedOffset = targetScrollOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutQuart,
      );
    }
  }

  void _selectCurrentItem() {
    if (_filteredItems.isNotEmpty) {
      final selectedItem = _filteredItems[_selectedIndex];
      widget.onItemSelected(selectedItem);
      _closeModal();
    }
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return GestureDetector(
          onTap: _closeModal,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: _handleKeyEvent,
                        child: GestureDetector(
                          onTap:
                              () {}, // Prevenir que se cierre al tocar el contenido
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width > 1200
                                  ? 450
                                  : MediaQuery.of(context).size.width > 768
                                  ? 380
                                  : MediaQuery.of(context).size.width * 0.85,
                              minWidth: MediaQuery.of(context).size.width > 768
                                  ? 350
                                  : 280,
                              maxHeight:
                                  MediaQuery.of(context).size.height > 800
                                  ? MediaQuery.of(context).size.height * 0.75
                                  : MediaQuery.of(context).size.height * 0.85,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withValues(alpha: 0.4)
                                      : Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header con campo de búsqueda
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width > 1200
                                        ? 28
                                        : MediaQuery.of(context).size.width >
                                              768
                                        ? 24
                                        : MediaQuery.of(context).size.width >
                                              480
                                        ? 20
                                        : 16,
                                    vertical:
                                        MediaQuery.of(context).size.height > 800
                                        ? 24
                                        : MediaQuery.of(context).size.height >
                                              600
                                        ? 20
                                        : 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.grey.withValues(alpha: 0.05),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.navigation,
                                            size: 18,
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.grey[600],
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Ir a página',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.grey[800],
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDarkMode
                                                  ? Colors.white.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: 0.1,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              NavigationModal.getShortcutText(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isDarkMode
                                                    ? Colors.white70
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Campo de búsqueda
                                      TextField(
                                        focusNode: _searchFocusNode,
                                        controller: _searchController,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Escribe para buscar...',
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: isDarkMode
                                                ? Colors.white54
                                                : Colors.grey[600],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: isDarkMode
                                                  ? Colors.white.withValues(
                                                      alpha: 0.2,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: 0.3,
                                                    ),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: isDarkMode
                                                  ? Colors.white.withValues(
                                                      alpha: 0.2,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: 0.3,
                                                    ),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: isDarkMode
                                                  ? Colors.white.withValues(
                                                      alpha: 0.4,
                                                    )
                                                  : Colors.blue.withValues(
                                                      alpha: 0.6,
                                                    ),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: isDarkMode
                                              ? Colors.white.withValues(
                                                  alpha: 0.05,
                                                )
                                              : Colors.grey.withValues(
                                                  alpha: 0.05,
                                                ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width >
                                                    1200
                                                ? 16
                                                : MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      768
                                                ? 14
                                                : 12,
                                            vertical:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.height >
                                                    800
                                                ? 12
                                                : 10,
                                          ),
                                          isDense: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Lista de opciones
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                  ),
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width >
                                              1200
                                          ? 28
                                          : MediaQuery.of(context).size.width >
                                                768
                                          ? 24
                                          : MediaQuery.of(context).size.width >
                                                480
                                          ? 20
                                          : 16,
                                      vertical: 16,
                                    ),
                                    itemCount: _filteredItems.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 2),
                                    itemBuilder: (context, index) {
                                      return _buildDropdownItem(
                                        _filteredItems[index],
                                        index == _selectedIndex,
                                        isDarkMode,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownItem(String item, bool isSelected, bool isDarkMode) {
    final isCurrentItem = item == widget.selectedItem;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDarkMode
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.blue.withValues(alpha: 0.08))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          widget.onItemSelected(item);
          _closeModal();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 16 : 12,
            vertical: MediaQuery.of(context).size.height > 800 ? 16 : 12,
          ),
          child: Row(
            children: [
              // Icono
              Container(
                width: MediaQuery.of(context).size.width > 600 ? 40 : 36,
                height: MediaQuery.of(context).size.width > 600 ? 40 : 36,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForItem(item),
                  size: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(width: 14),
              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isCurrentItem
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (isCurrentItem)
                      Text(
                        'Página actual',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              // Indicadores
              if (isCurrentItem)
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: isDarkMode ? Colors.green[400] : Colors.green[600],
                ),
              if (isSelected && !isCurrentItem)
                Icon(
                  Icons.arrow_right,
                  size: 18,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForItem(String item) {
    final l = item.toLowerCase();

    // Opciones del menú principal en español
    if (l.contains('panel principal') || l.contains('dashboard')) {
      return Icons.dashboard;
    }
    if (l.contains('control de asistencia') || l.contains('asistencia')) {
      return Icons.people;
    }
    if (l.contains('agenda') || l.contains('calendario')) {
      return Icons.event;
    }
    if (l.contains('evaluaciones') || l.contains('assessment')) {
      return Icons.assessment;
    }
    if (l.contains('asistente virtual') ||
        l.contains('asistente') ||
        l.contains('ai')) {
      return Icons.smart_toy;
    }

    // Fallbacks para otros casos
    if (l.contains('overview')) return Icons.dashboard_outlined;
    if (l.contains('integrat')) return Icons.extension_outlined;
    if (l.contains('deploy')) return Icons.cloud_upload_outlined;
    if (l.contains('activity')) return Icons.timeline_outlined;
    if (l.contains('domain')) return Icons.language_outlined;
    if (l.contains('usage')) return Icons.pie_chart_outline;
    if (l.contains('observ')) return Icons.remove_red_eye_outlined;
    if (l.contains('storage')) return Icons.storage_outlined;
    if (l.contains('flag')) return Icons.flag_outlined;
    if (l.contains('support')) return Icons.headset_mic_outlined;
    if (l.contains('setting')) return Icons.settings_outlined;

    return Icons.folder_open_outlined;
  }
}
