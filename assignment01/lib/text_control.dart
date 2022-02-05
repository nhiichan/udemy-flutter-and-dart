import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final VoidCallback? onPressed;
  const TextControl({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('I still have something!!!'),
    );
  }
}
