import 'package:flutter/material.dart';
import 'features/google_maps/widgets/custom_google_map.dart';

void main() {
  runApp(const MapSample());
}

class MapSample extends StatelessWidget {
  const MapSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: CustomGoogleMap()),
    );
  }
}
