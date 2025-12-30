import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/google_maps_services.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future _initMap() async {
    await GoogleMapsServices.requestLocationPermission();
    _isReady = true;
    setState(() {});
  }

  void _initMapStyle() async {
    final nightStyle = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/night_map_style.json');
    GoogleMapsServices.controller?.setMapStyle(nightStyle);
  }

  @override
  void dispose() {
    GoogleMapsServices.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || GoogleMapsServices.initialCameraPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: GoogleMapsServices.initialCameraPosition!,
      circles: GoogleMapsServices.circles,
      onMapCreated: (controller) {
        GoogleMapsServices.controller = controller;
        _initMapStyle();
      },
      markers: GoogleMapsServices.markers,
      minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      scrollGesturesEnabled: true,
    );
  }
}


// World View => 0 - 3
// Country View => 4 - 6
// City View =>  10 - 12
// Street View => 13 - 17
// Building View => 18 - 20