import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shortcuts.dart';

/// Campo de búsqueda reutilizable
class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool isCompact;

  const AppSearchField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.onTap,
    this.onSubmitted,
    this.onChanged,
    this.trailing,
    this.padding,
    this.constraints,
    this.isCompact = false,
  });

  factory AppSearchField.compact({
    Key? key,
    required TextEditingController controller,
    FocusNode? focusNode,
    String hintText = 'Find...',
    VoidCallback? onTap,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    Widget? trailing,
  }) {
    return AppSearchField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      onTap: onTap,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      trailing: trailing,
      isCompact: true,
      constraints: const BoxConstraints(maxWidth: 300, minWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding = isCompact
        ? (padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4))
        : (padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8));

    final effectiveConstraints = isCompact
        ? (constraints ?? const BoxConstraints(maxWidth: 300, minWidth: 200))
        : (constraints ?? const BoxConstraints(maxWidth: 420, minWidth: 260));

    return ConstrainedBox(
      constraints: effectiveConstraints,
      child: Container(
        height: isCompact ? 32 : null,
        padding: effectivePadding,
        decoration: isCompact
            ? _compactDecoration(theme)
            : AppContainerStyles.searchField,
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.black54,
              size: isCompact ? 16 : 20,
            ),
            SizedBox(width: isCompact ? 6 : 8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: isCompact
                    ? theme.textTheme.bodySmall
                    : theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle:
                      (isCompact
                              ? theme.textTheme.bodySmall
                              : theme.textTheme.bodyMedium)
                          ?.copyWith(color: theme.hintColor),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: isCompact ? 4 : 8,
                  ),
                ),
                onTap: onTap,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: isCompact ? 6 : 8),
              trailing!,
            ],
            // Indicador de shortcut "B"
            SizedBox(width: isCompact ? 6 : 8),
            const SearchShortcutIndicator(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _compactDecoration(ThemeData theme) {
    return BoxDecoration(
      color: Colors.white, // Cambié de #e9ecef a blanco
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: theme.dividerColor.withAlpha(120)),
    );
  }
}
