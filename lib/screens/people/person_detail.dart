// lib/screens/people/person_detail.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/avatar_widget.dart';

class PersonDetail extends StatefulWidget {
  final Person person;

  const PersonDetail({super.key, required this.person});

  @override
  State<PersonDetail> createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  bool _isConnected = false;

  Color get _roleColor {
    switch (widget.person.role) {
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
    final p = widget.person;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card Header
            ClayCard(
              shadowColor: _roleColor.withOpacity(0.12),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AvatarWidget(
                      name: p.name,
                      role: p.role,
                      radius: 44,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _roleColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _roleColor.withOpacity(0.25)),
                      ),
                      child: Text(
                        p.roleLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _roleColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.department.displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Actions Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(
                              _isConnected ? Icons.check_circle_rounded : Icons.person_add_rounded,
                              size: 18,
                            ),
                            label: Text(_isConnected ? 'Connected' : 'Connect (Demo)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isConnected ? AppColors.secondary : AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              setState(() => _isConnected = !_isConnected);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _isConnected
                                        ? 'Connection request sent to ${p.name} (Demo)'
                                        : 'Disconnected from ${p.name}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.email_outlined, size: 18),
                          label: const Text('Email'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Demo: compose email to ${p.email}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bio / About
            ClayCard(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notes_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'About',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p.bio ?? 'Member of Sairam Institute of Technology community. Dedicated to academic excellence and collaboration.',
                      style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Skills & Expertise
            if (p.skills.isNotEmpty) ...[
              ClayCard(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.stars_rounded, color: AppColors.secondary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Skills & Areas of Interest',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: p.skills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Academic / College Info
            ClayCard(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.school_rounded, color: Color(0xFF8B5CF6), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Community Affiliation',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildAffiliationRow('Institution', 'Sairam Institute of Technology'),
                    _buildAffiliationRow('Department', p.department.displayName),
                    _buildAffiliationRow('Role', p.roleLabel),
                    if (p.year != null) _buildAffiliationRow('Academic Year', 'Year ${p.year}'),
                    if (p.batch != null) _buildAffiliationRow('Batch', p.batch!),
                    if (p.title != null) _buildAffiliationRow('Designation', p.title!),
                    _buildAffiliationRow('Email', p.email),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAffiliationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
