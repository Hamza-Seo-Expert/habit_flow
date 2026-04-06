import 'package:flutter/material.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';
import 'package:habit_flow/widgets/habit_tile.dart';
import 'package:habit_flow/widgets/mood_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Habits'),
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          final todaysHabits = appProvider.todaysHabits;
          final completionRate = appProvider.todayCompletionRate;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion Card
                Container(
                  padding: EdgeInsets.all(AppTheme.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: [AppTheme.shadowMd],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Progress',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: AppTheme.textWhite,
                            ),
                      ),
                      SizedBox(height: AppTheme.md),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        child: LinearProgressIndicator(
                          value: completionRate,
                          minHeight: 12,
                          backgroundColor:
                              AppTheme.surfaceColor.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentColor,
                          ),
                        ),
                      ),
                      SizedBox(height: AppTheme.md),
                      Text(
                        '4${(completionRate * 100).toStringAsFixed(0)}% Complete',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: AppTheme.textWhite,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.lg),
                // Mood Bar
                MoodBar(),
                SizedBox(height: AppTheme.lg),
                // Habits List
                Text(
                  'Habits (${todaysHabits.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.md),
                if (todaysHabits.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppTheme.xl),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppTheme.textLight,
                          ),
                          SizedBox(height: AppTheme.md),
                          Text(
                            'No habits yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                          SizedBox(height: AppTheme.sm),
                          Text(
                            'Add your first habit to get started!',
                            style:
                                Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: todaysHabits.length,
                    itemBuilder: (context, index) {
                      final habit = todaysHabits[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppTheme.md),
                        child: HabitTile(
                          habit: habit,
                          onDelete: () {
                            appProvider.deleteHabit(habit.id);
                          },
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
}