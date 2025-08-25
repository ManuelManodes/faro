import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme.dart';

/// Widget reutilizable para botones de icono con efecto de pulsación
class PressableIconButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool showTooltipOnHover;

  const PressableIconButton({
    super.key,
    required this.icon,
    this.size = 14,
    this.color,
    this.onPressed,
    this.tooltip,
    this.showTooltipOnHover = true,
  });

  @override
  State<PressableIconButton> createState() => _PressableIconButtonState();
}

class _PressableIconButtonState extends State<PressableIconButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = widget.color ?? AppColors.textSecondary(isDarkMode);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: _isPressed
              ? (Matrix4.identity()..scale(0.9))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: widget.size, color: color),
              if (widget.showTooltipOnHover &&
                  _isHovered &&
                  widget.tooltip != null) ...[
                const SizedBox(width: 4),
                Text(
                  widget.tooltip!,
                  style: TextStyle(fontSize: 11, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget especializado para botones de copiar
class CopyButton extends StatelessWidget {
  final String textToCopy;
  final double size;
  final Color? color;
  final String tooltip;

  const CopyButton({
    super.key,
    required this.textToCopy,
    this.size = 14,
    this.color,
    this.tooltip = 'Copiar al portapapeles',
  });

  @override
  Widget build(BuildContext context) {
    return PressableIconButton(
      icon: Icons.copy,
      size: size,
      color: color,
      tooltip: tooltip,
      onPressed: () {
        Clipboard.setData(ClipboardData(text: textToCopy));
      },
    );
  }
}
