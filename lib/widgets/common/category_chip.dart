// lib/widgets/common/category_chip.dart
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';

Color categoryColor(AnnouncementCategory cat) {
  switch (cat) {
    case AnnouncementCategory.academic: return AppColors.academic;
    case AnnouncementCategory.cultural: return AppColors.cultural;
    case AnnouncementCategory.technical: return AppColors.technical;
    case AnnouncementCategory.career: return AppColors.career;
    case AnnouncementCategory.placement: return AppColors.secondary;
    case AnnouncementCategory.exam: return AppColors.warning;
    case AnnouncementCategory.event: return AppColors.cultural;
    case AnnouncementCategory.general: return AppColors.general;
  }
}

Color eventCategoryColor(EventCategory cat) {
  switch (cat) {
    case EventCategory.workshop: return AppColors.technical;
    case EventCategory.cultural: return AppColors.cultural;
    case EventCategory.technical: return AppColors.academic;
    case EventCategory.career: return AppColors.career;
    case EventCategory.sports: return AppColors.sports;
    case EventCategory.academic: return AppColors.academic;
    case EventCategory.department: return AppColors.primary;
  }
}

class CategoryBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool small;

  const CategoryBadge({super.key, required this.label, required this.color, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 10, vertical: small ? 3 : 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class FilterChipRow extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<Color>? colors;

  const FilterChipRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selectedIndex;
          final color = colors != null ? colors![i % colors!.length] : AppColors.primary;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : AppColors.border,
                    width: isSelected ? 0 : 1,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: color.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))]
                      : [BoxShadow(color: AppColors.border.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
