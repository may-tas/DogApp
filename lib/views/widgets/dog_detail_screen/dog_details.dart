import 'package:flutter/material.dart';
import 'package:tot_app/models/dog_model.dart';

class DogImage extends StatelessWidget {
  final Dog dog;

  const DogImage({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'dog-${dog.id}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            dog.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black45],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.pets, size: 64, color: Colors.grey[400]),
    );
  }
}

class DogContent extends StatelessWidget {
  final Dog dog;

  const DogContent({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dog.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTags(context),
          const SizedBox(height: 24),
          _buildInfoCard(
            context: context,
            title: 'About',
            content: dog.description,
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context: context,
            title: 'Characteristics',
            content: dog.temperament,
            icon: Icons.psychology_outlined,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context: context,
            title: 'Origin & Lifespan',
            content: '${dog.origin}\n\nLife expectancy: ${dog.lifespan}',
            icon: Icons.public,
          ),
          const SizedBox(height: 24),
          DogColors(colors: dog.colors),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    return Row(
      children: [
        _buildTag(context, dog.breedGroup),
        const SizedBox(width: 8),
        _buildTag(context, dog.size),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DogColors extends StatelessWidget {
  final List<String> colors;

  const DogColors({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) => _buildColorChip(color)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorChip(String color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).toInt()),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        color,
        style: const TextStyle(
          color: Color(0xFF424242),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
