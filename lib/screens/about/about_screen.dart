// lib/screens/about/about_screen.dart
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/common/clay_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // College Hero Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            title: const Text(
              'About Sri Sairam',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0369A1), AppColors.primary, Color(0xFF38BDF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Autonomous Institution · NBA & NAAC A+',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Sri Sairam Institute of Technology',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sai Leo Nagar, West Tambaram, Chennai - 600 044',
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key Accreditations Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildAccreditationCard(
                          title: 'NAAC A+',
                          subtitle: 'Grade Accredited',
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildAccreditationCard(
                          title: 'NBA',
                          subtitle: 'Accredited Programs',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildAccreditationCard(
                          title: 'Autonomous',
                          subtitle: 'Anna University Affiliated',
                          color: const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Vision & Mission
                  ClayCard(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.visibility_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Our Vision',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'To emerge as a premier institution of technical education, research and innovation that empowers youth with values, knowledge, and skills to contribute globally.',
                            style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
                          ),
                          const Divider(height: 24, color: AppColors.border),
                          const Row(
                            children: [
                              Icon(Icons.flag_rounded, color: AppColors.secondary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Our Mission',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildBulletPoint('Provide cutting-edge engineering curriculum coupled with experiential learning.'),
                          _buildBulletPoint('Foster an environment of innovative research, entrepreneurship, and problem solving.'),
                          _buildBulletPoint('Instill ethical leadership, social responsibility, and lifelong learning ethics.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campus Life & Core Pillars
                  ClayCard(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.hub_rounded, color: AppColors.secondary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Campus Pillars & Highlights',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildPillarTile(
                            icon: Icons.rocket_launch_rounded,
                            title: 'Innovation & Incubation Center',
                            description: 'Active incubation hub supporting student startups, patents, and hackathons.',
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          _buildPillarTile(
                            icon: Icons.work_outline_rounded,
                            title: '95%+ Placement Track Record',
                            description: 'Over 150+ marquee recruiters visit campus annually with top international packages.',
                            color: AppColors.secondary,
                          ),
                          const SizedBox(height: 12),
                          _buildPillarTile(
                            icon: Icons.groups_rounded,
                            title: '30+ Active Student Clubs',
                            description: 'Cultural, technical, coding, robotic, sports, and societal clubs enrich student life.',
                            color: const Color(0xFF8B5CF6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Links / Resources
                  ClayCard(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.link_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Campus Quick Access',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...[
                            'Central Digital Library & IEEE Portal',
                            'Controller of Examinations (COE)',
                            'Placement & Training Cell',
                            'College Bus Route & Schedule',
                            'Student Grievance & Anti-Ragging Cell',
                          ].map(
                            (link) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              leading: const Icon(Icons.arrow_right_rounded, color: AppColors.primary, size: 24),
                              title: Text(
                                link,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              trailing: const Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.textMuted),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Demo link: $link'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App Credits Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.clayBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Sairam LinkUp — College Community App',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Built with Flutter · Offline & Frontend-Only Architecture',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccreditationCard({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ClayCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.textMuted),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarTile({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
