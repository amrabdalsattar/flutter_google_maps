import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/place_model.dart';
import '../utils/app_images.dart';
import '../utils/images_utils.dart';

class GoogleMapsServices {
  static GoogleMapController? controller;

  static CameraPosition? initialCameraPosition;

  static Set<Marker> markers = {};
  static Set<Polyline> polylines = {};
  static Set<Polygon> polygons = {};
  static Set<Circle> circles = {};

  static Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _initGoogleMapsServices();
    } else {
      log('Location permission denied');
    }
  }

  static Future<void> _initGoogleMapsServices() async {
    initialCameraPosition = const CameraPosition(
      target: LatLng(30.0444, 31.2357),
      zoom: 12,
    );
    _initMarkers();
    _initCircles();
    // _initPolyLine();
    // _initPolygons();
  }

  static void _initMarkers() async {
    final BitmapDescriptor customIcon = BitmapDescriptor.bytes(
      await ImagesUtils.getImageFromRawData(AppImages.locationMarker, 26),
    );

    final myMarkers =
        places
            .map(
              (place) => Marker(
                icon: customIcon,
                markerId: MarkerId('${place.id}'),
                infoWindow: InfoWindow(title: place.name),
                position: place.latLng,
              ),
            )
            .toSet();
    markers.addAll(myMarkers);
  }

  // static void _initPolyLine() {
  //   final Polyline polyline = Polyline(
  //     geodesic: true,
  //     polylineId: const PolylineId('1'),
  //     startCap: Cap.roundCap,
  //     width: 3,
  //     color: Colors.amber,
  //     points: [
  //       places[0].latLng,
  //       places[1].latLng,
  //       places[2].latLng,
  //       places[3].latLng,
  //     ],
  //   );
  //   polylines.add(polyline);
  // }

  // static void _initPolygons() {
  //   final Polygon polygon = Polygon(
  //     polygonId: const PolygonId('1'),
  //     fillColor: Colors.black.withValues(alpha: 0.3),
  //     strokeWidth: 3,
  //     points: [
  //       places[0].latLng,
  //       places[1].latLng,
  //       places[2].latLng,
  //       places[8].latLng,
  //     ],
  //   );
  //   polygons.add(polygon);
  // }

  static void _initCircles() {
    final Circle circle = const Circle(
      circleId: CircleId('0'),
      center: LatLng(26.293993082436902, 31.88565764747587),
      radius: 10000,
      fillColor: Color.fromARGB(83, 50, 163, 84),
      strokeColor: Color(0xff32A353),
      strokeWidth: 2,
    );
    circles.add(circle);
  }

  static void dispose() {
    controller?.dispose();
  }
}
