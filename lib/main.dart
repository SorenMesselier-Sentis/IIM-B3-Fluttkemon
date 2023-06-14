import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'single_pokemon.dart';

class PokemonInfo {
  final String name;
  final String spriteUrl;
  final List<String> types;
  final String id;

  PokemonInfo({
    required this.name,
    required this.spriteUrl,
    required this.types,
    required this.id,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Pokedex(title: 'Pokédex'),
    );
  }
}

class Pokedex extends StatefulWidget {
  const Pokedex({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  late Future<List<PokemonInfo>> pokemonInfos;
  List<PokemonInfo> filteredPokemonList = []; // Liste filtrée des Pokémon

  @override
  void initState() {
    super.initState();
    pokemonInfos = fetchPokemonInfos();
  }

  Future<List<PokemonInfo>> fetchPokemonInfos() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];
      List<PokemonInfo> pokemonList = [];

      for (var result in results) {
        final pokemonUrl = result['url'];
        final pokemonResponse = await http.get(Uri.parse(pokemonUrl));
        if (pokemonResponse.statusCode == 200) {
          final pokemonData = jsonDecode(pokemonResponse.body);
          final name = pokemonData['name'];
          final spriteUrl = pokemonData['sprites']['front_default'];
          final types = pokemonData['types']
              .map((type) => type['type']['name'])
              .toList()
              .cast<String>();
          final pokemonInfo = PokemonInfo(
            name: name,
            spriteUrl: spriteUrl,
            types: types,
            id: pokemonData['id'].toString(),
          );
          pokemonList.add(pokemonInfo);
        }
      }

      return pokemonList;
    } else {
      throw Exception('Failed to fetch Pokemon data');
    }
  }

  void filterPokemonList(String searchTerm) async {
    final pokemonList = await pokemonInfos;
    setState(() {
      filteredPokemonList = pokemonList.where((pokemon) {
        final nameLower = pokemon.name.toLowerCase();
        final searchTermLower = searchTerm.toLowerCase();
        return nameLower.contains(searchTermLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterPokemonList(value),
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PokemonInfo>>(
              future: pokemonInfos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final pokemonList = filteredPokemonList.isNotEmpty
                      ? filteredPokemonList
                      : snapshot.data!;

                  return ListView.builder(
                    itemCount: (pokemonList.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final startIndex = index * 2;
                      final endIndex = startIndex + 1;

                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SinglePokemon(
                                      pokemonName: pokemonList[startIndex].name,
                                      pokemonId: pokemonList[startIndex].id,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          pokemonList[startIndex].spriteUrl,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      pokemonList[startIndex].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Types: ${pokemonList[startIndex].types.join(', ')}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: endIndex < pokemonList.length
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SinglePokemon(
                                            pokemonName:
                                                pokemonList[endIndex].name,
                                            pokemonId: pokemonList[endIndex].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                pokemonList[endIndex].spriteUrl,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            pokemonList[endIndex].name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Types: ${pokemonList[endIndex].types.join(', ')}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
