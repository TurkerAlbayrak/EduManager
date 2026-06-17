import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/date_utils.dart' as app_date;
import '../../../../domain/entities/lesson_entity.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../providers/student_provider.dart';

/// Ders ekleme/düzenleme formu.
class LessonFormScreen extends StatefulWidget {
  final String? lessonId;
  const LessonFormScreen({super.key, this.lessonId});
  @override
  State<LessonFormScreen> createState() => _LessonFormScreenState();
}

class _LessonFormScreenState extends State<LessonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 14, minute: 0);
  int _duration = 60;
  String? _selectedStudentId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.lessonId != null) { _isEditing = true; WidgetsBinding.instance.addPostFrameCallback((_) => _load()); }
  }

  void _load() {
    final l = context.read<LessonProvider>().lessons.where((x) => x.id == widget.lessonId).firstOrNull;
    if (l != null) {
      _topicController.text = l.topic;
      _contentController.text = l.content ?? '';
      _noteController.text = l.teacherNote ?? '';
      setState(() { _date = l.date; _time = app_date.AppDateUtils.parseTimeString(l.startTime); _duration = l.durationMinutes; _selectedStudentId = l.studentId; });
    }
  }

  @override
  void dispose() { _topicController.dispose(); _contentController.dispose(); _noteController.dispose(); super.dispose(); }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudentId == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen öğrenci seçin'), backgroundColor: AppColors.warning)); return; }
    final provider = context.read<LessonProvider>();
    final teacherId = context.read<AuthProvider>().userId;
    try {
      if (_isEditing) {
        final existing = provider.lessons.where((x) => x.id == widget.lessonId).firstOrNull;
        if (existing != null) {
          await provider.updateLesson(existing.copyWith(studentId: _selectedStudentId, date: _date, startTime: app_date.AppDateUtils.timeOfDayToString(_time), durationMinutes: _duration, topic: _topicController.text.trim(), content: _contentController.text.trim().isNotEmpty ? _contentController.text.trim() : null, teacherNote: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null));
        }
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.lessonUpdated), backgroundColor: AppColors.success));
      } else {
        await provider.createLesson(teacherId: teacherId, studentId: _selectedStudentId!, date: _date, startTime: app_date.AppDateUtils.timeOfDayToString(_time), durationMinutes: _duration, topic: _topicController.text.trim(), content: _contentController.text.trim().isNotEmpty ? _contentController.text.trim() : null, teacherNote: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.lessonCreated), backgroundColor: AppColors.success));
      }
      if (mounted) context.go('/teacher/lessons');
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.danger)); }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: isWide ? null : AppBar(title: Text(_isEditing ? AppStrings.editLesson : AppStrings.addLesson), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/teacher/lessons'))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 32 : 16),
        child: Center(child: Container(constraints: const BoxConstraints(maxWidth: 600), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (isWide) ...[Row(children: [IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/teacher/lessons')), const SizedBox(width: 8), Text(_isEditing ? AppStrings.editLesson : AppStrings.addLesson, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700))]), const SizedBox(height: 24)],
          Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Öğrenci seçimi
            Consumer<StudentProvider>(builder: (context, sp, _) {
              final students = sp.students.where((s) => s.isActive).toList();
              return DropdownButtonFormField<String>(
                value: _selectedStudentId,
                decoration: const InputDecoration(labelText: AppStrings.selectStudent, prefixIcon: Icon(Icons.person_outline_rounded)),
                items: students.map((s) => DropdownMenuItem(value: s.id, child: Text(s.fullName))).toList(),
                onChanged: (v) => setState(() => _selectedStudentId = v),
                validator: (v) => v == null ? 'Öğrenci seçmelisiniz' : null,
              );
            }),
            const SizedBox(height: 16),
            TextFormField(controller: _topicController, validator: (v) => Validators.required(v, 'Konu'), decoration: const InputDecoration(labelText: AppStrings.topic, prefixIcon: Icon(Icons.subject_rounded))),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: InkWell(onTap: _pickDate, borderRadius: BorderRadius.circular(12), child: InputDecorator(decoration: const InputDecoration(labelText: AppStrings.date, prefixIcon: Icon(Icons.calendar_today_outlined)), child: Text(DateFormat('dd.MM.yyyy').format(_date))))),
              const SizedBox(width: 16),
              Expanded(child: InkWell(onTap: _pickTime, borderRadius: BorderRadius.circular(12), child: InputDecorator(decoration: const InputDecoration(labelText: AppStrings.time, prefixIcon: Icon(Icons.access_time_rounded)), child: Text(app_date.AppDateUtils.timeOfDayToString(_time))))),
            ]),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(value: _duration, decoration: const InputDecoration(labelText: AppStrings.duration, prefixIcon: Icon(Icons.timer_outlined)),
              items: AppConstants.lessonDurations.map((d) => DropdownMenuItem(value: d, child: Text(app_date.AppDateUtils.formatDuration(d)))).toList(),
              onChanged: (v) { if (v != null) setState(() => _duration = v); }),
            const SizedBox(height: 16),
            TextFormField(controller: _contentController, maxLines: 3, decoration: const InputDecoration(labelText: AppStrings.content, prefixIcon: Icon(Icons.article_outlined), alignLabelWithHint: true)),
            const SizedBox(height: 16),
            TextFormField(controller: _noteController, maxLines: 2, decoration: const InputDecoration(labelText: AppStrings.teacherNote, prefixIcon: Icon(Icons.note_outlined), alignLabelWithHint: true)),
            const SizedBox(height: 32),
            SizedBox(height: 52, child: ElevatedButton(onPressed: _save, child: Text(_isEditing ? AppStrings.save : AppStrings.addLesson, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))),
          ])),
        ]))),
      ),
    );
  }
}
