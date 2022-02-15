import 'package:flutter/material.dart';

class MealInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  const MealInfo({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 6,
        ),
        Text(label),
      ],
    );
  }
}
