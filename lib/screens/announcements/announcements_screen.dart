// lib/screens/announcements/announcements_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/cards/announcement_card.dart';
import '../../widgets/common/empty_state.dart';
import 'announcement_detail.dart';
import 'compose_announcement.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final List<String> _filterLabels = ['All', 'Academic', 'Cultural', 'Technical', 'Career', 'Exam', 'Placement'];
  int _filterIdx = 0;

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final demo = context.watch<DemoProvider>();
    final provider = context.watch<AnnouncementProvider>();
    final isStaff = demo.activeUser.role == UserRole.staff;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            title: const Text('Announcements'),
            pinned: true,
            backgroundColor: AppColors.surface,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(children: [
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) { provider.setSearch(v); },
                    decoration: InputDecoration(
                      hintText: 'Search announcements...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                      isDense: true,
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () { _searchCtrl.clear(); provider.setSearch(''); })
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filterLabels.length, (i) {
                        final isSelected = i == _filterIdx;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _filterIdx = i);
                              provider.setFilter(i == 0 ? null : _categoryFromIndex(i));
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                              ),
                              child: Text(_filterLabels[i], style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
        body: _buildBody(context, provider),
      ),
      floatingActionButton: isStaff
          ? FloatingActionButton.extended(
              onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const ComposeAnnouncement()),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Compose', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, AnnouncementProvider provider) {
    final items = provider.items;
    if (items.isEmpty) {
      return EmptyState(
        icon: '📢',
        title: 'No Announcements',
        subtitle: 'No announcements match your current filters.',
        actionLabel: 'Clear Filters',
        onAction: () { setState(() => _filterIdx = 0); provider.setFilter(null); provider.setSearch(''); _searchCtrl.clear(); },
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (ctx, i) => AnnouncementCard(
        announcement: items[i],
        onTap: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => AnnouncementDetail(announcement: items[i]))),
      ),
    );
  }

  AnnouncementCategory _categoryFromIndex(int i) {
    return [
      AnnouncementCategory.academic,
      AnnouncementCategory.cultural,
      AnnouncementCategory.technical,
      AnnouncementCategory.career,
      AnnouncementCategory.exam,
      AnnouncementCategory.placement,
    ][i - 1];
  }
}
