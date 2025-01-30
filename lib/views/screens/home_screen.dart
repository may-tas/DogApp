import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOT APP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureCard(
              context,
              'Dogs Directory',
              'Explore and save different dog breeds',
              Icons.pets,
              () => Navigator.pushNamed(context, '/dogs'),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              context,
              'Location Tracking',
              'Track your journey and save routes',
              Icons.location_on,
              () => Navigator.pushNamed(context, '/tracking'),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              context,
              'History',
              'View saved dogs and tracked journeys',
              Icons.history,
              () => Navigator.pushNamed(context, '/history'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
