import 'package:flutter/material.dart';
import '/widgets/categories_screen/category_item.dart';
import '/resources/dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // the GridView also has a builder mode which you can use if you  want to
    // build a dynamic amount of items, if you don't know in advance how many
    // items you'll have or if it's a very long grid and therefore, you
    // want that performance optimization where only items that are on the
    // screen are getting rendered.

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('DELI MEALS'),
      // ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          // define how the items should be sized regarding their
          // height and width relation
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        // map list of data to list of widgets
        children: DUMMY_CATEGORIES.map((category) {
          return CategoryItem(
            title: category.title,
            backgroundColor: category.color,
            id: category.id,
          );
        }).toList(),
      ),
    );
  }
}
