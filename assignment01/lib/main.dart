// 1) Create a new Flutter App (in this project)
// and output an AppBar and some text below it
// 2) Add a button which changes the text (to any other text of your choice)
// 3) Split the app into three widgets: App, TextControl & Text

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _textsIndex = 0;

  void _increaseIndex() {
    setState(() {
      _textsIndex = (_textsIndex + 1) % 9;
    });
    print(_textsIndex);
  }

  @override
  Widget build(BuildContext context) {
    const List _texts = [
      'Hello',
      'My',
      'Name',
      'Is',
      'Cloud!',
      'Nice',
      'To',
      'Meet',
      'You!',
    ];

    return MaterialApp(
        title: 'My First Assignment',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: App(
            texts: _texts,
            textsIndex: _textsIndex,
            increaseIndex: _increaseIndex));
  }
}
