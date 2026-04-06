import 'package:flutter/material.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';
import 'package:provider/provider.dart';

class MoodBar extends StatelessWidget {
  const MoodBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How\'s your mood today?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppTheme.md),
            Container(
              padding: EdgeInsets.all(AppTheme.md),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: AppTheme.textLight.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MoodButton(
                    emoji: '😱',
                    label: 'Terrible',
                    moodValue: 1,
                    color: AppTheme.moodTerrible,
                    isSelected: appProvider.todaysMood == 1,
                    onTap: () => appProvider.setMood(1),
                  ),
                  _MoodButton(
                    emoji: '😞',
                    label: 'Bad',
                    moodValue: 2,
                    color: AppTheme.moodBad,
                    isSelected: appProvider.todaysMood == 2,
                    onTap: () => appProvider.setMood(2),
                  ),
                  _MoodButton(
                    emoji: '😐',
                    label: 'Neutral',
                    moodValue: 3,
                    color: AppTheme.moodNeutral,
                    isSelected: appProvider.todaysMood == 3,
                    onTap: () => appProvider.setMood(3),
                  ),
                  _MoodButton(
                    emoji: '😊',
                    label: 'Good',
                    moodValue: 4,
                    color: AppTheme.moodGood,
                    isSelected: appProvider.todaysMood == 4,
                    onTap: () => appProvider.setMood(4),
                  ),
                  _MoodButton(
                    emoji: '🤩',
                    label: 'Excellent',
                    moodValue: 5,
                    color: AppTheme.moodExcellent,
                    isSelected: appProvider.todaysMood == 5,
                    onTap: () => appProvider.setMood(5),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final int moodValue;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.moodValue,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(height: AppTheme.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? color : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}