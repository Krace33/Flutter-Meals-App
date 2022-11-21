import 'package:flutter/material.dart';

import 'dummy_data.dart';
import 'models/meal.dart';
import './screens/filters_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/category_meals_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = dummyMeals;

  List<Meal> _favouritedMeals = [];

  void _setFilters(Map<String, bool> filteredData) {
    setState(() {
      _filters = filteredData;

      _availableMeals = dummyMeals.where(((meal) {
        if (_filters['gluten'] as bool && !meal.isGlutenFree) return false;
        if (_filters['lactose'] as bool && !meal.isLactoseFree) return false;
        if (_filters['vegan'] as bool && !meal.isVegan) return false;
        if (_filters['vegetarian'] as bool && !meal.isVegetarian) return false;
        return true;
      })).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingIndex =
        _favouritedMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favouritedMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favouritedMeals
            .add(dummyMeals.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isMealFaourite(String mealId) {
    return _favouritedMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      theme: ThemeData(
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodySmall: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyMedium: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              titleMedium: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed',
              ),
            ),
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(secondary: Colors.amber),
      ),
      // home: const CategoriesScreen(),
      // initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(_favouritedMeals),
        CategoryMealsScreen.routeName: (_) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (_) => MealDetailScreen(_toggleFavourite, _isMealFaourite),
        FiltersScreen.routeName: (_) => FiltersScreen(_filters, _setFilters),
      },

      onGenerateRoute: ((settings) {
        print(settings.arguments);
        return MaterialPageRoute(builder: ((ctx) => const CategoriesScreen()));
      }),

      onUnknownRoute: ((settings) {
        return MaterialPageRoute(
            builder: (((ctx) => const CategoriesScreen())));
      }),
    );
  }
}
