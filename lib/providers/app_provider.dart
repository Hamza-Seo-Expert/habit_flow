import 'package:flutter/foundation.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class AppProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  bool _isLoading = false;
  int _selectedNavIndex = 0;
  int _todaysMood = 3; // 1-5 scale

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  int get selectedNavIndex => _selectedNavIndex;
  int get todaysMood => _todaysMood;

  List<Habit> get todaysHabits {
    final today = DateTime.now();
    return _habits
        .where((habit) =>
            habit.createdAt.isBefore(today) ||
            (habit.createdAt.year == today.year &&
                habit.createdAt.month == today.month &&
                habit.createdAt.day == today.day))
        .toList();
  }

  double get todayCompletionRate {
    final todaysHabits_list = todaysHabits;
    if (todaysHabits_list.isEmpty) return 0.0;
    final completedCount =
        todaysHabits_list.where((h) => h.isCompletedToday).length;
    return completedCount / todaysHabits_list.length;
  }

  AppProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      await _loadHabits();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addHabit({
    required String name,
    required String category,
  }) async {
    try {
      _setLoading(true);
      final habit = Habit(
        id: const Uuid().v4(),
        name: name,
        category: category,
        createdAt: DateTime.now(),
      );
      _habits.add(habit);
      await _saveHabits();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeHabit(String habitId) async {
    try {
      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex != -1) {
        final habit = _habits[habitIndex];
        final updatedHabit = Habit(
          id: habit.id,
          name: habit.name,
          category: habit.category,
          createdAt: habit.createdAt,
          completedDates: [...habit.completedDates, DateTime.now()],
        );
        _habits[habitIndex] = updatedHabit;
        await _saveHabits();
        notifyListeners();
      }
    } catch (e) {
      print('Error completing habit: $e');
    }
  }

  Future<void> uncompleteHabit(String habitId) async {
    try {
      final habitIndex = _habits.indexWhere((h) => h.id == habitId);
      if (habitIndex != -1) {
        final habit = _habits[habitIndex];
        final today = DateTime.now();
        final updatedDates = habit.completedDates
            .where((date) =>
                !(date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day))
            .toList();
        final updatedHabit = Habit(
          id: habit.id,
          name: habit.name,
          category: habit.category,
          createdAt: habit.createdAt,
          completedDates: updatedDates,
        );
        _habits[habitIndex] = updatedHabit;
        await _saveHabits();
        notifyListeners();
      }
    } catch (e) {
      print('Error uncompleting habit: $e');
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      _setLoading(true);
      _habits.removeWhere((h) => h.id == habitId);
      await _saveHabits();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  Future<void> setMood(int mood) async {
    try {
      _todaysMood = mood;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('today_mood', mood);
      notifyListeners();
    } catch (e) {
      print('Error setting mood: $e');
    }
  }

  Future<void> _loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList('habits') ?? [];
      _habits = habitsJson
          .map((json) => Habit.fromJson(jsonDecode(json)))
          .toList();

      final mood = prefs.getInt('today_mood') ?? 3;
      _todaysMood = mood;
      notifyListeners();
    } catch (e) {
      print('Error loading habits: $e');
    }
  }

  Future<void> _saveHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = _habits
          .map((habit) => jsonEncode(habit.toJson()))
          .toList();
      await prefs.setStringList('habits', habitsJson);
    } catch (e) {
      print('Error saving habits: $e');
    }
  }
}