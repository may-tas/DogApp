import 'package:google_maps_flutter/google_maps_flutter.dart';

class Journey {
  final int? id;
  final LatLng sourceLocation;
  final LatLng destinationLocation;
  final DateTime startTime;
  final DateTime endTime;
  final List<LatLng> routePoints;
  final double distance; // in kilometers

  Journey({
    this.id,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.startTime,
    required this.endTime,
    required this.routePoints,
    required this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source_lat': sourceLocation.latitude,
      'source_lng': sourceLocation.longitude,
      'dest_lat': destinationLocation.latitude,
      'dest_lng': destinationLocation.longitude,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'route_points': routePoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join(';'),
      'distance': distance,
    };
  }

  factory Journey.fromMap(Map<String, dynamic> map) {
    final routePointsList = map['route_points'].split(';').map((point) {
      final coords = point.split(',');
      return LatLng(
        double.parse(coords[0]),
        double.parse(coords[1]),
      );
    }).toList();

    return Journey(
      id: map['id'] as int?,
      sourceLocation: LatLng(map['source_lat'], map['source_lng']),
      destinationLocation: LatLng(map['dest_lat'], map['dest_lng']),
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      routePoints: List<LatLng>.from(routePointsList),
      distance: map['distance'],
    );
  }
}
