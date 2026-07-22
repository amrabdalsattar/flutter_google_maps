import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/extensions/dialogs.dart';
import '../../../core/services/location_service/google_maps_services.dart';
import '../logic/location_tracking/location_tracking_cubit.dart';

class LocationTrackingProvider extends StatefulWidget {
  const LocationTrackingProvider({super.key});

  @override
  State<LocationTrackingProvider> createState() =>
      _LocationTrackingProviderState();
}

class _LocationTrackingProviderState extends State<LocationTrackingProvider> {
  bool _isReady = false;
  StreamSubscription? _locationStream;
  late final LocationTrackingCubit _cubit;
  final GoogleMapsService _mapsService = GoogleMapsService();
  LocationData? _initialLocationData;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    await _mapsService.requestLocationPermission(
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
    _initialLocationData = await _mapsService.getLocation();
    _cubit = LocationTrackingCubit(initialLocationData: _initialLocationData!);
    _locationStream = _mapsService.trackLocation((locationData) {
      _cubit.trackLocation(locationData);
    });
  }

  @override
  void dispose() {
    _mapsService.dispose();
    _locationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _mapsService.initialCameraPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (_) => _cubit,
      child: BlocBuilder<LocationTrackingCubit, LocationTrackingState>(
        builder: (context, state) {
          return GoogleMap(
            initialCameraPosition: _mapsService.initialCameraPosition!,
            onMapCreated: (controller) {
              _mapsService.controller = controller;
              _mapsService.initMapStyle(context);
              _cubit.initMarker(_initialLocationData!);
            },
            markers: state.markers,
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
