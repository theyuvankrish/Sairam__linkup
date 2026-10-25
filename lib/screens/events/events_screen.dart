// lib/screens/events/events_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/common/empty_state.dart';
import 'event_detail.dart';
import 'compose_event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<String> _filters = ['All', 'Workshop', 'Cultural', 'Technical', 'Career', 'Sports', 'Academic'];
  int _filterIdx = 0;

  EventCategory? get _selectedCategory => _filterIdx == 0 ? null : EventCategory.values[_filterIdx - 1];

  @override
  Widget build(BuildContext context) {
    final demo = context.watch<DemoProvider>();
    final provider = context.watch<EventProvider>();
    final isStaff = demo.activeUser.role == UserRole.staff;

    final cat = _selectedCategory;
    final items = cat == null ? provider.items : provider.items.where((e) => e.category == cat).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            title: const Text('Events'),
            pinned: true,
            backgroundColor: AppColors.surface,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(_filters.length, (i) {
                      final isSelected = i == _filterIdx;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filterIdx = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                            ),
                            child: Text(_filters[i], style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: items.isEmpty
            ? EmptyState(icon: '🗓️', title: 'No Events', subtitle: 'No events match your filter.', actionLabel: 'Show All', onAction: () => setState(() => _filterIdx = 0))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (ctx, i) => EventCard(event: items[i], onTap: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => EventDetail(event: items[i])))),
              ),
      ),
      floatingActionButton: isStaff
          ? FloatingActionButton.extended(
              onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const ComposeEvent()),
              backgroundColor: AppColors.secondary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('Add Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }
}
