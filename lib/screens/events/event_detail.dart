// lib/screens/events/event_detail.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/category_chip.dart';

class EventDetail extends StatelessWidget {
  final Event event;
  const EventDetail({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final isRsvpd = provider.isRsvpd(event.id);
    final color = eventCategoryColor(event.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: color,
            expandedHeight: 200,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.7), color], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CategoryBadge(label: event.categoryLabel, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
                        const SizedBox(height: 6),
                        Text('by ${event.host}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClayCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      _infoRow(Icons.calendar_today_rounded, 'Date', DateFormat('EEEE, MMMM d, yyyy').format(event.date), color),
                      const Divider(height: 20),
                      _infoRow(Icons.access_time_rounded, 'Time', event.time, color),
                      const Divider(height: 20),
                      _infoRow(Icons.location_on_rounded, 'Venue', event.venue, color),
                      const Divider(height: 20),
                      _infoRow(Icons.groups_rounded, 'Host', event.host, color),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  const Text('About this Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ClayCard(
                    padding: const EdgeInsets.all(16),
                    child: Text(event.description, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.7)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRsvpd ? AppColors.secondary : AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => provider.toggleRsvp(event.id),
                      icon: Icon(isRsvpd ? Icons.check_circle_rounded : Icons.event_available_rounded, color: Colors.white),
                      label: Text(isRsvpd ? 'RSVP Confirmed ✓' : 'RSVP for this Event', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  if (isRsvpd) ...[
                    const SizedBox(height: 10),
                    ClayCard(
                      color: AppColors.clayGreen,
                      padding: const EdgeInsets.all(12),
                      child: const Row(children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                        SizedBox(width: 8),
                        Expanded(child: Text('You\'ve RSVP\'d! This is a demo — no real registration is made.', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500))),
                      ]),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ])),
    ]);
  }
}
