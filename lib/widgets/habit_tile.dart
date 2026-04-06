import 'package:flutter/material.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onDelete;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final isCompleted = habit.isCompletedToday;
        final completionPercentage = habit.calculateCompletionPercentage();
        final categoryColor = AppTheme.categoryColors[habit.category] ?? AppTheme.primaryColor;

        return GestureDetector(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.accentColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppTheme.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        // Checkbox
                        GestureDetector(
                          onTap: () {
                            if (isCompleted) {
                              appProvider.uncompleteHabit(habit.id);
                            } else {
                              appProvider.completeHabit(habit.id);
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted ? AppTheme.accentColor : Colors.transparent,
                              border: Border.all(
                                color: isCompleted
                                    ? AppTheme.accentColor
                                    : AppTheme.textLight,
                                width: 2,
                              ),
                            ),
                            child: isCompleted
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: AppTheme.textWhite,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: AppTheme.md),
                        // Title and Category
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isCompleted
                                          ? AppTheme.textSecondary
                                          : AppTheme.textPrimary,
                                    ),
                              ),
                              SizedBox(height: AppTheme.xs),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusSm),
                                ),
                                child: Text(
                                  habit.category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: categoryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Delete button
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: Text('Delete'),
                              onTap: onDelete,
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.md),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      child: LinearProgressIndicator(
                        value: completionPercentage,
                        minHeight: 8,
                        backgroundColor: AppTheme.textLight.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          categoryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.sm),
                    // Progress text
                    Text(
                      '6foot at ja with truth la verfi Percentage A ne# Pilot
	                     ${((completionPercentage * 100).toStringAsFixed(0))}% Complete',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}