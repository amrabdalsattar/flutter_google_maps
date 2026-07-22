import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/services/location_service/models/location_point.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/images_utils.dart';

part 'location_tracking_state.dart';

class LocationTrackingCubit extends Cubit<LocationTrackingState> {
  LocationTrackingCubit({required LocationData initialLocationData})
    : super(
        LocationTrackingState(
          location: LocationPoint.fromLocationData(initialLocationData),
        ),
      );

  final MarkerId _currentLocationMarkerId = const MarkerId('current_location');
  bool _isInitialized = false;

  Future<void> initMarker(LocationData locationData) async {
    final point = LocationPoint.fromLocationData(locationData);
    final marker = await _buildMarker(point);
    _isInitialized = true;
    emit(state.copyWith(markers: {marker}));
  }

  Future<void> trackLocation(LocationData locationData) async {
    if (!_isInitialized) return;
    final point = LocationPoint.fromLocationData(locationData);
    final updatedMarker = await _buildMarker(point);

    final updatedMarkers = {
      ...state.markers.where((m) => m.markerId != _currentLocationMarkerId),
      updatedMarker,
    };

    log('${state.markers.length}');

    emit(state.copyWith(location: point, markers: updatedMarkers));
  }

  Future<Marker> _buildMarker(LocationPoint point) async {
    return Marker(
      markerId: _currentLocationMarkerId,
      position: LatLng(point.latitude, point.longitude),
      icon: await _markerIcon(),
    );
  }

  Future<BitmapDescriptor> _markerIcon() async {
    return BitmapDescriptor.bytes(
      await ImagesUtils.getImageFromRawData(AppImages.locationMarker, 26),
    );
  }

  @override
  Future<void> close() {
    state.markers.clear();
    return super.close();
  }
}
