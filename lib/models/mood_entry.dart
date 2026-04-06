class MoodEntry {
  final String mood;
  final DateTime timestamp;

  MoodEntry({required this.mood, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MoodEntry(mood: $mood, timestamp: $timestamp)';
  }
}