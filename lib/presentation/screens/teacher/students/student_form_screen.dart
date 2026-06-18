import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
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
  final _systemIdController = TextEditingController();
  
  // Sadece görüntüleme amaçlı (Düzenleme modunda)
  String _firstName = '';
  String _lastName = '';
  String _email = '';

  String _selectedLevel = AppConstants.studentLevels.first;
  bool _isActive = true;
  bool _isEditing = false;
  bool _isLoading = false;
  String? _errorMessage;

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
      _firstName = student.firstName;
      _lastName = student.lastName;
      _email = student.email;
      setState(() {
        _selectedLevel = student.level;
        _isActive = student.isActive;
      });
    }
  }

  @override
  void dispose() {
    _systemIdController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final provider = context.read<StudentProvider>();
    final teacherId = context.read<AuthProvider>().userId;

    try {
      if (_isEditing) {
        final existing = provider.getStudentById(widget.studentId!);
        if (existing != null) {
          await provider.updateStudent(existing.copyWith(
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
        if (mounted) context.go('/teacher/students');
      } else {
        // Yeni Ekleme (ID üzerinden)
        final error = await provider.addStudentById(
          teacherId: teacherId,
          studentSystemId: _systemIdController.text.trim(),
          level: _selectedLevel,
        );
        
        if (error != null) {
          setState(() {
            _errorMessage = error;
            _isLoading = false;
          });
          return;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.studentCreated),
              backgroundColor: AppColors.success,
            ),
          );
          context.go('/teacher/students');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Hata: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: isWide
          ? null
          : AppBar(
              title: Text(_isEditing ? 'Öğrenci Ayarları' : 'Sistem ID ile Öğrenci Ekle'),
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
                        _isEditing ? 'Öğrenci Ayarları' : 'Sistem ID ile Öğrenci Ekle',
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
                      if (_isEditing) ...[
                        // Düzenleme modunda sadece bilgileri göster
                        Card(
                          elevation: 0,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Öğrenci Bilgileri', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                const SizedBox(height: 12),
                                Text('Ad Soyad: $_firstName $_lastName'),
                                const SizedBox(height: 4),
                                Text('E-posta: $_email'),
                                const SizedBox(height: 8),
                                const Text('Not: İsim ve e-posta öğrencinin kendi profili üzerinden değiştirilebilir.', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        // Yeni ekleme modunda ID iste
                        TextFormField(
                          controller: _systemIdController,
                          validator: (v) => v!.isEmpty ? 'ID zorunludur' : null,
                          decoration: const InputDecoration(
                            labelText: 'Öğrenci Sistem ID\'si',
                            hintText: 'Örn: 123e4567-e89b-12d3-a456-426614174000',
                            prefixIcon: Icon(Icons.vpn_key_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Öğrencinin profilinde yazan Sistem ID\'sini yukarıya yapıştırın.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
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
                      
                      if (_isEditing) ...[
                        const SizedBox(height: 24),
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
                      
                      if (_errorMessage != null) ...[
                        Text(_errorMessage!, style: const TextStyle(color: AppColors.danger), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                      ],

                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveStudent,
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                            _isEditing ? AppStrings.save : 'Öğrenciyi Bul ve Ekle',
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
