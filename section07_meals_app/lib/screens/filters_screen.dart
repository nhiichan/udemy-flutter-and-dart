import 'package:flutter/material.dart';

import '/widgets/tabs_screen/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveHandler;
  final Map<String, bool> currentFilters;

  const FiltersScreen({
    Key? key,
    required this.saveHandler,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool glutenFree = false;
  bool vegetarian = false;
  bool vegan = false;
  bool lactoseFree = false;

  @override
  void initState() {
    super.initState();
    glutenFree = widget.currentFilters['gluten'] as bool;
    lactoseFree = widget.currentFilters['lactose'] as bool;
    vegetarian = widget.currentFilters['vegetarian'] as bool;
    vegan = widget.currentFilters['vegan'] as bool;
  }

  Widget _buildSwitchListTile(String title, String subtitle, bool currentValue,
      Function(bool) updateValue) {
    return SwitchListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
        actions: [
          IconButton(
            onPressed: () {
              widget.saveHandler({
                'gluten': glutenFree,
                'lactose': lactoseFree,
                'vegan': vegan,
                'vegetarian': vegetarian,
              });
              // print({
              //   'gluten': glutenFree,
              //   'lactose': lactoseFree,
              //   'vegan': vegan,
              //   'vegetarian': vegetarian,
              // });
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchListTile(
                  'Gluten-free',
                  'Only include gluten-free meals',
                  glutenFree,
                  (newValue) {
                    setState(() {
                      glutenFree = newValue;
                      // vì nó sẽ không tự build lại nên cần phải setState
                    });
                  },
                ),
                _buildSwitchListTile(
                  'Lactose-free',
                  'Only include lactose-free meals',
                  lactoseFree,
                  (newValue) {
                    setState(() {
                      lactoseFree = newValue;
                      // vì nó sẽ không tự build lại nên cần phải setState
                    });
                  },
                ),
                _buildSwitchListTile(
                  'Vegetarian',
                  'Only include vegetarian meals',
                  vegetarian,
                  (newValue) {
                    setState(() {
                      vegetarian = newValue;
                      // vì nó sẽ không tự build lại nên cần phải setState
                    });
                  },
                ),
                _buildSwitchListTile(
                  'Vegan',
                  'Only include vegan meals',
                  vegan,
                  (newValue) {
                    setState(() {
                      vegan = newValue;
                      // vì nó sẽ không tự build lại nên cần phải setState
                    });
                  },
                ),
                // Ban đầu như này sẽ không đủ, vì khi mình chuyển sang
                // page categories meal rồi quay lại filters page thì
                // filters page sẽ bị load lại => mất hết các giá trị
                // của filter hiện tại!
              ],
            ),
            // have fixed amount of elements here => don't need builder
          ),
        ],
      ),
    );
  }
}
