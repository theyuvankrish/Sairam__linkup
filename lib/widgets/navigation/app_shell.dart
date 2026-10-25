// lib/widgets/navigation/app_shell.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/announcements/announcements_screen.dart';
import '../../screens/opportunities/opportunities_screen.dart';
import '../../screens/department/department_screen.dart';
import '../../screens/events/events_screen.dart';
import '../../screens/people/people_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/about/about_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.campaign_rounded, label: 'Announcements'),
    _NavItem(icon: Icons.work_rounded, label: 'Opportunities'),
    _NavItem(icon: Icons.school_rounded, label: 'Department'),
    _NavItem(icon: Icons.event_rounded, label: 'Events'),
    _NavItem(icon: Icons.people_rounded, label: 'People'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    _NavItem(icon: Icons.info_rounded, label: 'About'),
  ];

  late final List<Widget> _screens = [
    const HomeScreen(),
    const AnnouncementsScreen(),
    const OpportunitiesScreen(),
    const DepartmentScreen(),
    const EventsScreen(),
    const PeopleScreen(),
    const ProfileScreen(),
    const AboutScreen(),
  ];

  static const int _bottomNavCount = 5;

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppColors.primary;
      case UserRole.staff:
        return AppColors.secondary;
      case UserRole.alumni:
        return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 700;
    final demo = context.watch<DemoProvider>();
    final user = demo.activeUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with 'S' logo, Sairam LinkUp name, and Top Logout button
            _buildTopBar(context, user, isWide),
            Expanded(
              child: Row(
                children: [
                  if (isWide) _buildNavRail(),
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: _screens,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide ? null : _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context, UserModel user, bool isWide) {
    final rColor = _roleColor(user.role);
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.6))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Top Left Corner: Simple Logo 'S' + Sairam LinkUp name
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Sairam LinkUp',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          const Spacer(),

          // Active User Persona Pill
          if (width >= 450) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: rColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rColor.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AvatarWidget(initials: user.initials, size: 20, role: user.role),
                  const SizedBox(width: 6),
                  Text(
                    width >= 650 ? '${user.name} (${user.roleLabel})' : user.roleLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: rColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Top Logout Button to switch between users
          OutlinedButton.icon(
            onPressed: () {
              context.read<DemoProvider>().logout();
            },
            icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.error.withOpacity(0.35)),
              backgroundColor: AppColors.error.withOpacity(0.06),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavRail() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: NavigationRail(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        extended: false,
        minWidth: 72,
        labelType: NavigationRailLabelType.all,
        backgroundColor: Colors.transparent,
        destinations: _navItems
            .map((item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  label: Text(item.label, style: const TextStyle(fontSize: 10)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final displayIndex = _selectedIndex < _bottomNavCount ? _selectedIndex : _bottomNavCount - 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ..._navItems
                  .take(4)
                  .toList()
                  .asMap()
                  .entries
                  .map((e) => _buildNavItem(e.key, e.value, e.key == displayIndex)),
              _buildMoreButton(context, displayIndex == 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem item, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(item.icon, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 24),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context, bool isSelected) {
    return GestureDetector(
      onTap: () => _showMoreMenu(context),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.more_horiz_rounded, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 24),
          const SizedBox(height: 2),
          Text(
            'More',
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ]),
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
            ),
            const Text('More Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ..._navItems.skip(4).toList().asMap().entries.map((e) {
              final index = e.key + 4;
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.clayBlue, borderRadius: BorderRadius.circular(12)),
                  child: Icon(e.value.icon, color: AppColors.primary, size: 22),
                ),
                title: Text(e.value.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _selectedIndex = index);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
