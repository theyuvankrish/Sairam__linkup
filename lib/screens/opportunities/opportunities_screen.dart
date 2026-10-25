// lib/screens/opportunities/opportunities_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/cards/opportunity_card.dart';
import '../../widgets/common/empty_state.dart';
import 'opportunity_detail.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showSavedOnly = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oppProvider = context.watch<OpportunityProvider>();
    final isWide = MediaQuery.of(context).size.width >= 700;

    List<Opportunity> items = oppProvider.items;
    if (_showSavedOnly) {
      items = items.where((o) => oppProvider.isSaved(o.id)).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Placement & Careers',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              _showSavedOnly ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _showSavedOnly ? AppColors.primary : AppColors.textSecondary,
            ),
            tooltip: _showSavedOnly ? 'Show All' : 'Show Saved Only',
            onPressed: () {
              setState(() {
                _showSavedOnly = !_showSavedOnly;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
            ),
            child: Column(
              children: [
                // Search Input
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => oppProvider.setSearch(val),
                    decoration: InputDecoration(
                      hintText: 'Search companies, roles, skills...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                oppProvider.setSearch('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        isSelected: oppProvider.filterType == null && !_showSavedOnly,
                        onTap: () {
                          setState(() => _showSavedOnly = false);
                          oppProvider.setFilter(null);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Saved',
                        icon: Icons.bookmark_rounded,
                        isSelected: _showSavedOnly,
                        onTap: () {
                          setState(() => _showSavedOnly = !_showSavedOnly);
                        },
                      ),
                      const SizedBox(width: 8),
                      ...OpportunityType.values.map((type) {
                        final isSelected = oppProvider.filterType == type && !_showSavedOnly;
                        String label = '';
                        switch (type) {
                          case OpportunityType.internship:
                            label = 'Internships';
                            break;
                          case OpportunityType.fullTime:
                            label = 'Full-Time';
                            break;
                          case OpportunityType.partTime:
                            label = 'Part-Time';
                            break;
                          case OpportunityType.research:
                            label = 'Research';
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            label: label,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() => _showSavedOnly = false);
                              oppProvider.setFilter(isSelected ? null : type);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count & Subtitle bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Row(
              children: [
                Text(
                  '${items.length} ${items.length == 1 ? 'Opportunity' : 'Opportunities'} available',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (_showSavedOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_rounded, size: 12, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Showing Saved',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // List or Grid of opportunities
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: EmptyStateWidget(
                      icon: _showSavedOnly ? Icons.bookmark_border_rounded : Icons.work_off_rounded,
                      title: _showSavedOnly ? 'No saved opportunities' : 'No opportunities found',
                      subtitle: _showSavedOnly
                          ? 'Bookmark opportunities to access them quickly here.'
                          : 'Try adjusting your search keywords or active filters.',
                    ),
                  )
                : isWide
                    ? GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final opp = items[index];
                          return OpportunityCard(
                            opp: opp,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OpportunityDetail(opportunity: opp),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 6, bottom: 24),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final opp = items[index];
                          return OpportunityCard(
                            opp: opp,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OpportunityDetail(opportunity: opp),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
