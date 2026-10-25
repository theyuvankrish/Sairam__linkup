// lib/widgets/cards/event_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../common/clay_card.dart';
import '../common/category_chip.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool compact;

  const EventCard({super.key, required this.event, this.onTap, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final isRsvpd = provider.isRsvpd(event.id);
    final color = eventCategoryColor(event.category);
    final daysLeft = event.date.difference(DateTime.now()).inDays;

    Color cardBg = AppColors.surface;
    if (event.category == EventCategory.cultural) cardBg = AppColors.clayPink;
    if (event.category == EventCategory.technical) cardBg = AppColors.clayBlue;
    if (event.category == EventCategory.career) cardBg = AppColors.clayGreen;

    if (compact) {
      return Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        child: ClayCard(
          color: cardBg,
          shadowColor: color.withOpacity(0.15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryBadge(label: event.categoryLabel, color: color, small: true),
                const SizedBox(height: 8),
                Text(event.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: color),
                  const SizedBox(width: 4),
                  Expanded(child: Text(DateFormat('MMM d, yyyy').format(event.date), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.location_on_rounded, size: 12, color: color),
                  const SizedBox(width: 4),
                  Expanded(child: Text(event.venue, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                ]),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClayCard(
        color: cardBg,
        shadowColor: color.withOpacity(0.12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(children: [
                      CategoryBadge(label: event.categoryLabel, color: color),
                      const SizedBox(width: 8),
                      if (!event.isCollegeWide)
                        CategoryBadge(label: event.targetDept?.shortName ?? '', color: AppColors.secondary, small: true),
                    ]),
                  ),
                  if (daysLeft >= 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: daysLeft <= 3 ? AppColors.error.withOpacity(0.12) : AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        daysLeft == 0 ? 'Today!' : 'In $daysLeft days',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: daysLeft <= 3 ? AppColors.error : AppColors.success,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(event.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(children: [
                _infoChip(Icons.calendar_today_rounded, DateFormat('EEE, MMM d').format(event.date), color),
                const SizedBox(width: 10),
                _infoChip(Icons.access_time_rounded, event.time, color),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                _infoChip(Icons.location_on_rounded, event.venue, color),
                const Spacer(),
                GestureDetector(
                  onTap: () => provider.toggleRsvp(event.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isRsvpd ? AppColors.secondary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isRsvpd ? AppColors.secondary : AppColors.border),
                      boxShadow: [BoxShadow(color: (isRsvpd ? AppColors.secondary : AppColors.border).withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(isRsvpd ? Icons.check_circle_rounded : Icons.event_available_rounded, size: 14, color: isRsvpd ? Colors.white : AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(isRsvpd ? 'RSVP\'d' : 'RSVP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isRsvpd ? Colors.white : AppColors.secondary)),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Text('by ${event.host}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ]);
  }
}
