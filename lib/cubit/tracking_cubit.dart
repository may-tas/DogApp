import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tot_app/cubit/tracking_state.dart';
import '../models/journey_model.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';
import 'package:geolocator/geolocator.dart';

// Cubit
class TrackingCubit extends Cubit<TrackingState> {
  final LocationService _locationService;
  final DatabaseService _databaseService;
  StreamSubscription<Position>? _locationSubscription;
  List<LatLng> _routePoints = [];
  DateTime? _startTime;
  LatLng? _sourceLocation;

  TrackingCubit(this._locationService, this._databaseService)
      : super(TrackingInitial());

  Future<void> startTracking() async {
    try {
      final hasPermission = await _locationService.handleLocationPermission();
      if (!hasPermission) {
        emit(TrackingError('Location permission not granted'));
        return;
      }

      final position = await _locationService.getCurrentLocation();
      _sourceLocation = LatLng(position.latitude, position.longitude);
      _startTime = DateTime.now();
      _routePoints = [_sourceLocation!];

      _locationSubscription = _locationService.getLocationStream().listen(
        (Position position) {
          final newPoint = LatLng(position.latitude, position.longitude);
          _routePoints.add(newPoint);
          emit(TrackingStarted(newPoint, List.from(_routePoints)));
        },
        onError: (error) {
          emit(TrackingError(error.toString()));
        },
      );
    } catch (e) {
      emit(TrackingError(e.toString()));
    }
  }

  Future<void> stopTracking() async {
    try {
      await _locationSubscription?.cancel();
      final position = await _locationService.getCurrentLocation();
      final destinationLocation = LatLng(position.latitude, position.longitude);

      final journey = Journey(
        sourceLocation: _sourceLocation!,
        destinationLocation: destinationLocation,
        startTime: _startTime!,
        endTime: DateTime.now(),
        routePoints: _routePoints,
        distance: _locationService.calculateDistance(_routePoints),
      );

      await _databaseService.saveJourney(journey);
      emit(TrackingFinished(journey));
    } catch (e) {
      emit(TrackingError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
