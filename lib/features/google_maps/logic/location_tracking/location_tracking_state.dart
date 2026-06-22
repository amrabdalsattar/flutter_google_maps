part of 'location_tracking_cubit.dart';

class LocationTrackingState extends Equatable {
  final LocationPoint location;

  const LocationTrackingState({required this.location});

  LocationTrackingState copyWith({LocationPoint? location}) {
    return LocationTrackingState(location: location ?? this.location);
  }

  @override
  List<Object> get props => [location];
}
