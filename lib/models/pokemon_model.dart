class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final String? nextEvolution;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    this.nextEvolution,
  });

  factory Pokemon.fromJson(Map<String, dynamic> data, String name) {
    final sprites = data['sprites'];
    final image = sprites['other']['official-artwork']['front_default'];

    List<String> types = (data['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    List<String> abilities = (data['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    return Pokemon(
      name: name,
      imageUrl: image,
      types: types,
      abilities: abilities,
    );
  }
}
