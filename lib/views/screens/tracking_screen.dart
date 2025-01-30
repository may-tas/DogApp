import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tot_app/cubit/tracking_cubit.dart';
import 'package:tot_app/cubit/tracking_state.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? _mapController;
  bool _isTracking = false;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
      ),
      body: BlocConsumer<TrackingCubit, TrackingState>(
        listener: (context, state) {
          if (state is TrackingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is TrackingStarted) {
            _updateMap(
                state); // Add this line to update map when tracking starts
          } else if (state is TrackingFinished) {
            setState(() {
              _isTracking = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Journey saved! Distance: ${state.journey.distance.toStringAsFixed(2)} km',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                polylines: _polylines,
                markers: _markers,
                mapType: MapType.normal,
                compassEnabled: true,
                zoomControlsEnabled: true,
              ),
              if (state is TrackingStarted)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Distance: ${_calculateDistance(state.routePoints).toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildTrackingButton(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrackingButton(BuildContext context, TrackingState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: _isTracking ? Colors.red : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        if (!_isTracking) {
          context.read<TrackingCubit>().startTracking();
          setState(() {
            _isTracking = true;
            _polylines.clear();
            _markers.clear();
          });
        } else {
          context.read<TrackingCubit>().stopTracking();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_isTracking ? Icons.stop : Icons.play_arrow),
          const SizedBox(width: 8),
          Text(
            _isTracking ? 'Stop Tracking' : 'Start Tracking',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _updateMap(TrackingStarted state) {
    final points = state.routePoints;
    if (points.isEmpty) return;

    // Update camera position to follow current location
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(state.currentLocation, 16),
    );

    // Update polyline
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
          patterns: [
            PatternItem.dash(20), // Add dashed pattern for better visibility
            PatternItem.gap(5),
          ],
        ),
      };

      // Update markers
      _markers = {
        Marker(
          markerId: const MarkerId('start'),
          position: points.first,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Start Point'),
        ),
        Marker(
          markerId: const MarkerId('current'),
          position: points.last,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      };
    });
  }

  double _calculateDistance(List<LatLng> points) {
    double totalDistance = 0;
    for (var i = 0; i < points.length - 1; i++) {
      totalDistance += _coordinateDistance(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  double _coordinateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
