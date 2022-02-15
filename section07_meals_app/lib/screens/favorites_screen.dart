import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/category_meals_screen/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;
  const FavoritesScreen({
    Key? key,
    required this.favoriteMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoriteMeals.isEmpty) {
      return const Center(
        child: Text('You have no favorites yet - start adding some!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          // return list of Meals match to this category!
          return MealItem(
            imageUrl: favoriteMeals[index].imageUrl,
            title: favoriteMeals[index].title,
            duration: favoriteMeals[index].duration,
            complexity: favoriteMeals[index].complexity,
            affordability: favoriteMeals[index].affordability,
            id: favoriteMeals[index].id,
            // removeItem: _removeMeal,
          );
        },
        itemCount: favoriteMeals.length,
      );
    }
    // Một vấn đề là nếu mình add favorite hay unfavorite từ favorites screen 
    // thì lúc back nó sẽ không rebuild lại => Màn hình vẫn hiện list cũ!
  }
}
