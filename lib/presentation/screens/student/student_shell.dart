import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
/// Öğrenci ana kabuk (shell).
class StudentShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const StudentShell({super.key, required this.navigationShell});
  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  final _navItems = [
    (Icons.dashboard_rounded, AppStrings.dashboard),
    (Icons.assignment_rounded, 'Ödevlerim'),
    (Icons.menu_book_rounded, 'Derslerim'),
    (Icons.calendar_month_rounded, AppStrings.calendar),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navItems[widget.navigationShell.currentIndex].$2, style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [

          Consumer<ThemeProvider>(builder: (context, tp, _) => IconButton(icon: Icon(tp.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded), onPressed: tp.toggleTheme)),
          IconButton(
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Profil',
            onPressed: () {
              context.push('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
            tooltip: AppStrings.logout,
            onPressed: () {
              context.read<AuthProvider>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (i) => widget.navigationShell.goBranch(i, initialLocation: i == widget.navigationShell.currentIndex),
        destinations: _navItems.map((item) => NavigationDestination(icon: Icon(item.$1), label: item.$2)).toList(),
      ),
    );
  }
}
