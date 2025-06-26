import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetailScreen extends StatelessWidget {
  final dynamic pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  // 🟣 Get color based on Pokémon type
  Color getColorForType(String type) {
    switch (type) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'poison':
        return Colors.purple;
      case 'bug':
        return Colors.lightGreen;
      case 'normal':
        return Colors.brown;
      case 'psychic':
        return Colors.pink;
      case 'ground':
        return Colors.orange;
      case 'fighting':
        return Colors.deepOrange;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.indigo;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.deepPurple;
      case 'dark':
        return Colors.black54;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  // 🔍 Fetch next evolution data (if available)
  Future<Map<String, dynamic>?> fetchNextEvolution(int id) async {
    final speciesRes = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id'),
    );

    if (speciesRes.statusCode != 200) return null;

    final speciesData = json.decode(speciesRes.body);
    final evoUrl = speciesData['evolution_chain']['url'];

    final evoRes = await http.get(Uri.parse(evoUrl));
    if (evoRes.statusCode != 200) return null;

    final evoData = json.decode(evoRes.body);
    final chain = evoData['chain'];
    String current = pokemon['name'];
    String? nextName;

    if (chain['species']['name'] == current) {
      if (chain['evolves_to'].isNotEmpty) {
        nextName = chain['evolves_to'][0]['species']['name'];
      }
    } else if (chain['evolves_to'].isNotEmpty &&
        chain['evolves_to'][0]['species']['name'] == current) {
      if (chain['evolves_to'][0]['evolves_to'].isNotEmpty) {
        nextName = chain['evolves_to'][0]['evolves_to'][0]['species']['name'];
      }
    }

    if (nextName != null) {
      final nextRes = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$nextName'),
      );
      if (nextRes.statusCode == 200) {
        return json.decode(nextRes.body);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final types = (pokemon['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    final abilities = (pokemon['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(pokemon['name'].toString().toUpperCase())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(pokemon['sprites']['front_default'], height: 140),
            const SizedBox(height: 16),
            Text("ID: #${pokemon['id']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: types.map((type) {
                return Chip(
                  label: Text(type.toUpperCase()),
                  backgroundColor: getColorForType(type),
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text("Abilities: $abilities", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // 🔁 Evolution Section
            FutureBuilder<Map<String, dynamic>?>(
              future: fetchNextEvolution(pokemon['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Text("No further evolution");
                } else {
                  final evo = snapshot.data!;
                  return Column(
                    children: [
                      const Text(
                        "Next Evolution:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.network(
                        evo['sprites']['front_default'],
                        height: 80,
                        width: 80,
                      ),
                      Text(
                        evo['name'].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
