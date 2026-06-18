import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

/// Giriş ekranı. E-posta ve şifre ile giriş.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      if (authProvider.isTeacher) {
        context.go('/teacher/dashboard');
      } else {
        context.go('/student/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return Scaffold(
      body: Row(
        children: [
          // Sol taraf - Dekoratif panel (sadece geniş ekranda)
          if (isWide)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E3A5F),
                      Color(0xFF2563EB),
                      Color(0xFF7C3AED),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Dekoratif daireler
                    Positioned(
                      top: -80,
                      left: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -120,
                      right: -60,
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    // İçerik
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                size: 56,
                                color: Colors.white,
                              ),
                            ).animate().fadeIn(duration: 600.ms).scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1, 1),
                                ),
                            const SizedBox(height: 32),
                            const Text(
                              'EduManager',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),
                            const SizedBox(height: 12),
                            Text(
                              'Eğitim süreçlerinizi kolayca\nyönetin ve takip edin',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
                            const SizedBox(height: 48),
                            // Özellik listesi
                            ..._buildFeatureList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Sağ taraf - Login formu
          Expanded(
            flex: isWide ? 4 : 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isWide) ...[
                        Icon(
                          Icons.school_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ).animate().fadeIn().scale(),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        AppStrings.loginTitle,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.loginSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1),
                      const SizedBox(height: 40),
                      _buildLoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      {'icon': Icons.people_rounded, 'text': 'Öğrenci Yönetimi'},
      {'icon': Icons.assignment_rounded, 'text': 'Ödev Takibi'},
      {'icon': Icons.calendar_today_rounded, 'text': 'Ders Planlaması'},
      {'icon': Icons.bar_chart_rounded, 'text': 'İstatistik Paneli'},
    ];

    return features.asMap().entries.map((entry) {
      final index = entry.key;
      final feature = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 160,
              child: Text(
                feature['text'] as String,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 500 + (index * 100)))
          .fadeIn()
          .slideX(begin: -0.2);
    }).toList();
  }

  Widget _buildLoginForm() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // E-posta alanı
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                decoration: InputDecoration(
                  labelText: AppStrings.email,
                  hintText: AppStrings.emailHint,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
              const SizedBox(height: 16),

              // Şifre alanı
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.password,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  hintText: AppStrings.passwordHint,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1),

              // Hata mesajı
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.danger.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          auth.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Giriş butonu
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleLogin,
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          AppStrings.login,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 16),
              
              // Kayıt Ol yönlendirmesi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hesabınız yok mu?',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthProvider>().clearError();
                      context.push('/register');
                    },
                    child: const Text('Kayıt Ol'),
                  ),
                ],
              ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.1),
            ],
          ),
        );
      },
    );
  }

}
