import 'package:flutter/material.dart';
import '/screens/meal_detail_screen.dart';
import '/widgets/category_meals_screen/meal_info.dart';
import '/models/meal.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  // final Function removeItem;

  const MealItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.duration,
    required this.complexity,
    required this.affordability,
    // required this.removeItem,
  }) : super(key: key);

  // getter for complexity
  String get complexityText {
    switch (complexity) {
      case Complexity.simple:
        return 'Simple';
      case Complexity.hard:
        return 'Hard';
      case Complexity.challenging:
        return 'Challenging';
      default:
        return 'Unknown';
    }
  }

  String get affordabilityText {
    switch (affordability) {
      case Affordability.affordable:
        return 'Affordable';
      case Affordability.luxurious:
        return 'Luxurious';
      case Affordability.pricey:
        return 'Pricey';
      default:
        return 'Unknown';
    }
  }

  void _selectMeal(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (BuildContext context) => const MealDetailScreen(),
    //   ),
    // );

    Navigator.of(context)
        .pushNamed(
      MealDetailScreen.routeName,
      arguments: id,
    )
        .then((result) {
      // So if you're passing any result to the pop method as we are doing it
      // here, then you get that result here
      // in the function you pass to then and for now I'll just print it.
      // print(result);
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            // want to display the image of the recipe and on top of that image,
            // I also want to show the title => Stack!
            Stack(
              children: [
                // image
                // instead I also want to have rounded corners on the image
                // otherwise it will not look good in that rounded corners card
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // works inside of a stack
                Positioned(
                  // the stack container itself is defined by its biggest child
                  // which here clearly is our image.
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300, // to use softWrap and overflow!
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),

            // Add some information below that image title thing here.
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MealInfo(icon: Icons.schedule, label: '$duration min'),
                  MealInfo(icon: Icons.work, label: complexityText),
                  MealInfo(icon: Icons.attach_money, label: affordabilityText),
                ],
              ),
            )
          ],
        ), // multiple meals
      ),
    ); // for clickable
  }
}
