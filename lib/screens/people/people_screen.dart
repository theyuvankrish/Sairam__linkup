// lib/screens/people/people_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/cards/person_card.dart';
import '../../widgets/common/empty_state.dart';
import 'person_detail.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PeopleProvider>();
    final isWide = MediaQuery.of(context).size.width >= 750;
    final items = provider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Campus Directory',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
                    onChanged: (val) => provider.setSearch(val),
                    decoration: InputDecoration(
                      hintText: 'Search people by name, skill, dept...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                provider.setSearch('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Role Filter Chips & Dept Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip(
                        label: 'All Roles',
                        isSelected: provider.filterRole == null,
                        onTap: () => provider.setRoleFilter(null),
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        label: 'Students',
                        isSelected: provider.filterRole == UserRole.student,
                        onTap: () => provider.setRoleFilter(
                          provider.filterRole == UserRole.student ? null : UserRole.student,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        label: 'Faculty',
                        isSelected: provider.filterRole == UserRole.staff,
                        onTap: () => provider.setRoleFilter(
                          provider.filterRole == UserRole.staff ? null : UserRole.staff,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        label: 'Alumni',
                        isSelected: provider.filterRole == UserRole.alumni,
                        onTap: () => provider.setRoleFilter(
                          provider.filterRole == UserRole.alumni ? null : UserRole.alumni,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 24,
                        width: 1,
                        color: AppColors.border,
                      ),
                      const SizedBox(width: 12),

                      // Department Filter Dropdown chip
                      PopupMenuButton<Department?>(
                        onSelected: (dept) => provider.setDeptFilter(dept),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        itemBuilder: (context) => [
                          const PopupMenuItem<Department?>(
                            value: null,
                            child: Text('All Departments'),
                          ),
                          ...Department.values.map(
                            (d) => PopupMenuItem<Department?>(
                              value: d,
                              child: Text(d.displayName),
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: provider.filterDept != null ? AppColors.clayBlue : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: provider.filterDept != null ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list_rounded,
                                size: 14,
                                color: provider.filterDept != null ? AppColors.primary : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                provider.filterDept != null ? provider.filterDept!.shortName : 'Department',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: provider.filterDept != null ? FontWeight.w700 : FontWeight.w500,
                                  color: provider.filterDept != null ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: Row(
              children: [
                Text(
                  '${items.length} ${items.length == 1 ? 'Person' : 'People'} found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (provider.filterRole != null || provider.filterDept != null || provider.searchQuery.isNotEmpty) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      provider.clearFilters();
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Directory Content
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: EmptyStateWidget(
                      icon: Icons.person_search_rounded,
                      title: 'No people found',
                      subtitle: 'Try adjusting your search criteria or resetting filters.',
                    ),
                  )
                : isWide
                    ? GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final p = items[index];
                          return PersonCard(
                            person: p,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PersonDetail(person: p)),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 6, bottom: 24),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final p = items[index];
                          return PersonCard(
                            person: p,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PersonDetail(person: p)),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
