import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Fetch Pokémon from Gen 2 (IDs 152–251)
  static Future<List> fetchGen2Pokemon() async {
    List pokemonList = [];

    for (int id = 152; id <= 251; id++) {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        pokemonList.add(data);
      } else {
        print("Failed to load Pokémon ID $id");
      }
    }

    return pokemonList;
  }
}
