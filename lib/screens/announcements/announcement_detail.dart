// lib/screens/announcements/announcement_detail.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/common/category_chip.dart';

class AnnouncementDetail extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetail({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnnouncementProvider>();
    final isBookmarked = provider.isBookmarked(announcement.id);
    final color = categoryColor(announcement.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: color,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: Colors.white),
                onPressed: () => provider.toggleBookmark(announcement.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color.withOpacity(0.8), color], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(children: [
                          CategoryBadge(label: announcement.categoryLabel, color: Colors.white),
                          const SizedBox(width: 8),
                          CategoryBadge(label: announcement.isCollegeWide ? 'College-wide' : (announcement.targetDept?.shortName ?? ''), color: Colors.white),
                        ]),
                        const SizedBox(height: 10),
                        Text(announcement.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            expandedHeight: 200,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClayCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      AvatarWidget(initials: announcement.authorName[0], size: 44, role: UserRole.staff),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(announcement.authorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(announcement.authorDept, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ])),
                      Text(DateFormat('MMM d, yyyy • h:mm a').format(announcement.postedAt), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  ClayCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(announcement.content, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.7)),
                  ),
                  const SizedBox(height: 16),
                  ClayCard(
                    color: isBookmarked ? AppColors.clayBlue : AppColors.surface,
                    child: ListTile(
                      leading: Icon(isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: AppColors.primary),
                      title: Text(isBookmarked ? 'Bookmarked' : 'Bookmark this announcement', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      onTap: () => provider.toggleBookmark(announcement.id),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
