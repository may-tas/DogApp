import 'package:flutter/material.dart';
import 'package:tot_app/models/dog_model.dart';
import 'package:tot_app/views/widgets/dog_detail_screen/dog_details.dart';
import 'package:tot_app/views/widgets/dog_detail_screen/favourite_button.dart';

class DogDetailScreen extends StatelessWidget {
  const DogDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dog = ModalRoute.of(context)!.settings.arguments as Dog;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          DogAppBar(dog: dog),
          SliverToBoxAdapter(
            child: DogContent(dog: dog),
          ),
        ],
      ),
    );
  }
}

class DogAppBar extends StatelessWidget {
  final Dog dog;

  const DogAppBar({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: _buildBackButton(context),
      actions: [
        FavoriteButton(dog: dog),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: DogImage(dog: dog),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.white.withAlpha((0.9 * 255).toInt()),
        child: Icon(Icons.arrow_back, color: Colors.grey[800]),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
