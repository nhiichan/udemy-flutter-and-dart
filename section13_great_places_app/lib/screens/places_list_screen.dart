import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section13_great_places_app/providers/great_places_provider.dart';
import 'package:section13_great_places_app/screens/add_place_screen.dart';
import 'package:section13_great_places_app/screens/place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR PLACES'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlacesProvider>(context, listen: false)
            .fetchAndSetPlaces(), // listen: false => don't update!
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlacesProvider>(
                  builder: (context, greatPlaces, child) {
                    return greatPlaces.items.isEmpty
                        ? child!
                        : ListView.builder(
                            itemCount: greatPlaces.items.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  greatPlaces.items[index].image,
                                ),
                              ),
                              title: Text(greatPlaces.items[index].title),
                              subtitle: Text(
                                  greatPlaces.items[index].location!.address!),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailcreen.routeName,
                                  arguments: greatPlaces.items[index].id,
                                );
                              },
                            ),
                          );
                  },
                  child: const Center(
                    child: Text(
                      'Got no places yet, start adding some!',
                    ),
                  ),
                );
        },
      ),
    );
  }
}
