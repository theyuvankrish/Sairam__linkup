// lib/widgets/common/clay_card.dart
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double elevation;
  final Color? shadowColor;
  final Border? border;

  const ClayCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = 20,
    this.padding,
    this.onTap,
    this.elevation = 6,
    this.shadowColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.surface;
    final shadow = shadowColor ?? AppColors.primary.withOpacity(0.10);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ?? Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: elevation * 2.5,
              offset: Offset(0, elevation * 0.6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: elevation,
              offset: Offset(-elevation * 0.3, -elevation * 0.3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? tint;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.tint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: (tint ?? Colors.white).withOpacity(0.75),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
