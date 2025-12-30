import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapsServices {
  static GoogleMapController? controller;

  static CameraPosition? initialCameraPosition;

  static Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _initGoogleMapsServices();
    } else {
      log('Location permission denied');
    }
  }

  static void _initGoogleMapsServices() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(26.56345335289818, 31.694334847033378),
      zoom: 12,
    );
  }

  static void dispose() {
    controller?.dispose();
  }
}
