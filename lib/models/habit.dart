class Habit {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;
  final List<DateTime> completedDates;
  
  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    this.completedDates = const [],
  });

  bool get isCompletedToday {
    final today = DateTime.now();
    return completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  double calculateCompletionPercentage() {
    if (completedDates.isEmpty) return 0.0;
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays + 1;
    return (completedDates.length / daysSinceCreation).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      completedDates: (json['completedDates'] as List)
          .map((d) => DateTime.parse(d))
          .toList(),
    );
  }
}