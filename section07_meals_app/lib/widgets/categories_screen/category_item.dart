import 'package:flutter/material.dart';
import '/screens/category_meals_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color backgroundColor;
  const CategoryItem({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.id,
  }) : super(key: key);

  void _selectCategory(BuildContext context) {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (_) => CategoryMealsScreen(
    //           categoryId: '',
    //           categoryTitle: title,
    //         )));

    Navigator.of(context).pushNamed(
      //'/categories-meals',
      CategoryMealsScreen.routeName,
      arguments: {
        'id': id,
        'title': title,
      },
    );
    // Using Named Routes & Passing Data With Named Routes
  }

  @override
  Widget build(BuildContext context) {
    // But it would be nice to also have some visual feedback, so instead of a
    // GestureDetector, I'll use an InkWell.
    // InkWell is a widget which I briefly mentioned earlier in the course,
    // it's basically a GestureDetector which also fires off a ripple effect,
    // so this Material Design effect you have when you tap something,
    // where you have these waves coming out of the point where you tapped it.

    return InkWell(
      onTap: () => _selectCategory(context),
      splashColor: backgroundColor,
      borderRadius: BorderRadius.circular(15),
      // should match border radius of the container
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: LinearGradient(
            colors: [
              backgroundColor.withOpacity(0.6),
              backgroundColor.withOpacity(0.7),
              backgroundColor.withOpacity(0.9),
              backgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
