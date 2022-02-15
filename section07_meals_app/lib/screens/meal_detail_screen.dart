import 'package:flutter/material.dart';
import '/resources/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  final Function toggleFavorite;
  final Function isFavorite;

  const MealDetailScreen({
    Key? key,
    required this.toggleFavorite,
    required this.isFavorite,
  }) : super(key: key);

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildSectionList(Widget child) {
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mealId = ModalRoute.of(context)!.settings.arguments as String;
    final _selectedMeal =
        DUMMY_MEALS.firstWhere((element) => element.id == _mealId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedMeal.title,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image, ingredients...
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _buildSectionTitle(context, 'Ingredients'),
            _buildSectionList(
              ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).primaryColorLight.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Text(
                        _selectedMeal.ingredients[index],
                      ),
                    ),
                  );
                },
                itemCount: _selectedMeal.ingredients.length,
              ),
            ),
            _buildSectionTitle(context, 'Steps'),
            _buildSectionList(
              ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Text('# ${index + 1}'),
                        ),
                        title: Text(
                          _selectedMeal.steps[index],
                        ),
                      ),
                      const Divider(
                        thickness: 1.3,
                      ),
                    ],
                  );
                },
                itemCount: _selectedMeal.steps.length,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.delete),
      //   onPressed: () {
      //     Navigator.of(context).pop(_mealId);
      // So down there, I will forward meal ID or backward
      // so to say, meal ID to the page we're it coming from.

      // Navigator.of(context).canPop();
      // So running can pop to check whether you actually can go back
      // before you do call pop might be a good idea if you're not sure
      // whether you have another page in your app.
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => toggleFavorite(_mealId),
        child: Icon(
          isFavorite(_mealId) ? Icons.star : Icons.star_border,
        ),
      ),
    );
  }
}
