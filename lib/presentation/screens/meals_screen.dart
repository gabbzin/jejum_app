import 'package:flutter/material.dart';
import 'package:jejum_app/domain/entities/meal.dart';
import 'package:jejum_app/domain/use-cases/meal/queries/get_by_day.dart';
import 'package:jejum_app/utils/formatters/format_date.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  DateTime selectedDay = DateTime.now();
  List<Meal> meals = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadMeals() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final getMealsByDay = context.read<GetByDayMealUseCase>();
      final result = await getMealsByDay(selectedDay);

      if (!mounted) return;

      setState(() {
        meals = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> changeDay(DateTime day) async {
    setState(() {
      selectedDay = day;
    });

    await loadMeals();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: theme.colorScheme.surfaceBright,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDay = selectedDay.subtract(Duration(days: 1));
                    });
                  },
                  icon: Icon(Icons.chevron_left),
                ),

                Text(
                  formatDate(selectedDay, true),
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDay = selectedDay.add(Duration(days: 1));
                    });
                  },
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          
        ],
      ),
    );
  }
}
