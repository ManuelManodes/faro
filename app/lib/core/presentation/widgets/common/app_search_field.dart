import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'theme_provider.dart';

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);
        final isDarkMode = themeProvider.isDarkMode;

        final effectivePadding = isCompact
            ? (padding ??
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4))
            : (padding ??
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8));

        final effectiveConstraints = isCompact
            ? (constraints ??
                  const BoxConstraints(maxWidth: 300, minWidth: 200))
            : (constraints ??
                  const BoxConstraints(maxWidth: 420, minWidth: 260));

        return ConstrainedBox(
          constraints: effectiveConstraints,
          child: Container(
            height: isCompact ? 32 : null,
            padding: effectivePadding,
            decoration: isCompact
                ? _compactDecoration(theme, isDarkMode)
                : _fullDecoration(theme, isDarkMode),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  size: isCompact ? 16 : 20,
                ),
                SizedBox(width: isCompact ? 6 : 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style:
                        (isCompact
                                ? theme.textTheme.bodySmall
                                : theme.textTheme.bodyMedium)
                            ?.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle:
                          (isCompact
                                  ? theme.textTheme.bodySmall
                                  : theme.textTheme.bodyMedium)
                              ?.copyWith(
                                color: isDarkMode
                                    ? Colors.white54
                                    : Colors.black54,
                              ),
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
              ],
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _compactDecoration(ThemeData theme, bool isDarkMode) {
    return BoxDecoration(
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isDarkMode
            ? Colors.white.withOpacity(0.2)
            : theme.dividerColor.withAlpha(120),
      ),
    );
  }

  BoxDecoration _fullDecoration(ThemeData theme, bool isDarkMode) {
    return BoxDecoration(
      color: isDarkMode ? const Color(0xFF2A2A2A) : AppColors.white,
      borderRadius: AppBorderRadius.md,
      border: Border.all(
        color: isDarkMode ? Colors.white.withOpacity(0.2) : AppColors.divider,
      ),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.black.withOpacity(0.3) : AppColors.shadow,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
