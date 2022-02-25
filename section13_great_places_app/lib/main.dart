import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section13_great_places_app/providers/great_places_provider.dart';
import 'package:section13_great_places_app/screens/add_place_screen.dart';
import 'package:section13_great_places_app/screens/place_detail_screen.dart';
import 'package:section13_great_places_app/screens/places_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlacesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: ThemeData(
          primaryColor: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.amber),
        ),
        home: const PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (context) => const AddPlaceScreen(),
          PlaceDetailcreen.routeName: (context) => const PlaceDetailcreen(),
        },
      ),
    );
  }
}
