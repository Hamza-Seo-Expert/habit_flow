import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';

class HabitTile extends StatefulWidget {
  final Habit habit;
  const HabitTile({super.key, required this.habit});

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnim = Tween(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _controller.forward();
    await _controller.reverse();
    HapticFeedback.lightImpact();
    if (mounted) context.read<AppProvider>().toggleHabit(widget.habit.id);
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final isCompleted = habit.isCompletedOn(DateTime.now());
    final color = Color(habit.colorValue);
    final streak = habit.currentStreak;

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
            color: AppTheme.danger.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.delete_outline_rounded, color: AppTheme.danger, size: 24),
          const SizedBox(height: 4),
          Text('Delete',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.danger,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text('Delete Habit',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700, fontSize: 18)),
            content: Text(
                'Are you sure you want to delete "${habit.name}"?',
                style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.grey, fontSize: 14, height: 1.5)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Cancel',
                      style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.grey,
                          fontWeight: FontWeight.w600))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Delete',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<AppProvider>().deleteHabit(habit.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('"${habit.name}" deleted',
              style: GoogleFonts.plusJakartaSans()),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppTheme.dark,
        ));
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTap: _onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? color.withOpacity(0.06) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isCompleted
                      ? color.withOpacity(0.35)
                      : Colors.transparent,
                  width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                      color: isCompleted
                          ? color.withOpacity(0.18)
                          : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14)),
                  child: Center(
                      child: Text(habit.emoji,
                          style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? color.withOpacity(0.6)
                              : AppTheme.dark,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: color,
                          decorationThickness: 2.5,
                        ),
                        child: Text(habit.name),
                      ),
                      const SizedBox(height: 4),
                      streak > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(children: [
                                const Text('🔥',
                                    style: TextStyle(fontSize: 11)),
                                const SizedBox(width: 3),
                                Text('$streak day streak',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade700)),
                              ]))
                          : Text('Start your streak today!',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11, color: AppTheme.grey)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: isCompleted ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                          color:
                              isCompleted ? color : Colors.grey.shade300,
                          width: 2)),
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 17)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
