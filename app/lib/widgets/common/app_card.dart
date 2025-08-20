import 'package:flutter/material.dart';

/// Widget reutilizable para tarjetas con diseño consistente
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  factory AppCard.elevated({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double elevation = 6,
    BorderRadius? borderRadius,
  }) {
    return AppCard(
      key: key,
      child: child,
      padding: padding,
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      backgroundColor: Colors.white,
    );
  }

  factory AppCard.outlined({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? borderColor,
    BorderRadius? borderRadius,
  }) {
    return AppCard(
      key: key,
      child: child,
      padding: padding,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      backgroundColor: Colors.white,
      border: Border.all(
        color: borderColor ?? Colors.grey.withAlpha(90),
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (elevation != null) {
      return Material(
        elevation: elevation!,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: backgroundColor ?? Colors.white,
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border,
        boxShadow: boxShadow,
      ),
      child: content,
    );
  }
}
