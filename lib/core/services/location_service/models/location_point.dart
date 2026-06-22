import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

class LocationPoint extends Equatable {
  final double latitude;
  final double longitude;

  const LocationPoint({required this.latitude, required this.longitude});

  factory LocationPoint.fromLocationData(LocationData data) {
    return LocationPoint(latitude: data.latitude!, longitude: data.longitude!);
  }

  @override
  List<Object> get props => [latitude, longitude];
}
