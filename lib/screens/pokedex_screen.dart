import 'package:flutter/material.dart';
import 'package:pokedex/services/api_service.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatefulWidget {
  final String username;
  PokedexScreen({required this.username});

  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  List pokemonList = [];
  List filteredList = [];
  bool isLoading = true;

  final Map<String, Color> typeColors = {
    'normal': Colors.brown[300]!,
    'fire': Colors.redAccent,
    'water': Colors.blueAccent,
    'grass': Colors.green,
    'electric': Colors.amber,
    'ice': Colors.cyan[200]!,
    'fighting': Colors.orange,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.indigo[200]!,
    'psychic': Colors.pinkAccent,
    'bug': Colors.lightGreen[700]!,
    'rock': Colors.grey,
    'ghost': Colors.indigo,
    'dark': Colors.black54,
    'dragon': Colors.indigo[800]!,
    'steel': Colors.blueGrey,
    'fairy': Colors.pink[200]!,
  };

  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  void fetchPokemon() async {
    final data = await ApiService.fetchGen2Pokemon();
    setState(() {
      pokemonList = data;
      filteredList = data;
      isLoading = false;
    });
  }

  void searchPokemon(String query) {
    final filtered = pokemonList
        .where((p) => p['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredList = filtered;
    });
  }

  Color getCardColor(List types) {
    String primaryType = types[0]['type']['name'];
    return typeColors[primaryType] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${widget.username}")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: searchPokemon,
                    decoration: InputDecoration(
                      labelText: "Search Pokémon",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final pokemon = filteredList[index];
                      final types = pokemon['types'] as List;
                      final cardColor = getCardColor(types);

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PokemonDetailScreen(pokemon: pokemon),
                          ),
                        ),
                        child: Card(
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                pokemon['sprites']['front_default'],
                                height: 72,
                              ),
                              SizedBox(height: 10),
                              Text(
                                pokemon['name'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                types
                                    .map((t) => t['type']['name'])
                                    .join(', ')
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
