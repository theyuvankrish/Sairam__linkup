// lib/screens/announcements/compose_announcement.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/clay_card.dart';

class ComposeAnnouncement extends StatefulWidget {
  const ComposeAnnouncement({super.key});

  @override
  State<ComposeAnnouncement> createState() => _ComposeAnnouncementState();
}

class _ComposeAnnouncementState extends State<ComposeAnnouncement> {
  final _titleCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  AnnouncementCategory _category = AnnouncementCategory.general;
  bool _isCollegeWide = true;
  Department? _targetDept;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose(); _summaryCtrl.dispose(); _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demo = context.read<DemoProvider>();
    final user = demo.activeUser;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withOpacity(0.3))),
                    child: const Row(children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text('DEMO MODE — This announcement is only visible in this session.', style: TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w500))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  _label('Title *'),
                  const SizedBox(height: 6),
                  TextField(controller: _titleCtrl, decoration: const InputDecoration(hintText: 'Enter announcement title')),
                  const SizedBox(height: 14),
                  _label('Summary *'),
                  const SizedBox(height: 6),
                  TextField(controller: _summaryCtrl, decoration: const InputDecoration(hintText: 'Brief one-line summary'), maxLines: 2),
                  const SizedBox(height: 14),
                  _label('Content *'),
                  const SizedBox(height: 6),
                  TextField(controller: _contentCtrl, decoration: const InputDecoration(hintText: 'Full announcement content...'), maxLines: 6),
                  const SizedBox(height: 14),
                  _label('Category'),
                  const SizedBox(height: 6),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 14),
                  _label('Audience'),
                  const SizedBox(height: 6),
                  ClayCard(
                    padding: const EdgeInsets.all(4),
                    child: Column(children: [
                      RadioListTile<bool>(
                        value: true,
                        groupValue: _isCollegeWide,
                        onChanged: (v) => setState(() => _isCollegeWide = v!),
                        title: const Text('College-wide', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Visible to everyone', style: TextStyle(fontSize: 12)),
                        activeColor: AppColors.primary,
                      ),
                      RadioListTile<bool>(
                        value: false,
                        groupValue: _isCollegeWide,
                        onChanged: (v) => setState(() => _isCollegeWide = v!),
                        title: const Text('Department-specific', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Visible to selected department', style: TextStyle(fontSize: 12)),
                        activeColor: AppColors.primary,
                      ),
                      if (!_isCollegeWide)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _buildDeptDropdown(),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : () => _submit(context, user),
                      child: _saving
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Post Announcement'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() => Center(
    child: Container(
      width: 40, height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
    ),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
    child: Row(children: [
      const Text('✏️ Compose Announcement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const Spacer(),
      IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
    ]),
  );

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary));

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AnnouncementCategory>(
          value: _category,
          isExpanded: true,
          items: AnnouncementCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name[0].toUpperCase() + c.name.substring(1)))).toList(),
          onChanged: (v) => setState(() => _category = v!),
        ),
      ),
    );
  }

  Widget _buildDeptDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Department>(
          value: _targetDept,
          isExpanded: true,
          hint: const Text('Select department'),
          items: Department.values.map((d) => DropdownMenuItem(value: d, child: Text(d.displayName))).toList(),
          onChanged: (v) => setState(() => _targetDept = v),
        ),
      ),
    );
  }

  void _submit(BuildContext context, dynamic user) async {
    if (_titleCtrl.text.trim().isEmpty || _contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in title and content.')));
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final a = Announcement(
      id: 'composed_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      summary: _summaryCtrl.text.trim().isNotEmpty ? _summaryCtrl.text.trim() : _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      authorName: user.name,
      authorDept: user.department.displayName,
      category: _category,
      isCollegeWide: _isCollegeWide,
      targetDept: _isCollegeWide ? null : _targetDept,
      postedAt: DateTime.now(),
    );
    context.read<AnnouncementProvider>().addAnnouncement(a);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Announcement posted successfully! (Demo session only)')));
  }
}
