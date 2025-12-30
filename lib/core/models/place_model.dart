import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id, required this.name, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(id: 1, name: 'Cairo', latLng: const LatLng(30.0444, 31.2357)),
  PlaceModel(id: 2, name: 'Giza', latLng: const LatLng(30.0131, 31.2089)),
  PlaceModel(id: 3, name: 'Alexandria', latLng: const LatLng(31.2001, 29.9187)),
  PlaceModel(id: 4, name: 'Luxor', latLng: const LatLng(25.6872, 32.6396)),
  PlaceModel(id: 5, name: 'Aswan', latLng: const LatLng(24.0889, 32.8998)),
  PlaceModel(id: 6, name: 'Hurghada', latLng: const LatLng(27.2579, 33.8116)),
  PlaceModel(
    id: 7,
    name: 'Sharm El-Sheikh',
    latLng: const LatLng(27.9158, 34.3299),
  ),
  PlaceModel(id: 8, name: 'Mansoura', latLng: const LatLng(31.0409, 31.3785)),
  PlaceModel(id: 9, name: 'Tanta', latLng: const LatLng(30.7865, 31.0004)),
  PlaceModel(id: 10, name: 'Port Said', latLng: const LatLng(31.2653, 32.3019)),
];
