import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const List<String> _moodEmojis = ['😢','😕','😐','😊','🤩'];
  static const List<Color> _moodColors = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF22C55E),
    Color(0xFF5B5FEE),
  ];
  static const List<String> _dayShort = ['M','T','W','T','F','S','S'];
  static const List<String> _dayFull = [
    'Mon','Tue','Wed','Thu','Fri','Sat','Sun'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress & Stats')),
      body: Consumer<AppProvider>(builder: (ctx, provider, _) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 40),
          children: [
            _buildSummaryRow(provider),
            const SizedBox(height: 24),
            _sectionTitle('Mood This Week'),
            const SizedBox(height: 12),
            _buildMoodWeek(provider),
            const SizedBox(height: 24),
            _sectionTitle('Habit Stats'),
            const SizedBox(height: 12),
            if (provider.habits.isEmpty)
              _buildNoHabits()
            else
              ...provider.habits.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _HabitProgressCard(habit: h, provider: provider),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryRow(AppProvider provider) {
    final totalHabits = provider.habits.length;
    final totalStreaks =
        provider.habits.fold<int>(0, (sum, h) => sum + h.currentStreak);
    final totalDone =
        provider.habits.fold<int>(0, (sum, h) => sum + h.totalCompletions);
    return Row(
      children: [
        Expanded(
            child: _SummaryBox(
                value: '$totalHabits',
                label: 'Habits',
                icon: '🎯',
                color: AppTheme.primary)),
        const SizedBox(width: 12),
        Expanded(
            child: _SummaryBox(
                value: '$totalStreaks',
                label: 'Streaks',
                icon: '🔥',
                color: Colors.orange)),
        const SizedBox(width: 12),
        Expanded(
            child: _SummaryBox(
                value: '$totalDone',
                label: 'Completed',
                icon: '✅',
                color: AppTheme.success)),
      ],
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: GoogleFonts.plusJakartaSans(
          fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.dark));

  Widget _buildMoodWeek(AppProvider provider) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final date = now.subtract(Duration(days: 6 - i));
          final key =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final mood = provider.moods[key];
          final isToday = i == 6;
          return Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: mood != null
                      ? _moodColors[mood.mood - 1].withOpacity(0.12)
                      : AppTheme.greyLight,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday
                      ? Border.all(color: AppTheme.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    mood != null ? _moodEmojis[mood.mood - 1] : '·',
                    style:
                        TextStyle(fontSize: mood != null ? 20 : 16),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _dayShort[date.weekday - 1],
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isToday ? AppTheme.primary : AppTheme.grey,
                    fontWeight: isToday
                        ? FontWeight.w700
                        : FontWeight.w500),
              ),
              if (isToday)
                Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNoHabits() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text('📊', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('No habits yet',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.dark)),
          const SizedBox(height: 6),
          Text(
            'Add habits to start tracking\nyour progress here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, color: AppTheme.grey, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String value, label, icon;
  final Color color;
  const _SummaryBox(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.dark)),
          Text(label,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.grey,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _HabitProgressCard extends StatelessWidget {
  final Habit habit;
  final AppProvider provider;
  const _HabitProgressCard(
      {required this.habit, required this.provider});

  static const List<String> _dayShort = ['M','T','W','T','F','S','S'];

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.colorValue);
    final weekStats = provider.getWeeklyStats(habit);
    final monthlyRate = provider.getMonthlyRate(habit);
    final streak = habit.currentStreak;
    final longest = habit.longestStreak;
    final total = habit.totalCompletions;
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(13)),
                child: Center(
                    child: Text(habit.emoji,
                        style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.name,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.dark)),
                    Text(
                        habit.weekDays.length == 7
                            ? 'Every day'
                            : '${habit.weekDays.length} days/week',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 12, color: AppTheme.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${(monthlyRate * 100).toInt()}%',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final date = now.subtract(Duration(days: 6 - i));
              final done = weekStats[i];
              final scheduled = habit.isScheduledFor(date);
              final isToday = i == 6;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: done
                          ? color
                          : scheduled
                              ? color.withOpacity(0.08)
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: isToday
                          ? Border.all(
                              color:
                                  done ? Colors.transparent : color,
                              width: 2)
                          : null,
                    ),
                    child: done
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : !scheduled
                            ? Center(
                                child: Text('—',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: Colors.grey.shade400)))
                            : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dayShort[date.weekday - 1],
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: isToday ? color : AppTheme.grey,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w500),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniStat('🔥', '$streak', 'Current'),
              _miniStat('🏆', '$longest', 'Best'),
              _miniStat('✅', '$total', 'Total'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(value,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.dark)),
          ],
        ),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11, color: AppTheme.grey)),
      ],
    );
  }
}
