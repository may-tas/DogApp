import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tot_app/cubit/dog_cubit.dart';
import 'package:tot_app/cubit/dog_state.dart';
import 'package:tot_app/cubit/history_cubit.dart';
import 'package:tot_app/cubit/history_state.dart';
import 'package:tot_app/views/widgets/empty_state_widget.dart';
import 'package:tot_app/views/widgets/error_state_widget.dart';
import 'package:tot_app/views/widgets/history_screen/journey_widget.dart';
import 'package:tot_app/views/widgets/history_screen/saved_dog_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final dateFormatter = DateFormat('MMM dd, yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<HistoryCubit>().loadJourneys();
    context.read<DogCubit>().getSavedDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SavedDogsTab(),
          _JourneysTab(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        'History',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        tabs: const [
          Tab(
            icon: Icon(Icons.pets),
            text: 'Saved Dogs',
          ),
          Tab(
            icon: Icon(Icons.route),
            text: 'Journeys',
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

class _SavedDogsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DogCubit, DogState>(
      builder: (context, state) {
        if (state is DogLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DogLoaded && state.dogs.isEmpty) {
          return EmptyState(
            icon: Icons.pets,
            message: 'No saved dogs yet',
          );
        }

        if (state is DogLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.dogs.length,
            itemBuilder: (context, index) => DogCard(dog: state.dogs[index]),
          );
        }

        if (state is DogError) {
          return ErrorState(message: state.message);
        }

        return const SizedBox();
      },
    );
  }
}

class _JourneysTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryLoaded && state.journeys.isEmpty) {
          return EmptyState(
            icon: Icons.route,
            message: 'No tracked journeys yet',
          );
        }

        if (state is HistoryLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.journeys.length,
            itemBuilder: (context, index) => JourneyCard(
              journey: state.journeys[index],
            ),
          );
        }

        if (state is HistoryError) {
          return ErrorState(message: state.message);
        }

        return const SizedBox();
      },
    );
  }
}
