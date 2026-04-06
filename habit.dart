class Habit {
  final String id;
  final String name;
  final String emoji;
  final int colorValue;
  final List<int> weekDays;
  final DateTime createdAt;
  List<String> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorValue,
    required this.weekDays,
    required this.createdAt,
    List<String>? completedDates,
  }) : completedDates = completedDates ?? [];

  bool isCompletedOn(DateTime date) => completedDates.contains(_fmt(date));

  bool isScheduledFor(DateTime date) => weekDays.contains(date.weekday);

  int get currentStreak {
    int streak = 0;
    DateTime date = DateTime.now();
    for (int i = 0; i < 365; i++) {
      if (!isScheduledFor(date)) {
        date = date.subtract(const Duration(days: 1));
        continue;
      }
      if (isCompletedOn(date)) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  int get longestStreak {
    int longest = 0;
    int current = 0;
    DateTime date = DateTime.now();
    for (int i = 0; i < 365; i++) {
      if (!isScheduledFor(date)) {
        date = date.subtract(const Duration(days: 1));
        continue;
      }
      if (isCompletedOn(date)) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 0;
      }
      date = date.subtract(const Duration(days: 1));
    }
    return longest;
  }

  int get totalCompletions => completedDates.length;

  String _fmt(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'colorValue': colorValue,
        'weekDays': weekDays,
        'createdAt': createdAt.toIso8601String(),
        'completedDates': completedDates,
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'],
        name: json['name'],
        emoji: json['emoji'],
        colorValue: json['colorValue'],
        weekDays: List<int>.from(json['weekDays']),
        createdAt: DateTime.parse(json['createdAt']),
        completedDates: List<String>.from(json['completedDates']),
      );
}
