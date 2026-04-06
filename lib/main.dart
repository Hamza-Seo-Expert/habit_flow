import 'package:flutter/material.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/screens/add_habit_screen.dart';
import 'package:habit_flow/screens/home_screen.dart';
import 'package:habit_flow/screens/progress_screen.dart';
import 'package:habit_flow/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const HabitFlowApp());
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'HabitFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HabitFlowHome(),
      ),
    );
  }
}

class HabitFlowHome extends StatelessWidget {
  const HabitFlowHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final screens = [
          const HomeScreen(),
          const ProgressScreen(),
        ];

        return Scaffold(
          body: screens[appProvider.selectedNavIndex],
          floatingActionButton: appProvider.selectedNavIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddHabitScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appProvider.selectedNavIndex,
            onTap: appProvider.setNavIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Progress',
              ),
            ],
          ),
        );
      },
    );
  }
}