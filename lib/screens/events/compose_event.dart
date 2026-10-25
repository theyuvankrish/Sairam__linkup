// lib/screens/events/compose_event.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/clay_card.dart';

class ComposeEvent extends StatefulWidget {
  const ComposeEvent({super.key});

  @override
  State<ComposeEvent> createState() => _ComposeEventState();
}

class _ComposeEventState extends State<ComposeEvent> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(text: '10:00 AM');
  EventCategory _category = EventCategory.workshop;
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  bool _isCollegeWide = true;
  bool _saving = false;

  @override
  void dispose() { _titleCtrl.dispose(); _descCtrl.dispose(); _venueCtrl.dispose(); _timeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final user = context.read<DemoProvider>().activeUser;
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(children: [
        Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 8), decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Row(children: [
            const Text('🗓️ Add Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withOpacity(0.3))),
                child: const Row(children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('DEMO MODE — Event only visible in this session.', style: TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w500))),
                ]),
              ),
              const SizedBox(height: 14),
              _lbl('Event Title *'), const SizedBox(height: 6),
              TextField(controller: _titleCtrl, decoration: const InputDecoration(hintText: 'Enter event title')),
              const SizedBox(height: 12),
              _lbl('Description *'), const SizedBox(height: 6),
              TextField(controller: _descCtrl, decoration: const InputDecoration(hintText: 'Describe the event...'), maxLines: 4),
              const SizedBox(height: 12),
              _lbl('Venue *'), const SizedBox(height: 6),
              TextField(controller: _venueCtrl, decoration: const InputDecoration(hintText: 'e.g. Seminar Hall, Block A')),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _lbl('Date'), const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text('${_date.day}/${_date.month}/${_date.year}', style: const TextStyle(fontSize: 14)),
                      ]),
                    ),
                  ),
                ])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _lbl('Time'), const SizedBox(height: 6),
                  TextField(controller: _timeCtrl, decoration: const InputDecoration(hintText: '10:00 AM')),
                ])),
              ]),
              const SizedBox(height: 12),
              _lbl('Category'), const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: DropdownButtonHideUnderline(child: DropdownButton<EventCategory>(
                  value: _category, isExpanded: true,
                  items: EventCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name[0].toUpperCase() + c.name.substring(1)))).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                )),
              ),
              const SizedBox(height: 12),
              _lbl('Audience'), const SizedBox(height: 6),
              ClayCard(
                padding: const EdgeInsets.all(4),
                child: Row(children: [
                  Expanded(child: RadioListTile<bool>(value: true, groupValue: _isCollegeWide, onChanged: (v) => setState(() => _isCollegeWide = v!), title: const Text('College-wide', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), activeColor: AppColors.primary)),
                  Expanded(child: RadioListTile<bool>(value: false, groupValue: _isCollegeWide, onChanged: (v) => setState(() => _isCollegeWide = v!), title: const Text('Department', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), activeColor: AppColors.primary)),
                ]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                  onPressed: _saving ? null : () => _submit(context, user),
                  child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Add Event'),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _lbl(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary));

  void _submit(BuildContext ctx, dynamic user) async {
    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty || _venueCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please fill all required fields.')));
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final e = Event(
      id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      date: _date, time: _timeCtrl.text.trim(),
      venue: _venueCtrl.text.trim(),
      host: user.name,
      category: _category,
      isCollegeWide: _isCollegeWide,
    );
    ctx.read<EventProvider>().addEvent(e);
    Navigator.pop(ctx);
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('✅ Event added! (Demo session only)')));
  }
}
