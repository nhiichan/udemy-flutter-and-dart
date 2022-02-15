// and that is a screen which will only manage the tabs and then load different
// screens depending on which tab was selected.
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '/widgets/tabs_screen/main_drawer.dart';
import 'favorites_screen.dart';
import 'categories_screen.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;
  const TabsScreen({
    Key? key,
    required this.favoriteMeals,
  }) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': const CategoriesScreen(),
        'title': 'Categories',
      },
      {
        // 'page': FavoritesScreen(favoriteMeals: widget.favoriteMeals),
        // widget is not available here when we initialize our properties. You
        // can use the widget property in the build method, you can use it in
        // initState but you can't use it here when you initialize these properties.
        'page': FavoritesScreen(favoriteMeals: widget.favoriteMeals),
        'title': 'Favorites',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Adding Top TabBar
    // return DefaultTabController(
    //   initialIndex: 1,// ban đầu gạch dưới sẽ ở vị trí tab nào
    //   length: 2, // how many tabs you want to have
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('DELI MEALS'),
    //       bottom: const TabBar(
    //         indicatorColor: Colors.deepPurple,
    //         tabs: [
    //           Tab(
    //             icon: Icon(
    //               Icons.category,
    //             ),
    //             text: 'Categories',
    //           ),
    //           Tab(
    //             icon: Icon(
    //               Icons.star,
    //             ),
    //             text: 'Favorites',
    //           ),
    //         ],
    //       ),
    //     ),
    //     body: const TabBarView(
    //       children: [
    //         CategoriesScreen(),
    //         FavoritesScreen(),
    //         // should match the order of the tabs
    //       ],
    //     ),
    //     // which tab you selected and if it's the first tab,
    //     // then the first element which you add here to TabBarView
    //     // will be shown and if it's the second tab,
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
      ),
      drawer:
          const MainDrawer(), // hambuger icon = icon ba gạch ngang // filters
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: Container(
        height: 120,
        padding: const EdgeInsets.only(top: 5),
        child: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          currentIndex: _selectedPageIndex,
          // type: BottomNavigationBarType.shifting,
          // adding animation when select a tab
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.star),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
