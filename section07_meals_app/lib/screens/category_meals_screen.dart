import 'package:flutter/material.dart';
import '/models/meal.dart';
import '/widgets/category_meals_screen/meal_item.dart';
// import '/resources/dummy_data.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  // final String categoryId;
  // final String categoryTitle;
  // const displayedMealsScreen({
  //   Key? key,
  //   required this.categoryId,
  //   required this.categoryTitle,
  // }) : super(key: key);

  const CategoryMealsScreen({
    Key? key,
    required this.availableMeals,
  }) : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List<Meal> _displayedMeals = [];
  String? _categoryTitle;
  bool _loadedInitData = false; // tạo một cái flag

  @override
  void initState() {
    // Lúc cần initState!!!
    // Load hết dữ liệu của các List
    // for (Meal meal in widget.availableMeals) {
    //   print(meal.title);
    // }
    super.initState();

    // final routeArgs =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    // error because initState runs too early => doesn't have context!

    // final String? _categoryId = routeArgs['id'];
    // String? _categoryTitle = routeArgs['title'];
    // do _displayedMeals và _categoryTitle cần truy xuất ở nhiều hàm

    // _displayedMeals = DUMMY_MEALS.where((meal) {
    //   return meal.categories.contains(_categoryId);
    // }).toList();
  }

  @override
  void didChangeDependencies() {
    if (_loadedInitData) return;
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    // error because initState runs too early => doesn't have context!

    final String? _categoryId = routeArgs['id'];
    _categoryTitle = routeArgs['title'];
    // do _displayedMeals và _categoryTitle cần truy xuất ở nhiều hàm

    // _displayedMeals = DUMMY_MEALS.where((meal) {
    //   return meal.categories.contains(_categoryId);
    // }).toList();
    // run nhiều lần chứ không chỉ một lần như initState
    // nên nó sẽ khởi tạo lại cái _displayedMeals này nhiều lần
    // => _removeMeal sẽ không còn tác dụng!

    _displayedMeals = widget.availableMeals.where((meal) {
      return meal.categories.contains(_categoryId);
    }).toList();

    _loadedInitData = true; // thay đổi giá trị của flag!

    super.didChangeDependencies();
  }

  // void _removeMeal(String mealId) {
  //   setState(() {
  //     _displayedMeals.removeWhere((element) => element.id == mealId);
  //   });
  // }

  @override
  // final routeArgs =
  //     ModalRoute.of(context)!.settings.arguments as Map<String, String>;
  // Using Named Routes & Passing Data With Named Routes

  // String? _categoryId = routeArgs['id'];
  // String? _categoryTitle = routeArgs['title'];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryTitle!.toUpperCase()),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            // return list of Meals match to this category!
            return MealItem(
              imageUrl: _displayedMeals[index].imageUrl,
              title: _displayedMeals[index].title,
              duration: _displayedMeals[index].duration,
              complexity: _displayedMeals[index].complexity,
              affordability: _displayedMeals[index].affordability,
              id: _displayedMeals[index].id,
              // removeItem: _removeMeal,
            );
          },
          itemCount: _displayedMeals.length,
        ),
      ),
    );
  }
}
