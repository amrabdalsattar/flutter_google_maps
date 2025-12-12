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

  late GoogleMapController _controller;

  late CameraPosition _kGooglePlex;

  @override
  void initState() {
    super.initState();
    _kGooglePlex = const CameraPosition(
      target: LatLng(26.56345335289818, 31.694334847033378),
      zoom: 12,
    );
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (controller) {
            _controller = controller;
          },
          minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
          // cameraTargetBounds: CameraTargetBounds(
          //   LatLngBounds(
          //     southwest: const LatLng(26.47787750747611, 31.80212755051422),
          //     northeast: const LatLng(27.471794598784626, 30.82856646762486),
          //   ),
          // ),
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
        ),
        Positioned(
          right: 16,
          left: 16,
          bottom: 10,
          child: ElevatedButton(
            onPressed: () {
              final LatLng newPosition = const LatLng(
                27.47190882710127,
                30.830197250611466,
              );
              _controller.animateCamera(CameraUpdate.newLatLng(newPosition));
            },
            child: const Text('Change location'),
          ),
        ),
      ],
    );
  }
}


// World View => 0 - 3
// Country View => 4 - 6
// City View =>  10 - 12
// Street View => 13 - 17
// Building View => 18 - 20