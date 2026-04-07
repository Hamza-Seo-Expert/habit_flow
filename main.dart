import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/screens/home_screen.dart';
import 'package:habit_flow/screens/progress_screen.dart';
import 'package:habit_flow/screens/add_habit_screen.dart';
import 'package:habit_flow/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const HabitFlowApp());
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'HabitFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, provider, _) {
        return Scaffold(
          body: IndexedStack(
            index: provider.selectedNavIndex,
            children: _screens,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddHabitScreen()),
            ),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _BottomNav(
            currentIndex: provider.selectedNavIndex,
            onTap: provider.setNavIndex,
          ),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav(
      {required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      child: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Today',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              const SizedBox(width: 60),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Progress',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 24,
                color:
                    isSelected ? AppTheme.primary : AppTheme.grey),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.grey)),
          ],
        ),
      ),
    );
  }
}
