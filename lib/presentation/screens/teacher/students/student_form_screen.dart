import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../domain/entities/student_entity.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/student_provider.dart';

/// Öğrenci ekleme/düzenleme formu.
class StudentFormScreen extends StatefulWidget {
  final String? studentId;

  const StudentFormScreen({super.key, this.studentId});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedLevel = AppConstants.studentLevels.first;
  bool _isActive = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.studentId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadStudent();
      });
    }
  }

  void _loadStudent() {
    final student =
        context.read<StudentProvider>().getStudentById(widget.studentId!);
    if (student != null) {
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _phoneController.text = student.phone;
      _emailController.text = student.email;
      _notesController.text = student.notes ?? '';
      setState(() {
        _selectedLevel = student.level;
        _isActive = student.isActive;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<StudentProvider>();
    final teacherId = context.read<AuthProvider>().userId;

    try {
      if (_isEditing) {
        final existing = provider.getStudentById(widget.studentId!);
        if (existing != null) {
          await provider.updateStudent(existing.copyWith(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            notes: _notesController.text.trim(),
            level: _selectedLevel,
            isActive: _isActive,
          ));
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.studentUpdated),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        await provider.createStudent(
          teacherId: teacherId,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
          level: _selectedLevel,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.studentCreated),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
      if (mounted) context.go('/teacher/students');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: isWide
          ? null
          : AppBar(
              title: Text(_isEditing ? AppStrings.editStudent : AppStrings.addStudent),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.go('/teacher/students'),
              ),
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 32 : 16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWide) ...[
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => context.go('/teacher/students'),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEditing ? AppStrings.editStudent : AppStrings.addStudent,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              validator: (v) => Validators.required(v, 'Ad'),
                              decoration: const InputDecoration(
                                labelText: AppStrings.firstName,
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              validator: (v) => Validators.required(v, 'Soyad'),
                              decoration: const InputDecoration(
                                labelText: AppStrings.lastName,
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                        decoration: const InputDecoration(
                          labelText: AppStrings.phone,
                          prefixIcon: Icon(Icons.phone_outlined),
                          hintText: '+905551234567',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        decoration: const InputDecoration(
                          labelText: AppStrings.email,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedLevel,
                        decoration: const InputDecoration(
                          labelText: AppStrings.level,
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        items: AppConstants.studentLevels
                            .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedLevel = v);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: AppStrings.notes,
                          prefixIcon: Icon(Icons.note_outlined),
                          alignLabelWithHint: true,
                        ),
                      ),
                      if (_isEditing) ...[
                        const SizedBox(height: 16),
                        SwitchListTile(
                          value: _isActive,
                          onChanged: (v) => setState(() => _isActive = v),
                          title: const Text('Aktif Öğrenci'),
                          subtitle: Text(
                            _isActive ? 'Öğrenci aktif durumda' : 'Öğrenci pasif durumda',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant,
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _saveStudent,
                          child: Text(
                            _isEditing ? AppStrings.save : AppStrings.addStudent,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
