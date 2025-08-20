import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Badge reutilizable para mostrar etiquetas
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  factory AppBadge.primary({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.primaryLight,
      textColor: AppColors.black,
    );
  }

  factory AppBadge.secondary({Key? key, required String text}) {
    return AppBadge(
      key: key,
      text: text,
      backgroundColor: AppColors.lightGrey,
      textColor: AppColors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary.withAlpha(24),
        borderRadius: borderRadius ?? AppBorderRadius.md,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(color: textColor),
      ),
    );
  }
}

/// Avatar reutilizable
class AppAvatar extends StatelessWidget {
  final double radius;
  final Widget? child;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;

  const AppAvatar({
    super.key,
    this.radius = 20,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
  });

  factory AppAvatar.user({Key? key, double radius = 20}) {
    return AppAvatar(
      key: key,
      radius: radius,
      child: Icon(Icons.person, size: radius * 0.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}
