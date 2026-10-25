// lib/widgets/cards/person_card.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../app/theme/app_colors.dart';
import '../common/clay_card.dart';
import '../common/avatar_widget.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback? onTap;

  const PersonCard({super.key, required this.person, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClayCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AvatarWidget(initials: person.initials, size: 50, role: person.role),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(person.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                      RoleBadge(role: person.role),
                    ]),
                    const SizedBox(height: 3),
                    Text(person.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    if (person.skills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: person.skills.take(3).map((s) =>
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.clayBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(s, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500)),
                          ),
                        ).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
