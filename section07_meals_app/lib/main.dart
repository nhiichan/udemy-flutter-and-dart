import 'package:flutter/material.dart';
import 'resources/dummy_data.dart';
import 'screens/filters_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/category_meals_screen.dart';
import 'screens/categories_screen.dart';
import 'models/meal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> availableMeals = DUMMY_MEALS;
  List<Meal> favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      filters = filterData;
      availableMeals = DUMMY_MEALS.where((meal) {
        if (filters['gluten'] == true && !meal.isGlutenFree) {
          return false;
        }
        if (filters['lactose'] == true && !meal.isLactoseFree) {
          return false;
        }
        if (filters['vegetarian'] == true && !meal.isVegetarian) {
          return false;
        }
        if (filters['vegan'] == true && !meal.isVegan) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    // turn into favorite or remove favorite
    final existingIndex =
        favoriteMeals.indexWhere((element) => element.id == mealId);
    if (existingIndex >= 0) {
      // didn find a meal
      setState(() {
        favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        favoriteMeals.add(
          DUMMY_MEALS.firstWhere((element) => element.id == mealId),
        );
      });
    }
    // Now this is of course not optimal as you can imagine because switching
    // the favorite status of a meal should not necessarily impact the entire app
  }

  bool _isMealFavorite(String mealId) {
    return favoriteMeals.any((element) => element.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Section 07',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
            .copyWith(secondary: Colors.greenAccent),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w700,
                fontSize: 33,
              ),
              titleMedium: const TextStyle(
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
              bodyLarge: const TextStyle(
                fontFamily: 'Roboto Condensed',
                fontSize: 22,
                color: Color.fromRGBO(20, 51, 51, 1),
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
            ),
      ),
      // home: const CategoriesScreen(),
      initialRoute: '/', // default is '/'
      routes: {
        // '/': (context) => const CategoriesScreen(), // still work!
        '/': (context) => TabsScreen(favoriteMeals: favoriteMeals),
        CategoryMealsScreen.routeName: ((context) => CategoryMealsScreen(
              availableMeals: availableMeals,
            )),
        // '/categories-meals': (context) => const CategoryMealsScreen(),
        // string keys which identify a route and a route is really just a
        // screen and then the value after the colon is in the end
        // your creation function for that screen
        // web: your-page.com/categories
        MealDetailScreen.routeName: ((context) => MealDetailScreen(
              toggleFavorite: _toggleFavorite, isFavorite: _isMealFavorite
            )),
        FiltersScreen.routeName: ((context) => FiltersScreen(
              saveHandler: _setFilters,
              currentFilters: filters,
            )),
      },
      // (RouteSettings) {}
      // onGenerateRoute: (settings) {
      //   print(settings.arguments);
      //   if (settings.name == '/meal-detail') {
      //     return MaterialPageRoute(builder: (context) => MealDetailScreen());
      //   }
      //   return MaterialPageRoute(builder: (context) => CategoriesScreen());
      // },
      // Using Named Routes & Passing Data With Named Routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => const CategoriesScreen());
      },
    );
  }
}
