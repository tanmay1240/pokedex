import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(pokemon.imageUrl, height: 80, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: pokemon.types
                  .map(
                    (type) => Chip(
                      label: Text(type),
                      backgroundColor: Colors.red.shade200,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
