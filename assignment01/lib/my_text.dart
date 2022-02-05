import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String? label;

  const MyText({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
    );
  }
}
