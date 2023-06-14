import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SinglePokemon extends StatelessWidget {
  final String pokemonName;
  final String pokemonId;
  final List<String> pokemonTypes;

  const SinglePokemon({Key? key, required this.pokemonName, required this.pokemonId, required this.pokemonTypes}) : super(key: key);

  void playPokemonCry(String pokemonId) async {
    final player = AudioPlayer();
    await player.play(UrlSource('https://pokemoncries.com/cries/$pokemonId.mp3'));
  }

  static const Map<String, Color> typeColors = {
    'normal': Colors.grey,
    'fire': Colors.orange,
    'water': Colors.blue,
    'electric': Colors.amber,
    'grass': Colors.green,
    'ice': Colors.lightBlue,
    'fighting': Colors.red,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.lightBlue,
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Colors.brown,
    'ghost': Color.fromARGB(255, 60, 3, 71),
    'dragon': Colors.indigo,
    'dark': Colors.black,
    'steel': Colors.grey,
    'fairy': Colors.pink,
  };

  Widget buildTypeContainer(String type) {
    final backgroundColor = typeColors[type] ?? Colors.grey;
    final textColor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonId.png',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 200,
              height: 200,
            ),
            ElevatedButton(
              onPressed: () {
                playPokemonCry(pokemonId);
              },
              child: const Text('Play Pokémon Cry'),
            ),
            const SizedBox(height: 20),
            Text(
              'Pokémon Name: $pokemonName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pokémon ID: $pokemonId',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: pokemonTypes.map((type) => buildTypeContainer(type)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
