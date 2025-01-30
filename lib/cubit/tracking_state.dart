// States
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tot_app/models/journey_model.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingStarted extends TrackingState {
  final LatLng currentLocation;
  final List<LatLng> routePoints;
  TrackingStarted(this.currentLocation, this.routePoints);
}

class TrackingFinished extends TrackingState {
  final Journey journey;
  TrackingFinished(this.journey);
}

class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}
