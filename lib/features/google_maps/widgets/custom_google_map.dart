import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      log('Location permission granted');
    } else {
      log('Location permission denied');
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _kGooglePlex;

  @override
  void initState() {
    super.initState();
    
    _kGooglePlex = const CameraPosition(target: LatLng(31, 41));
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
    );
  }
}
