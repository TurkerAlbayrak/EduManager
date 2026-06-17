import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../domain/entities/assignment_entity.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../providers/student_provider.dart';

/// Ödev ekleme/düzenleme formu.
class AssignmentFormScreen extends StatefulWidget {
  final String? assignmentId;
  const AssignmentFormScreen({super.key, this.assignmentId});
  @override
  State<AssignmentFormScreen> createState() => _AssignmentFormScreenState();
}

class _AssignmentFormScreenState extends State<AssignmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  List<String> _selectedStudentIds = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.assignmentId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  void _load() {
    final a = context.read<AssignmentProvider>().assignments.where((x) => x.id == widget.assignmentId).firstOrNull;
    if (a != null) {
      _titleController.text = a.title;
      _descriptionController.text = a.description;
      setState(() { _dueDate = a.dueDate; _selectedStudentIds = List.from(a.assignedStudentIds); });
    }
  }

  @override
  void dispose() { _titleController.dispose(); _descriptionController.dispose(); super.dispose(); }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _dueDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.selectAtLeastOneStudent), backgroundColor: AppColors.warning));
      return;
    }
    final provider = context.read<AssignmentProvider>();
    final teacherId = context.read<AuthProvider>().userId;
    try {
      if (_isEditing) {
        final existing = provider.assignments.where((x) => x.id == widget.assignmentId).firstOrNull;
        if (existing != null) {
          await provider.updateAssignment(existing.copyWith(title: _titleController.text.trim(), description: _descriptionController.text.trim(), dueDate: _dueDate, assignedStudentIds: _selectedStudentIds));
        }
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.assignmentUpdated), backgroundColor: AppColors.success));
      } else {
        await provider.createAssignment(teacherId: teacherId, title: _titleController.text.trim(), description: _descriptionController.text.trim(), dueDate: _dueDate, assignedStudentIds: _selectedStudentIds);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.assignmentCreated), backgroundColor: AppColors.success));
      }
      if (mounted) context.go('/teacher/assignments');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.danger));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: isWide ? null : AppBar(
        title: Text(_isEditing ? AppStrings.editAssignment : AppStrings.addAssignment),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/teacher/assignments')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 32 : 16),
        child: Center(child: Container(constraints: const BoxConstraints(maxWidth: 600), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (isWide) ...[
            Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/teacher/assignments')),
              const SizedBox(width: 8),
              Text(_isEditing ? AppStrings.editAssignment : AppStrings.addAssignment, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 24),
          ],
          Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(controller: _titleController, validator: (v) => Validators.required(v, 'Başlık'), decoration: const InputDecoration(labelText: AppStrings.title, prefixIcon: Icon(Icons.title_rounded))),
            const SizedBox(height: 16),
            TextFormField(controller: _descriptionController, maxLines: 4, validator: (v) => Validators.required(v, 'Açıklama'), decoration: const InputDecoration(labelText: AppStrings.description, prefixIcon: Icon(Icons.description_outlined), alignLabelWithHint: true)),
            const SizedBox(height: 16),
            InkWell(onTap: _pickDate, borderRadius: BorderRadius.circular(12), child: InputDecorator(
              decoration: const InputDecoration(labelText: AppStrings.dueDate, prefixIcon: Icon(Icons.calendar_today_outlined)),
              child: Text(DateFormat('dd.MM.yyyy').format(_dueDate)),
            )),
            const SizedBox(height: 24),
            const Text(AppStrings.selectStudents, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Consumer<StudentProvider>(builder: (context, sp, _) {
              final students = sp.students.where((s) => s.isActive).toList();
              if (students.isEmpty) return const Text('Aktif öğrenci bulunmuyor');
              return Column(children: students.map((s) {
                final isSelected = _selectedStudentIds.contains(s.id);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (v) { setState(() { if (v == true) _selectedStudentIds.add(s.id); else _selectedStudentIds.remove(s.id); }); },
                  title: Text(s.fullName),
                  subtitle: Text(s.level, style: const TextStyle(fontSize: 12)),
                  secondary: CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.12), child: Text(s.initials, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 12))),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  activeColor: AppColors.primary,
                  dense: true,
                );
              }).toList());
            }),
            const SizedBox(height: 32),
            SizedBox(height: 52, child: ElevatedButton(onPressed: _save, child: Text(_isEditing ? AppStrings.save : AppStrings.addAssignment, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))),
          ])),
        ]))),
      ),
    );
  }
}
