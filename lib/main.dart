import 'package:flutter/material.dart';
import 'features/google_maps/ui/location_tracking_provider.dart';

void main() {
  runApp(const MapSample());
}

class MapSample extends StatelessWidget {
  const MapSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(top: false, child: LocationTrackingProvider()),
      ),
    );
  }
}
