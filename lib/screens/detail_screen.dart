import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';

class DetailScreen extends StatelessWidget {
  final Pokemon pokemon;
  const DetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(pokemon.imageUrl, height: 200),
            const SizedBox(height: 20),
            Text('Name: ${pokemon.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Type: ${pokemon.types.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
