import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

/// Dropdown minimalista para navegación rápida
class NavigationDropdown extends StatefulWidget {
  final List<String> navigationItems;
  final String selectedItem;
  final ValueChanged<String> onItemSelected;
  final VoidCallback? onClose;

  const NavigationDropdown({
    super.key,
    required this.navigationItems,
    required this.selectedItem,
    required this.onItemSelected,
    this.onClose,
  });

  @override
  State<NavigationDropdown> createState() => _NavigationDropdownState();
}

class _NavigationDropdownState extends State<NavigationDropdown>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late FocusNode _focusNode;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  int _selectedIndex = 0;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _filteredItems = List.from(widget.navigationItems);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Encontrar el índice del elemento seleccionado
    _selectedIndex = widget.navigationItems.indexOf(widget.selectedItem);
    if (_selectedIndex == -1) _selectedIndex = 0;

    // Listener para búsqueda por texto
    _searchController.addListener(_onSearchChanged);

    // Iniciar animación y enfocar
    _animationController.forward().then((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.navigationItems);
      } else {
        _filteredItems = widget.navigationItems
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
      _selectedIndex = 0; // Reset selection to first filtered item
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          if (_filteredItems.isNotEmpty) {
            _moveSelection(-1);
          }
          break;
        case LogicalKeyboardKey.arrowDown:
          if (_filteredItems.isNotEmpty) {
            _moveSelection(1);
          }
          break;
        case LogicalKeyboardKey.enter:
          _selectCurrentItem();
          break;
        case LogicalKeyboardKey.escape:
          _closeDropdown();
          break;
        case LogicalKeyboardKey.tab:
          if (_filteredItems.isNotEmpty) {
            _moveSelection(1);
          }
          break;
      }
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      _selectedIndex = (_selectedIndex + direction) % _filteredItems.length;
      if (_selectedIndex < 0) {
        _selectedIndex = _filteredItems.length - 1;
      }
    });

    // Scroll automático para mantener visible la selección
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_filteredItems.isNotEmpty && _scrollController.hasClients) {
        final itemHeight = 60.0; // Altura aproximada de cada item
        final containerHeight = 300.0; // Altura del contenedor
        final visibleItems = (containerHeight / itemHeight).floor();

        // Calcular si el item seleccionado está fuera de la vista
        final currentScrollOffset = _scrollController.offset;
        final itemTop = _selectedIndex * itemHeight;
        final itemBottom = itemTop + itemHeight;

        // Si el item está completamente fuera de la vista, hacer scroll
        final margin =
            itemHeight * 0.5; // Margen para evitar scroll innecesario
        if (itemTop < currentScrollOffset - margin ||
            itemBottom > currentScrollOffset + containerHeight + margin) {
          final targetScrollOffset =
              (_selectedIndex * itemHeight) -
              (containerHeight / 2) +
              (itemHeight / 2);
          _scrollController.animateTo(
            targetScrollOffset.clamp(
              0.0,
              _scrollController.position.maxScrollExtent,
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutQuart,
          );
        }
      }
    });
  }

  void _selectCurrentItem() {
    if (_filteredItems.isNotEmpty) {
      final selectedItem = _filteredItems[_selectedIndex];
      widget.onItemSelected(selectedItem);
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                        minWidth: 200,
                        maxHeight: 400,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF2A2A2A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),

                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey.withOpacity(0.05),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.navigation,
                                  size: 16,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ir a página',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.grey[800],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'B',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Lista de elementos
                          Flexible(
                            child: _filteredItems.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'No se encontraron resultados',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.separated(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: _filteredItems.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          height: 1,
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.1)
                                              : Colors.grey.withOpacity(0.1),
                                          indent: 16,
                                          endIndent: 16,
                                        ),
                                    itemBuilder: (context, index) {
                                      final item = _filteredItems[index];
                                      final isSelected =
                                          index == _selectedIndex;
                                      final isCurrentItem =
                                          item == widget.selectedItem;

                                      return _buildDropdownItem(
                                        item,
                                        isSelected,
                                        isCurrentItem,
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
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDropdownItem(
    String item,
    bool isSelected,
    bool isCurrentItem,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: () {
        widget.onItemSelected(item);
        _closeDropdown();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected
            ? (isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1))
            : Colors.transparent,
        child: Row(
          children: [
            // Icono
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getIconForItem(item),
                size: 16,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 12),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
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
                        fontSize: 12,
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
                size: 16,
                color: isDarkMode ? Colors.green[400] : Colors.green[600],
              ),
            if (isSelected && !isCurrentItem)
              Icon(
                Icons.arrow_right,
                size: 16,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForItem(String item) {
    final l = item.toLowerCase();
    if (l.contains('overview')) return Icons.dashboard_outlined;
    if (l.contains('integrat')) return Icons.extension_outlined;
    if (l.contains('deploy')) return Icons.cloud_upload_outlined;
    if (l.contains('activity')) return Icons.timeline_outlined;
    if (l.contains('domain')) return Icons.language_outlined;
    if (l.contains('usage')) return Icons.pie_chart_outline;
    if (l.contains('observ')) return Icons.remove_red_eye_outlined;
    if (l.contains('storage')) return Icons.storage_outlined;
    if (l.contains('flag')) return Icons.flag_outlined;
    if (l.contains('ai')) return Icons.smart_toy_outlined;
    if (l.contains('support')) return Icons.headset_mic_outlined;
    if (l.contains('setting')) return Icons.settings_outlined;
    return Icons.folder_open_outlined;
  }
}
