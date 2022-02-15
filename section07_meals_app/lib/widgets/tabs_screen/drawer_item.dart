import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback tapHandler;
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.tapHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto Condensed',
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: tapHandler,
    );
  }
}
