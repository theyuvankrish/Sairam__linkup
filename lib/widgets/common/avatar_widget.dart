// lib/widgets/common/avatar_widget.dart
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';

class AvatarWidget extends StatelessWidget {
  final String? initials;
  final String? name;
  final double size;
  final double? radius;
  final UserRole? role;
  final Color? color;

  const AvatarWidget({
    super.key,
    this.initials,
    this.name,
    this.size = 44,
    this.radius,
    this.role,
    this.color,
  });

  String get _displayInitials {
    if (initials != null && initials!.isNotEmpty) return initials!;
    if (name != null && name!.trim().isNotEmpty) {
      final parts = name!.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  double get _actualSize => radius != null ? radius! * 2 : size;

  Color _colorFor() {
    if (color != null) return color!;
    if (role == null) return AppColors.primary;
    switch (role!) {
      case UserRole.student: return AppColors.primary;
      case UserRole.staff: return AppColors.secondary;
      case UserRole.alumni: return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _colorFor();
    final s = _actualSize;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(s * 0.3),
        border: Border.all(color: bg.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _displayInitials,
        style: TextStyle(
          color: bg,
          fontWeight: FontWeight.w700,
          fontSize: s * 0.38,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class RoleBadge extends StatelessWidget {
  final UserRole role;

  const RoleBadge({super.key, required this.role});

  Color get _color {
    switch (role) {
      case UserRole.student: return AppColors.primary;
      case UserRole.staff: return AppColors.secondary;
      case UserRole.alumni: return const Color(0xFF8B5CF6);
    }
  }

  String get _label {
    switch (role) {
      case UserRole.student: return 'Student';
      case UserRole.staff: return 'Staff';
      case UserRole.alumni: return 'Alumni';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
