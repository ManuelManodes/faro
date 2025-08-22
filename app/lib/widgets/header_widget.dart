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
  bool _isSearching = false;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late List<String> _filteredItems;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _filteredItems = List.from(HeaderWidget.navItems);

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _isSearching) {
        setState(() => _isSearching = false);
        _removeOverlay();
      }
    });

    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      setState(() {
        if (q.isEmpty) {
          _filteredItems = List.from(HeaderWidget.navItems);
        } else {
          _filteredItems = HeaderWidget.navItems
              .where((s) => s.toLowerCase().contains(q))
              .toList();
        }
      });
      _overlayEntry?.markNeedsBuild();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _enterSearch() {
    setState(() => _isSearching = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
      _showOverlay();
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // close when tapping outside
              setState(() => _isSearching = false);
              _removeOverlay();
            },
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(
                0,
                40,
              ), // Ajustado para el campo más compacto
              child: Align(
                alignment: Alignment.topRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                    minWidth: 200,
                  ),
                  child: _buildSearchResults(Theme.of(context)),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
        CompositedTransformTarget(
          link: _layerLink,
          child: AppSearchField.compact(
            controller: _searchController,
            focusNode: _searchFocusNode,
            hintText: 'Find...',
            onTap: () {
              if (!_isSearching) _enterSearch();
            },
            onSubmitted: (_) {
              if (_filteredItems.isNotEmpty) {
                widget.onSelect(_filteredItems.first);
              }
              setState(() => _isSearching = false);
              _removeOverlay();
            },
          ),
        ),
        AppSpacing.smH,
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

  Widget _buildSearchResults(ThemeData theme) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      shadowColor: Colors.black.withAlpha(30),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: const Color(0xFFE9ECEF), // #e9ecef (era blanco)
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withAlpha(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header del dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white, // El header ahora es blanco (era gris)
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Todos los favoritos',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Lista de elementos
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final label = _filteredItems[idx];
                  final bool isSelected = label == widget.selected;
                  return _buildDropdownItem(label, isSelected, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String label, bool isSelected, ThemeData theme) {
    return InkWell(
      onTap: () {
        widget.onSelect(label);
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
        _removeOverlay();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: isSelected
            ? Colors.blue.withAlpha(20)
            : Colors.white, // Fondo blanco para items
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _iconForLabel(label),
                size: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Team',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('observ')) return Icons.remove_red_eye_outlined;
    if (l.contains('flag')) return Icons.visibility;
    if (l.contains('usage')) return Icons.pie_chart_outline;
    if (l.contains('storage')) return Icons.storage_outlined;
    if (l.contains('deploy')) return Icons.cloud_upload_outlined;
    if (l.contains('integrat')) return Icons.extension_outlined;
    if (l.contains('settings')) return Icons.settings_outlined;
    if (l.contains('ai')) return Icons.smart_toy_outlined;
    if (l.contains('support')) return Icons.headset_mic_outlined;
    return Icons.folder_open_outlined;
  }
}
