// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/common/category_chip.dart';
import '../../widgets/cards/announcement_card.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/cards/opportunity_card.dart';
import '../announcements/announcement_detail.dart';
import '../events/event_detail.dart';
import '../opportunities/opportunity_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _filterIndex = 0;
  final List<String> _filters = ['All', 'Announcements', 'Events', 'Opportunities'];
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demo = context.watch<DemoProvider>();
    final user = demo.activeUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, user),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          SliverToBoxAdapter(child: _buildQuickFilters()),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          if (_filterIndex == 0 || _filterIndex == 1) ...[
            SliverToBoxAdapter(child: _buildFeaturedCard(context)),
          ],
          if (_filterIndex == 0 || _filterIndex == 2) ...[
            SliverToBoxAdapter(child: _buildUpcomingEvents(context)),
          ],
          if (_filterIndex == 0 || _filterIndex == 3) ...[
            SliverToBoxAdapter(child: _buildRecentOpportunities(context)),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                _filterIndex == 0 ? 'Recent Feed' : _filters[_filterIndex],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ),
          ),
          _buildFeed(context),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel user) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary, Color(0xFF38BDF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_greeting()}! 👋',
                              style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                child: Text(user.roleLabel, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                child: Text(user.department.shortName, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      AvatarWidget(initials: user.initials, size: 52, role: user.role, color: Colors.white.withOpacity(0.9)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search announcements, events, people...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted), onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); })
              : null,
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return FilterChipRow(
      labels: _filters,
      selectedIndex: _filterIndex,
      onSelected: (i) => setState(() => _filterIndex = i),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    final announcements = context.read<AnnouncementProvider>().items;
    final pinned = announcements.where((a) => a.isPinned).toList();
    if (pinned.isEmpty) return const SizedBox.shrink();
    final featured = pinned.first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📌 Featured', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ClayCard(
            color: AppColors.clayBlue,
            shadowColor: AppColors.primary.withOpacity(0.2),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnnouncementDetail(announcement: featured))),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                      child: const Text('📌 Pinned', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const Spacer(),
                    Text(_timeAgo(featured.postedAt), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ]),
                  const SizedBox(height: 12),
                  Text(featured.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(featured.summary, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.person_rounded, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(featured.authorName, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const Spacer(),
                    const Text('Read more →', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    final events = context.read<EventProvider>().items.take(5).toList();
    if (events.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text('🗓️ Upcoming Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (ctx, i) => EventCard(
                event: events[i],
                compact: true,
                onTap: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => EventDetail(event: events[i]))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOpportunities(BuildContext context) {
    final opps = context.read<OpportunityProvider>().items.take(3).toList();
    if (opps.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💼 Recent Opportunities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...opps.map((o) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClayCard(
              shadowColor: AppColors.secondary.withOpacity(0.1),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OpportunityDetail(opp: o))),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(o.company[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondary))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(o.role, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text('${o.company} · ${o.typeLabel}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '${o.deadline.difference(DateTime.now()).inDays}d left',
                      style: const TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    final announcements = context.watch<AnnouncementProvider>().items;
    final events = context.watch<EventProvider>().items;
    final opps = context.watch<OpportunityProvider>().items;

    final List<_FeedItem> feed = [];
    if (_filterIndex == 0 || _filterIndex == 1) {
      for (final a in announcements) {
        if (_searchQuery.isEmpty || a.title.toLowerCase().contains(_searchQuery) || a.summary.toLowerCase().contains(_searchQuery)) {
          feed.add(_FeedItem(type: 'announcement', data: a));
        }
      }
    }
    if (_filterIndex == 0 || _filterIndex == 2) {
      for (final e in events) {
        if (_searchQuery.isEmpty || e.title.toLowerCase().contains(_searchQuery)) {
          feed.add(_FeedItem(type: 'event', data: e));
        }
      }
    }
    if (_filterIndex == 0 || _filterIndex == 3) {
      for (final o in opps) {
        if (_searchQuery.isEmpty || o.role.toLowerCase().contains(_searchQuery) || o.company.toLowerCase().contains(_searchQuery)) {
          feed.add(_FeedItem(type: 'opportunity', data: o));
        }
      }
    }

    if (feed.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🔍', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('No results found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Try a different search or filter', style: const TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () { _searchCtrl.clear(); setState(() { _searchQuery = ''; _filterIndex = 0; }); }, child: const Text('Clear filters')),
            ]),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((ctx, i) {
        final item = feed[i];
        if (item.type == 'announcement') {
          final a = item.data as Announcement;
          return AnnouncementCard(announcement: a, onTap: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => AnnouncementDetail(announcement: a))));
        } else if (item.type == 'event') {
          final e = item.data as Event;
          return EventCard(event: e, onTap: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => EventDetail(event: e))));
        } else {
          final o = item.data as Opportunity;
          return OpportunityCard(opp: o, onTap: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => OpportunityDetail(opp: o))));
        }
      }, childCount: feed.length),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _FeedItem {
  final String type;
  final dynamic data;
  const _FeedItem({required this.type, required this.data});
}
