// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../data/mock_data.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/avatar_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demoProvider = context.watch<DemoProvider>();
    final annProvider = context.watch<AnnouncementProvider>();
    final eventProvider = context.watch<EventProvider>();
    final oppProvider = context.watch<OpportunityProvider>();
    final user = demoProvider.activeUser;

    Color roleColor;
    switch (user.role) {
      case UserRole.student:
        roleColor = AppColors.primary;
        break;
      case UserRole.staff:
        roleColor = AppColors.secondary;
        break;
      case UserRole.alumni:
        roleColor = const Color(0xFF8B5CF6);
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile & Settings',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Card
            ClayCard(
              shadowColor: roleColor.withOpacity(0.12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AvatarWidget(
                          name: user.name,
                          role: user.role,
                          radius: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: roleColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.roleLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: roleColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.department.displayName,
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (user.bio != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          user.bio!,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User Activity / Stats
            Row(
              children: [
                Expanded(
                  child: _buildActivityStat(
                    icon: Icons.bookmark_rounded,
                    count: '${annProvider.bookmarked.length}',
                    label: 'Bookmarks',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActivityStat(
                    icon: Icons.event_available_rounded,
                    count: '${eventProvider.rsvpd.length}',
                    label: 'RSVPs',
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActivityStat(
                    icon: Icons.work_rounded,
                    count: '${oppProvider.saved.length}',
                    label: 'Saved Jobs',
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Active Role Permissions Card
            ClayCard(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified_user_rounded, color: roleColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${user.roleLabel} Access Privileges',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (user.role == UserRole.student) ...[
                      _buildPrivilegeRow('Browse college and CSE department notices'),
                      _buildPrivilegeRow('View full weekly academic timetable and class locations'),
                      _buildPrivilegeRow('RSVP to campus workshops and technical hackathons'),
                      _buildPrivilegeRow('Save career opportunities and track demo job applications'),
                    ] else if (user.role == UserRole.staff) ...[
                      _buildPrivilegeRow('Full view of academic updates and student/faculty directories'),
                      _buildPrivilegeRow('✍️ Compose and post college-wide and department announcements'),
                      _buildPrivilegeRow('🗓️ Create and schedule campus events with venue details'),
                      _buildPrivilegeRow('Access department information and laboratory resources'),
                    ] else ...[
                      _buildPrivilegeRow('Browse college news and updates for your department (${user.department.shortName})'),
                      _buildPrivilegeRow('Explore placement opportunities, career openings, and research positions'),
                      _buildPrivilegeRow('Connect with students, fellow alumni, and faculty in the directory'),
                      _buildPrivilegeRow('Personalized alumni department views'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logout & Switch User Card
            ClayCard(
              color: AppColors.error.withOpacity(0.04),
              border: Border.all(color: AppColors.error.withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.switch_account_rounded, color: AppColors.error, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Switch User Persona',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Log out to return to the persona selection screen and choose another demo user.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          demoProvider.logout();
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text(
                          'Log Out & Choose Persona',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Department Override Card
            ClayCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Department Preference',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Changes the default department context for announcements, timetable & events.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Department>(
                          value: user.department,
                          isExpanded: true,
                          items: Department.values.map((dept) {
                            return DropdownMenuItem<Department>(
                              value: dept,
                              child: Text(
                                '${dept.shortName} - ${dept.displayName}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                          onChanged: (newDept) {
                            if (newDept != null) {
                              demoProvider.switchDepartment(newDept);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Information & About
            ClayCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy & Offline Mode',
                      subtitle: 'Zero data collected. All data stored in local memory.',
                    ),
                    const Divider(height: 20, color: AppColors.border),
                    _buildSettingTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Sairam LinkUp Version',
                      subtitle: '1.0.0 (Frontend Demo Edition)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStat({
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
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivilegeRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
