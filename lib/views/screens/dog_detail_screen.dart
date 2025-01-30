import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_app/cubit/dog_cubit.dart';
import 'package:tot_app/models/dog_model.dart';

class DogDetailScreen extends StatelessWidget {
  const DogDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dog = ModalRoute.of(context)!.settings.arguments as Dog;

    return Scaffold(
      appBar: AppBar(
        title: Text(dog.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              context.read<DogCubit>().saveDog(dog);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dog saved to favorites')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              dog.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Description', dog.description),
                  const SizedBox(height: 16),
                  _buildInfoSection('Breed Group', dog.breedGroup),
                  const SizedBox(height: 16),
                  _buildInfoSection('Size', dog.size),
                  const SizedBox(height: 16),
                  _buildInfoSection('Lifespan', dog.lifespan),
                  const SizedBox(height: 16),
                  _buildInfoSection('Origin', dog.origin),
                  const SizedBox(height: 16),
                  _buildInfoSection('Temperament', dog.temperament),
                  const SizedBox(height: 16),
                  _buildColorSection('Colors', dog.colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildColorSection(String title, List<String> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: colors
              .map((color) => Chip(
                    label: Text(color),
                    backgroundColor: Colors.blue[100],
                  ))
              .toList(),
        ),
      ],
    );
  }
}
