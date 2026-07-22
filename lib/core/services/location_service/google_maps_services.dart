import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapsService {
  GoogleMapController? controller;
  Location? _location;
  CameraPosition? initialCameraPosition;

  Location get location {
    _location ??= Location();
    return _location!;
  }

  Future<void> initMapStyle(BuildContext context) async {
    final nightStyle = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/night_map_style.json');
    controller?.setMapStyle(nightStyle);
  }

  Future<void> requestLocationPermission({
    required void Function() onDenied,
    required Future<void> Function() onGranted,
  }) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _initGoogleMapsServices();
      onGranted();
    } else if (status.isPermanentlyDenied || status.isDenied) {
      onDenied();
    }
  }

  Future<LocationData> getLocation() async {
    return await location.getLocation();
  }

  StreamSubscription<LocationData> trackLocation(
    void Function(LocationData) onLocationChanged,
  ) {
    return location.onLocationChanged.listen((locationData) {
      _updateCameraPosition(locationData);

      onLocationChanged(locationData);
    });
  }

  Future<void> _initGoogleMapsServices() async {
    final currentLocation = await getLocation();
    final lat = currentLocation.latitude;
    final lng = currentLocation.longitude;

    if (lat == null || lng == null) {
      log('Failed to get current location coordinates');
      return;
    }
    initialCameraPosition = CameraPosition(target: LatLng(lat, lng), zoom: 17);
  }

  void _updateCameraPosition(LocationData locationData) {
    controller?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(locationData.latitude!, locationData.longitude!),
      ),
    );
  }

  void dispose() {
    _location = null;
    initialCameraPosition = null;
    controller?.dispose();
  }
}

// World View => 0 - 3
// Country View => 4 - 6
// City View =>  10 - 12
// Street View => 13 - 17
// Building View => 18 - 20
