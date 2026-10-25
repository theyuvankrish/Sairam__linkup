// lib/widgets/cards/opportunity_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../common/clay_card.dart';
import '../common/category_chip.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opp;
  final VoidCallback? onTap;

  const OpportunityCard({super.key, required this.opp, this.onTap});

  Color get _typeColor {
    switch (opp.type) {
      case OpportunityType.internship: return AppColors.primary;
      case OpportunityType.fullTime: return AppColors.secondary;
      case OpportunityType.partTime: return AppColors.warning;
      case OpportunityType.research: return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OpportunityProvider>();
    final isSaved = provider.isSaved(opp.id);
    final isInterested = provider.isInterested(opp.id);
    final daysLeft = opp.deadline.difference(DateTime.now()).inDays;
    final isExpired = opp.isExpired;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClayCard(
        shadowColor: _typeColor.withOpacity(0.12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Logo Placeholder
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _typeColor.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Text(
                        opp.company.isNotEmpty ? opp.company[0] : 'C',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _typeColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CategoryBadge(label: opp.typeLabel, color: _typeColor),
                          const SizedBox(width: 6),
                          if (isExpired)
                            const CategoryBadge(label: 'Closed', color: AppColors.error, small: true)
                          else if (daysLeft <= 3)
                            CategoryBadge(label: 'Ends in ${daysLeft}d', color: AppColors.warning, small: true),
                        ]),
                        const SizedBox(height: 6),
                        Text(opp.role, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text(opp.company, style: TextStyle(fontSize: 13, color: _typeColor, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => provider.toggleSave(opp.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSaved ? AppColors.warning.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isSaved ? AppColors.warning : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(opp.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _chip(Icons.location_on_rounded, opp.workMode),
                  _chip(Icons.business_center_rounded, opp.location),
                  if (opp.stipend.isNotEmpty) _chip(Icons.payments_rounded, opp.stipend),
                  if (opp.packageInfo != null) _chip(Icons.trending_up_rounded, opp.packageInfo!),
                  _chip(Icons.calendar_month_rounded, 'Due: ${DateFormat('MMM d').format(opp.deadline)}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Wrap(
                    spacing: 6,
                    children: opp.eligibleDepts.take(3).map((d) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                        child: Text(d.shortName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                      ),
                    ).toList(),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      provider.toggleInterest(opp.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isInterested ? 'Interest withdrawn (demo only)' : '✅ Interest noted! This is a demo — no real application submitted.'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isInterested ? _typeColor : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _typeColor),
                        boxShadow: [BoxShadow(color: _typeColor.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Text(
                        isInterested ? '✓ Interested' : 'Show Interest',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isInterested ? Colors.white : _typeColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: AppColors.textMuted),
      const SizedBox(width: 3),
      Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
    ]);
  }
}
