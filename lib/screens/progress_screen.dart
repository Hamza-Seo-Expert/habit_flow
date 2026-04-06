import 'package:flutter/material.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late PageController _pageController;
  int _currentWeekOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          final habits = appProvider.habits;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Card
                _buildStatsCard(context, habits, appProvider),
                SizedBox(height: AppTheme.lg),
                // Weekly View
                Text(
                  'Weekly Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.md),
                _buildWeeklyChart(context, habits),
                SizedBox(height: AppTheme.lg),
                // Habits Progress
                Text(
                  'All Habits',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.md),
                if (habits.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppTheme.xl),
                      child: Column(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 64,
                            color: AppTheme.textLight,
                          ),
                          SizedBox(height: AppTheme.md),
                          Text(
                            'No habits to track',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      final percentage =
                          habit.calculateCompletionPercentage() * 100;

                      return Padding(
                        padding: EdgeInsets.only(bottom: AppTheme.md),
                        child: _buildHabitProgressItem(
                          context,
                          habit,
                          percentage,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    List<Habit> habits,
    AppProvider appProvider,
  ) {
    final totalHabits = habits.length;
    final activeToday = appProvider.todaysHabits.length;
    final completedToday = appProvider.todaysHabits
        .where((h) => h.isCompletedToday)
        .length;

    return Container(
      padding: EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.textLight.withOpacity(0.2),
        ),
        boxShadow: [AppTheme.shadowSm],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            'Total',
            totalHabits.toString(),
            AppTheme.primaryColor,
          ),
          _buildStatItem(
            context,
            'Today',
            activeToday.toString(),
            AppTheme.accentColor,
          ),
          _buildStatItem(
            context,
            'Completed',
            completedToday.toString(),
            AppTheme.moodGood,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: color,
              ),
        ),
        SizedBox(height: AppTheme.sm),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(BuildContext context, List<Habit> habits) {
    final today = DateTime.now();
    final weekDays = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    return Container(
      padding: EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.textLight.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekDays.map((date) {
              final dayAbbr = DateFormat('E').format(date).substring(0, 1);
              final dayNum = date.day.toString();
              final completionForDay = _calculateDayCompletion(habits, date);

              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        AppTheme.textLight.withOpacity(0.1),
                        AppTheme.accentColor,
                        completionForDay,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${(completionForDay * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.sm),
                  Text(
                    dayAbbr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    dayNum,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitProgressItem(
    BuildContext context,
    Habit habit,
    double percentage,
  ) {
    final categoryColor =
        AppTheme.categoryColors[habit.category] ?? AppTheme.primaryColor;

    return Container(
      padding: EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.textLight.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: AppTheme.xs),
                    Text(
                      habit.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: categoryColor,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: categoryColor,
                    ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: categoryColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateDayCompletion(List<Habit> habits, DateTime date) {
    if (habits.isEmpty) return 0.0;
    final completedCount = habits.where((habit) {
      return habit.completedDates.any((d) =>
          d.year == date.year &&
          d.month == date.month &&
          d.day == date.day);
    }).length;
    return completedCount / habits.length;
  }
}