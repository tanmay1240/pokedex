import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/pokemon_model.dart';
import '../services/api_service.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> _allPokemon = [];
  List<Pokemon> _filteredPokemon = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  void _loadData() async {
    _allPokemon = await ApiService.fetchAllPokemon();
    setState(() {
      _filteredPokemon = _allPokemon;
      _isLoading = false;
    });
  }

  void _searchPokemon(String query) {
    setState(() {
      _filteredPokemon = _allPokemon
          .where(
            (poke) => poke.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      _searchPokemon(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.username}"),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.catching_pokemon),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitFadingCircle(color: Colors.red, size: 50.0),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search Pokémon...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: _filteredPokemon.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemBuilder: (context, index) {
                        final pokemon = _filteredPokemon[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PokemonDetailScreen(pokemon: pokemon),
                              ),
                            );
                          },
                          child: PokemonCard(pokemon: pokemon),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
