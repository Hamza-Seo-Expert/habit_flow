class MoodEntry {
  final String date;
  final int mood; // 1=Awful 2=Bad 3=Okay 4=Good 5=Great
  final String? note;

  MoodEntry({required this.date, required this.mood, this.note});

  Map<String, dynamic> toJson() => {
        'date': date,
        'mood': mood,
        'note': note,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        date: json['date'],
        mood: json['mood'],
        note: json['note'],
      );
}
