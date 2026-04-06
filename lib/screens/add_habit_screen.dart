import 'package:flutter/material.dart';
import 'package:habit_flow/providers/app_provider.dart';
import 'package:habit_flow/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late TextEditingController _nameController;
  String _selectedCategory = 'Health';

  final categories = [
    'Health',
    'Work',
    'Learning',
    'Fitness',
    'Mindfulness',
    'Social',
    'Creative',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addHabit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a habit name')), 
      );
      return;
    }

    context.read<AppProvider>().addHabit(
      name: _nameController.text.trim(),
      category: _selectedCategory,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habit'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit Name Field
            Text(
              'Habit Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.sm),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g., Morning Exercise',
              ),
            ),
            SizedBox(height: AppTheme.lg),
            // Category Selection
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: AppTheme.sm,
                mainAxisSpacing: AppTheme.sm,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;
                final categoryColor =
                    AppTheme.categoryColors[category] ?? AppTheme.primaryColor;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? categoryColor.withOpacity(0.2)
                          : AppTheme.surfaceColor,
                      border: Border.all(
                        color: isSelected ? categoryColor : AppTheme.textLight,
                        width: 2,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.substring(0, 1),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppTheme.xs),
                        Text(
                          category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? categoryColor
                                    : AppTheme.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: AppTheme.xl),
            // Add Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.textWhite,
                  padding: EdgeInsets.symmetric(vertical: AppTheme.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: Text(
                  'Add Habit',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textWhite,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}