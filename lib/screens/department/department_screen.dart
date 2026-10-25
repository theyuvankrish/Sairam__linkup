// lib/screens/department/department_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/cards/announcement_card.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/cards/person_card.dart';
import '../announcements/announcement_detail.dart';
import '../events/event_detail.dart';
import '../people/person_detail.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Department _selectedDept;
  String? _lastUserId;
  String _selectedDay = 'Monday';
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    final demo = Provider.of<DemoProvider>(context, listen: false);
    _selectedDept = demo.activeUser.department;
    _lastUserId = demo.activeUser.id;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demo = context.watch<DemoProvider>();
    final activeUser = demo.activeUser;
    if (_lastUserId != activeUser.id) {
      _lastUserId = activeUser.id;
      _selectedDept = activeUser.department;
    }

    final deptInfo = mockDeptInfo.firstWhere(
      (d) => d.dept == _selectedDept,
      orElse: () => mockDeptInfo.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 160,
              backgroundColor: AppColors.primary,
              title: const Text(
                'Department Portal',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              actions: [
                // Department Switcher dropdown
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: AppColors.surface,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Department>(
                      value: _selectedDept,
                      dropdownColor: AppColors.surface,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: Department.values.map((dept) {
                        return DropdownMenuItem<Department>(
                          value: dept,
                          child: Text(
                            dept.shortName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newDept) {
                        if (newDept != null) {
                          setState(() {
                            _selectedDept = newDept;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
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
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Established in ${deptInfo.established}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (activeUser.role == UserRole.alumni && activeUser.department == _selectedDept) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Alumni Affiliation (${activeUser.batch ?? "Graduate"})',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selectedDept.displayName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: AppColors.surface,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Students'),
                      Tab(text: 'Faculty'),
                      Tab(text: 'Timetable'),
                      Tab(text: 'Announcements'),
                      Tab(text: 'Events'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(deptInfo),
            _buildStudentsTab(),
            _buildStaffTab(),
            _buildTimetableTab(),
            _buildAnnouncementsTab(),
            _buildEventsTab(),
          ],
        ),
      ),
    );
  }

  // ── Overview Tab ─────────────────────────────────────────────────────────────
  Widget _buildOverviewTab(DepartmentInfo info) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people_rounded,
                count: '${info.studentCount}',
                label: 'Students',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.school_rounded,
                count: '${info.facultyCount}',
                label: 'Faculty',
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.science_rounded,
                count: '${info.labs.length}',
                label: 'Labs',
                color: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // HOD Card
        ClayCard(
          shadowColor: AppColors.primary.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AvatarWidget(
                  name: info.hod,
                  role: UserRole.staff,
                  radius: 26,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Head of Department',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info.hod,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Department of ${_selectedDept.displayName}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // About / Description Card
        ClayCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'About Department',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  info.description,
                  style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Degree Programs
        ClayCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: AppColors.secondary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Academic Programs Offered',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...info.programs.map((prog) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              prog,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Laboratories & Facilities
        ClayCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.biotech_rounded, color: Color(0xFF8B5CF6), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Laboratories & Centers',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: info.labs.map((lab) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.computer_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            lab,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return ClayCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ── Students Tab ─────────────────────────────────────────────────────────────
  Widget _buildStudentsTab() {
    final people = mockPeople
        .where((p) => p.department == _selectedDept && p.role == UserRole.student)
        .toList();

    if (people.isEmpty) {
      return Center(
        child: Text(
          'No students found for ${_selectedDept.shortName}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: people.length,
      itemBuilder: (context, index) {
        final p = people[index];
        return PersonCard(
          person: p,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PersonDetail(person: p)),
          ),
        );
      },
    );
  }

  // ── Staff Tab ────────────────────────────────────────────────────────────────
  Widget _buildStaffTab() {
    final staff = mockPeople
        .where((p) => p.department == _selectedDept && p.role == UserRole.staff)
        .toList();

    if (staff.isEmpty) {
      return Center(
        child: Text(
          'No faculty found for ${_selectedDept.shortName}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: staff.length,
      itemBuilder: (context, index) {
        final s = staff[index];
        return PersonCard(
          person: s,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PersonDetail(person: s)),
          ),
        );
      },
    );
  }

  // ── Timetable Tab ────────────────────────────────────────────────────────────
  Widget _buildTimetableTab() {
    final entries = mockTimetable
        .where((t) => t.department == _selectedDept && t.day == _selectedDay)
        .toList();

    return Column(
      children: [
        // Day selector tabs
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _days.map((day) {
                final isSelected = _selectedDay == day;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedDay = day);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Schedule list
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'No classes scheduled on $_selectedDay',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final item = entries[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClayCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 75,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.clayBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.time.split(' - ')[0],
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                    ),
                                    Text(
                                      'to ${item.time.split(' - ')[1]}',
                                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.subjectCode,
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.room,
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.subject,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Faculty: ${item.faculty}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Announcements Tab ────────────────────────────────────────────────────────
  Widget _buildAnnouncementsTab() {
    final annProvider = context.watch<AnnouncementProvider>();
    final items = annProvider.forDept(_selectedDept);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No announcements for ${_selectedDept.shortName}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final a = items[index];
        return AnnouncementCard(
          announcement: a,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AnnouncementDetail(announcement: a)),
          ),
        );
      },
    );
  }

  // ── Events Tab ───────────────────────────────────────────────────────────────
  Widget _buildEventsTab() {
    final eventProvider = context.watch<EventProvider>();
    final items = eventProvider.forDept(_selectedDept);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No events for ${_selectedDept.shortName}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final e = items[index];
        return EventCard(
          event: e,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EventDetail(event: e)),
          ),
        );
      },
    );
  }
}
