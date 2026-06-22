import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import '../../../../core/services/location_service/models/location_point.dart';

part 'location_tracking_state.dart';

class LocationTrackingCubit extends Cubit<LocationTrackingState> {
  final LocationData initialLocationData;
  LocationTrackingCubit({required this.initialLocationData})
    : super(
        LocationTrackingState(
          location: LocationPoint.fromLocationData(initialLocationData),
        ),
      );

  Future<void> trackLocation(LocationData locationData) async {
    final point = LocationPoint.fromLocationData(locationData);
    

    emit(state.copyWith(location: point));
  }

  

  
}
