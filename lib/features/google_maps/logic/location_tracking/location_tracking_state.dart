part of 'location_tracking_cubit.dart';

class LocationTrackingState extends Equatable {
  final LocationPoint location;
  final Set<Marker> markers;

  const LocationTrackingState({
    required this.location,
    this.markers = const {},
  });

  LocationTrackingState copyWith({
    LocationPoint? location,
    Set<Marker>? markers,
  }) {
    return LocationTrackingState(
      location: location ?? this.location,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object> get props => [location, markers];
}
