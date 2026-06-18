import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.currentUser?.name);
    _emailController = TextEditingController(text: auth.currentUser?.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await context.read<AuthProvider>().updateUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil başarıyla güncellendi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Center(child: Text('Kullanıcı bulunamadı.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _nameController.text = user.name;
                  _emailController.text = user.email;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar alanı
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.isTeacher ? AppColors.primary : AppColors.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.isTeacher ? 'Öğretmen' : 'Öğrenci',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sistem ID (Kopyalanabilir)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.isStudent 
                              ? 'Sistem ID\'niz (Öğretmeninize Verin)'
                              : 'Sistem ID\'niz',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.id,
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: user.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ID Kopyalandı!')),
                                );
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Alanları
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(labelText: 'Ad Soyad', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => v!.isEmpty ? 'Boş bırakılamaz' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(labelText: 'E-posta', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) => v!.isEmpty ? 'Boş bırakılamaz' : null,
                  ),
                  const SizedBox(height: 32),

                  if (_isEditing)
                    ElevatedButton(
                      onPressed: auth.isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Kaydet', style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
