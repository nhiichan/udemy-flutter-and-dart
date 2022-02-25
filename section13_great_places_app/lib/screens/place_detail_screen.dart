import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section13_great_places_app/providers/great_places_provider.dart';
import 'package:section13_great_places_app/screens/map_screen.dart';

class PlaceDetailcreen extends StatelessWidget {
  static const routeName = '/place-detail';
  const PlaceDetailcreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlacesProvider>(context, listen: false)
            .findById(id as String);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location!.address!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  // I'll set full screen dialog to true to change the appearance
                  // of that page a little bit and with that, we should be able
                  // to view that and later also to close it.
                  builder: (context) => MapScreen(
                    initialLocation: selectedPlace.location!,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: const Text('View on Map'),
          ),
        ],
      ),
    );
  }
}
