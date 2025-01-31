import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_app/cubit/dog_cubit.dart';
import 'package:tot_app/models/dog_model.dart';

class FavoriteButton extends StatefulWidget {
  final Dog dog;

  const FavoriteButton({super.key, required this.dog});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.white.withAlpha((0.9 * 255).toInt()),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey[800],
        ),
      ),
      onPressed: () => _toggleFavorite(context),
    );
  }

  void _toggleFavorite(BuildContext context) {
    setState(() => isFavorite = !isFavorite);

    if (isFavorite) {
      context.read<DogCubit>().saveDog(widget.dog);
    } else {
      context.read<DogCubit>().deleteDog(widget.dog);
    }

    _showSnackBar(context, isFavorite);
  }

  void _showSnackBar(BuildContext context, bool isFavorite) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: isFavorite ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        elevation: 6,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
