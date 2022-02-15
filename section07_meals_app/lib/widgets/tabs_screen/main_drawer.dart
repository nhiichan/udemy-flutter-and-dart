import 'package:flutter/material.dart';
import '/screens/filters_screen.dart';
import '/widgets/tabs_screen/drawer_item.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 25,
            ),
            alignment: Alignment.center,
            color: Theme.of(context).primaryColorLight,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),

          // let's now work on the concrete links, on the buttons we can click.
          const SizedBox(
            height: 20,
          ),
          DrawerItem(
            icon: Icons.restaurant,
            title: 'Meals',
            tapHandler: () {
              // Navigator.of(context).pushNamed('/');
              // But there's one behavior which I'm not liking, I'm always pushing my
              // page which I'm loading on top of that stack of pages.
              Navigator.of(context).pushReplacementNamed('/');
              // will not have the back button!
            },
          ),
          DrawerItem(
            icon: Icons.settings,
            title: 'Filters',
            tapHandler: () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
