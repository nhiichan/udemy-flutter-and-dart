import 'package:flutter/material.dart';

import 'my_text.dart';
import 'text_control.dart';

class App extends StatelessWidget {
  final List? texts;
  final int? textsIndex;
  final VoidCallback? increaseIndex;

  const App({
    Key? key,
    @required this.texts,
    required this.textsIndex,
    required this.increaseIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My First Assignment'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(label: texts![textsIndex!]),
            const SizedBox(
              height: 10,
            ),
            TextControl(onPressed: increaseIndex),
          ],
        ),
      ),
    );
  }
}
