import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tot_app/cubit/dog_cubit.dart';
import 'package:tot_app/cubit/dog_state.dart';
import 'package:tot_app/cubit/history_cubit.dart';
import 'package:tot_app/cubit/history_state.dart';
import 'package:tot_app/models/dog_model.dart';
import 'package:tot_app/models/journey_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load data when screen initializes
    context.read<HistoryCubit>().loadJourneys();
    context.read<DogCubit>().getSavedDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Saved Dogs'),
            Tab(text: 'Tracked Journeys'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavedDogsTab(context),
          _buildJourneysTab(),
        ],
      ),
    );
  }

  Widget _buildSavedDogsTab(BuildContext context) {
    return BlocBuilder<DogCubit, DogState>(
      builder: (context, state) {
        if (state is DogLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DogLoaded) {
          if (state.dogs.isEmpty) {
            return const Center(
              child: Text('No saved dogs yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.dogs.length,
            itemBuilder: (context, index) {
              return _buildDogCard(context, state.dogs[index]);
            },
          );
        } else if (state is DogError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDogCard(BuildContext context, Dog dog) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(dog.image),
          onBackgroundImageError: (_, __) {
            Icon(Icons.error);
          },
        ),
        title: Text(dog.name),
        subtitle: Text(dog.breedGroup),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<DogCubit>().deleteDog(dog);
          },
        ),
        onTap: () => Navigator.pushNamed(
          context,
          '/dog-detail',
          arguments: dog,
        ),
      ),
    );
  }

  Widget _buildJourneysTab() {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HistoryLoaded) {
          if (state.journeys.isEmpty) {
            return const Center(
              child: Text('No tracked journeys yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.journeys.length,
            itemBuilder: (context, index) {
              return _buildJourneyCard(state.journeys[index]);
            },
          );
        } else if (state is HistoryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildJourneyCard(Journey journey) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          'Journey ${journey.startTime.toString().split('.')[0]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Distance: ${journey.distance.toStringAsFixed(2)} km',
        ),
        children: [
          SizedBox(
            height: 200,
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
                  color: Colors.blue,
                  width: 3,
                ),
              },
              liteModeEnabled: true,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Start Time: ${journey.startTime.toString().split('.')[0]}'),
                Text('End Time: ${journey.endTime.toString().split('.')[0]}'),
                Text(
                  'Duration: ${journey.endTime.difference(journey.startTime).inMinutes} minutes',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
