import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/extensions/dialogs.dart';
import '../../../../core/services/location_service/google_maps_services.dart';
import '../../logic/location_tracking/location_tracking_cubit.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  bool _isReady = false;
  StreamSubscription? _locationStream;
  late final LocationTrackingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    await GoogleMapsService.requestLocationPermission(
      onDenied: () => _showPermissionDeniedDialog(),
      onGranted: () async {
        if (!mounted) return;
        await _initLocationTracker();
        setState(() => _isReady = true);
      },
    );
  }

  void _showPermissionDeniedDialog() {
    context.showAlertDialog(
      title: 'Access Denied',
      subTitle:
          'Location permission is denied, please enable it from settings.',
      confirmText: 'Settings',
      denialText: 'Cancel',
      onConfirm: () => openAppSettings(),
    );
  }

  Future<void> _initLocationTracker() async {
    final locationData = await GoogleMapsService.getLocation();
    _cubit = LocationTrackingCubit(initialLocationData: locationData);
    _locationStream = GoogleMapsService.trackLocation((locationData) {
      _cubit.trackLocation(locationData);
    });
  }

  @override
  void dispose() {
    GoogleMapsService.dispose();
    _locationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || GoogleMapsService.initialCameraPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (_) => _cubit,
      child: BlocBuilder<LocationTrackingCubit, LocationTrackingState>(
        buildWhen: (previous, current) => previous.location != current.location,
        builder: (context, state) {
          return GoogleMap(
            initialCameraPosition: GoogleMapsService.initialCameraPosition!,
            onMapCreated: (controller) {
              GoogleMapsService.controller = controller;
              GoogleMapsService.initMapStyle(context);
            },
            markers: GoogleMapsService.markers,
            minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            scrollGesturesEnabled: true,
          );
        },
      ),
    );
  }
}
