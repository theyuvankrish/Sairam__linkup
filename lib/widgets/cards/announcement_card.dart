// lib/widgets/cards/announcement_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../common/clay_card.dart';
import '../common/avatar_widget.dart';
import '../common/category_chip.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;

  const AnnouncementCard({super.key, required this.announcement, this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnnouncementProvider>();
    final isBookmarked = provider.isBookmarked(announcement.id);
    final color = categoryColor(announcement.category);

    Color cardBg = AppColors.surface;
    if (announcement.isPinned) cardBg = AppColors.clayBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClayCard(
        color: cardBg,
        shadowColor: color.withOpacity(0.12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar: pinned indicator + dept badge
            if (announcement.isPinned)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                ),
                child: Row(children: [
                  const Icon(Icons.push_pin_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text('Pinned', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ]),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              CategoryBadge(label: announcement.categoryLabel, color: color),
                              const SizedBox(width: 8),
                              if (!announcement.isCollegeWide)
                                CategoryBadge(
                                  label: announcement.targetDept?.shortName ?? '',
                                  color: AppColors.secondary,
                                  small: true,
                                ),
                              if (announcement.isCollegeWide)
                                const CategoryBadge(label: 'College-wide', color: AppColors.primary, small: true),
                            ]),
                            const SizedBox(height: 8),
                            Text(
                              announcement.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              announcement.summary,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => provider.toggleBookmark(announcement.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isBookmarked ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: isBookmarked ? AppColors.primary : AppColors.textMuted,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      AvatarWidget(initials: announcement.authorName.isNotEmpty ? announcement.authorName[0] : 'A', size: 28, role: UserRole.staff),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${announcement.authorName} · ${announcement.authorDept}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _timeAgo(announcement.postedAt),
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }
}
