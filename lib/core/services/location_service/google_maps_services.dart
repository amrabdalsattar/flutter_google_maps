import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/app_images.dart';
import '../../utils/images_utils.dart';

class GoogleMapsService {
  static GoogleMapController? controller;
  static Location? _location;
  static CameraPosition? initialCameraPosition;

  static String get _currentLocationKey => 'current_location';

  static MarkerId get _currentLocationMarkerId => MarkerId(_currentLocationKey);

  static Location get location {
    _location ??= Location();
    return _location!;
  }

  static Set<Marker> markers = {};

  static Future<void> initMapStyle(BuildContext context) async {
    final nightStyle = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/night_map_style.json');
    controller?.setMapStyle(nightStyle);
  }

  static Future<void> requestLocationPermission({
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

  static Future<LocationData> getLocation() async {
    return await location.getLocation();
  }

  static StreamSubscription<LocationData> trackLocation(
    void Function(LocationData) onLocationChanged,
  ) {
    return location.onLocationChanged.listen((locationData) {
      _updateCameraPosition(locationData);
      _updateLocationMarker(locationData);
      onLocationChanged(locationData);
    });
  }

  static Future<void> _initGoogleMapsServices() async {
    final currentLocation = await getLocation();
    final lat = currentLocation.latitude;
    final lng = currentLocation.longitude;

    if (lat == null || lng == null) {
      log('Failed to get current location coordinates');
      return;
    }
    initialCameraPosition = CameraPosition(target: LatLng(lat, lng), zoom: 17);
    await _initMarkers();
  }

  static void _updateCameraPosition(LocationData locationData) {
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 17,
        ),
      ),
    );
  }

  static Future<void> _updateLocationMarker(LocationData locationData) async {
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final updatedMarker = Marker(
      markerId: _currentLocationMarkerId,
      position: latLng,
      icon: await _markerIcon(),
    );

    markers.removeWhere(
      (marker) => marker.markerId == _currentLocationMarkerId,
    );
    markers.add(updatedMarker);
  }

  static Future<void> _initMarkers() async {
    final BitmapDescriptor customIcon = await _markerIcon();
    markers.add(
      Marker(
        markerId: _currentLocationMarkerId,
        position: LatLng(
          initialCameraPosition!.target.latitude,
          initialCameraPosition!.target.longitude,
        ),
        icon: customIcon,
      ),
    );
  }

  static Future<BitmapDescriptor> _markerIcon() async {
    return BitmapDescriptor.bytes(
      await ImagesUtils.getImageFromRawData(AppImages.locationMarker, 26),
    );
  }

  static void dispose() {
    _location = null;
    initialCameraPosition = null;
    markers.clear();
    controller?.dispose();
  }
}

// World View => 0 - 3
// Country View => 4 - 6
// City View =>  10 - 12
// Street View => 13 - 17
// Building View => 18 - 20
