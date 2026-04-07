import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';

class MoodBar extends StatelessWidget {
  const MoodBar({super.key});

  static const List<Map<String, dynamic>> _moods = [
    {'emoji': '😢', 'label': 'Awful', 'color': Color(0xFFEF4444)},
    {'emoji': '😕', 'label': 'Bad', 'color': Color(0xFFF97316)},
    {'emoji': '😐', 'label': 'Okay', 'color': Color(0xFFEAB308)},
    {'emoji': '😊', 'label': 'Good', 'color': Color(0xFF22C55E)},
    {'emoji': '🤩', 'label': 'Great', 'color': Color(0xFF5B5FEE)},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        final todayMood = provider.todaysMood;
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'How are you feeling?',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.dark),
                  ),
                  if (todayMood != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (_moods[todayMood.mood - 1]['color'] as Color)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Logged ✓',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _moods[todayMood.mood - 1]['color']
                                as Color),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (i) {
                  final mood = _moods[i];
                  final isSelected = todayMood?.mood == i + 1;
                  final color = mood['color'] as Color;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      provider.setMood(i + 1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? color : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.2 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              mood['emoji'] as String,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            mood['label'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: isSelected ? color : AppTheme.grey,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
