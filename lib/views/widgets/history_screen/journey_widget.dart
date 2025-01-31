import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tot_app/cubit/history_cubit.dart';
import 'package:tot_app/models/journey_model.dart';

class JourneyCard extends StatelessWidget {
  final Journey journey;
  final dateFormatter = DateFormat('MMM dd, yyyy HH:mm');

  JourneyCard({super.key, required this.journey});

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dog'),
        content: Text('Are you sure you want to remove this journey details?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      context.read<HistoryCubit>().deleteJourney(journey.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              Icons.directions_walk,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(journey.startTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${journey.distance.toStringAsFixed(2)} km',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outlined, color: Colors.red),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: journey.sourceLocation,
                  zoom: 12,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('source'),
                    position: journey.sourceLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: journey.destinationLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: journey.routePoints,
                    color: Theme.of(context).primaryColor,
                    width: 4,
                  ),
                },
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _JourneyDetailRow(
                  icon: Icons.schedule,
                  label: 'Duration',
                  value:
                      '${journey.endTime.difference(journey.startTime).inMinutes} minutes',
                ),
                const SizedBox(height: 8),
                _JourneyDetailRow(
                  icon: Icons.play_circle_outline,
                  label: 'Start',
                  value: dateFormatter.format(journey.startTime),
                ),
                const SizedBox(height: 8),
                _JourneyDetailRow(
                  icon: Icons.stop_circle_outlined,
                  label: 'End',
                  value: dateFormatter.format(journey.endTime),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _JourneyDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }
}
