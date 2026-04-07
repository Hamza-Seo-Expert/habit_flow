import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/mood_entry.dart';

class AppProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  Map<String, MoodEntry> _moods = {};
  bool _isLoading = true;
  int _selectedNavIndex = 0;

  List<Habit> get habits => _habits;
  Map<String, MoodEntry> get moods => _moods;
  bool get isLoading => _isLoading;
  int get selectedNavIndex => _selectedNavIndex;

  static const _habitsKey = 'habits_v1';
  static const _moodsKey = 'moods_v1';

  AppProvider() {
    _load();
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final hj = prefs.getString(_habitsKey);
    if (hj != null) {
      _habits =
          (jsonDecode(hj) as List).map((e) => Habit.fromJson(e)).toList();
    }
    final mj = prefs.getString(_moodsKey);
    if (mj != null) {
      _moods = (jsonDecode(mj) as Map)
          .map((k, v) => MapEntry(k, MoodEntry.fromJson(v)));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _habitsKey, jsonEncode(_habits.map((h) => h.toJson()).toList()));
  }

  Future<void> _saveMoods() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _moodsKey, jsonEncode(_moods.map((k, v) => MapEntry(k, v.toJson()))));
  }

  Future<void> addHabit({
    required String name,
    required String emoji,
    required int colorValue,
    required List<int> weekDays,
  }) async {
    _habits.add(Habit(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      colorValue: colorValue,
      weekDays: weekDays,
      createdAt: DateTime.now(),
    ));
    await _saveHabits();
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> toggleHabit(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final today = _todayStr();
    if (habit.completedDates.contains(today)) {
      habit.completedDates.remove(today);
    } else {
      habit.completedDates.add(today);
    }
    await _saveHabits();
    notifyListeners();
  }

  Future<void> setMood(int mood, {String? note}) async {
    final today = _todayStr();
    _moods[today] = MoodEntry(date: today, mood: mood, note: note);
    await _saveMoods();
    notifyListeners();
  }

  List<Habit> get todaysHabits =>
      _habits.where((h) => h.isScheduledFor(DateTime.now())).toList();

  MoodEntry? get todaysMood => _moods[_todayStr()];

  double get todayCompletionRate {
    final t = todaysHabits;
    if (t.isEmpty) return 0;
    return t.where((h) => h.isCompletedOn(DateTime.now())).length / t.length;
  }

  List<bool> getWeeklyStats(Habit habit) {
    final now = DateTime.now();
    return List.generate(
        7, (i) => habit.isCompletedOn(now.subtract(Duration(days: 6 - i))));
  }

  double getMonthlyRate(Habit habit) {
    final now = DateTime.now();
    int scheduled = 0, completed = 0;
    for (int i = 0; i < 30; i++) {
      final d = now.subtract(Duration(days: i));
      if (habit.isScheduledFor(d)) {
        scheduled++;
        if (habit.isCompletedOn(d)) completed++;
      }
    }
    return scheduled == 0 ? 0 : completed / scheduled;
  }

  String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
