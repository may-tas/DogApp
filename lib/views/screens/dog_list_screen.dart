import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_app/cubit/dog_cubit.dart';
import 'package:tot_app/cubit/dog_state.dart';
import 'package:tot_app/models/dog_model.dart';

class DogListScreen extends StatefulWidget {
  const DogListScreen({super.key});

  @override
  State<DogListScreen> createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DogCubit>().fetchDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dogs Directory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search dogs...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<DogCubit>().searchDogs(value);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<DogCubit, DogState>(
        builder: (context, state) {
          if (state is DogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DogLoaded) {
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
      ),
    );
  }

  Widget _buildDogCard(BuildContext context, Dog dog) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/dog-detail',
          arguments: dog,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              dog.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dog.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Breed Group: ${dog.breedGroup}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Size: ${dog.size}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
