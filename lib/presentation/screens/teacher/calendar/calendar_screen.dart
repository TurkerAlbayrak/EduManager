import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/assignment_entity.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../widgets/common/status_badge.dart';

/// Takvim ekranı. Dersler ve ödev teslim tarihlerini gösterir.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      context.read<LessonProvider>().loadLessons(userId);
      context.read<AssignmentProvider>().loadAssignments(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          if (isWide)
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Align(alignment: Alignment.centerLeft, child: Text(AppStrings.calendar, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700))),
            ),
          Consumer2<LessonProvider, AssignmentProvider>(
            builder: (context, lessonP, assignmentP, _) {
              return Card(
                margin: const EdgeInsets.all(16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) => setState(() => _calendarFormat = format),
                  onDaySelected: (selected, focused) => setState(() { _selectedDay = selected; _focusedDay = focused; }),
                  onPageChanged: (focused) => _focusedDay = focused,
                  locale: 'tr_TR',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  eventLoader: (day) {
                    final lessons = lessonP.getLessonsForDate(day);
                    final assignments = assignmentP.assignments.where((a) {
                      return a.dueDate.year == day.year && a.dueDate.month == day.month && a.dueDate.day == day.day;
                    }).toList();
                    return [...lessons, ...assignments];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.3), shape: BoxShape.circle),
                    selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    markerDecoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    markerSize: 6,
                    markersMaxCount: 3,
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(8)),
                    formatButtonTextStyle: const TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              );
            },
          ),
          // Seçili günün etkinlikleri
          Expanded(child: _buildDayDetails()),
        ],
      ),
    );
  }

  Widget _buildDayDetails() {
    if (_selectedDay == null) return const SizedBox();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer3<LessonProvider, AssignmentProvider, StudentProvider>(
      builder: (context, lessonP, assignmentP, studentP, _) {
        final lessons = lessonP.getLessonsForDate(_selectedDay!);
        final assignments = assignmentP.assignments.where((a) {
          return a.dueDate.year == _selectedDay!.year && a.dueDate.month == _selectedDay!.month && a.dueDate.day == _selectedDay!.day;
        }).toList();

        if (lessons.isEmpty && assignments.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.event_busy_rounded, size: 48, color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
            const SizedBox(height: 12),
            Text('Bu tarihte etkinlik yok', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
          ]));
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            if (lessons.isNotEmpty) ...[
              Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Dersler (${lessons.length})', style: const TextStyle(fontWeight: FontWeight.w600))),
              ...lessons.map((l) {
                final student = studentP.getStudentById(l.studentId);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20)),
                    title: Text(l.topic, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${student?.fullName ?? ""} • ${l.startTime} • ${l.durationFormatted}', style: const TextStyle(fontSize: 12)),
                    trailing: StatusBadge.forLesson(l.status.name),
                  ),
                );
              }),
            ],
            if (assignments.isNotEmpty) ...[
              Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Ödev Teslim (${assignments.length})', style: const TextStyle(fontWeight: FontWeight.w600))),
              ...assignments.map((a) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.assignment_rounded, color: AppColors.warning, size: 20)),
                  title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${a.assignedStudentIds.length} öğrenci', style: const TextStyle(fontSize: 12)),
                  trailing: StatusBadge.fromAssignmentStatus(a.status),
                ),
              )),
            ],
          ],
        );
      },
    );
  }
}
