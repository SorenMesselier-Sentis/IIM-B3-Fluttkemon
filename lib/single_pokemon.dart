import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SinglePokemon extends StatelessWidget {
  final String pokemonName;
  final String pokemonId;

  const SinglePokemon({Key? key, required this.pokemonName, required this.pokemonId}) : super(key: key);

  void playPokemonCry(String pokemonId) async {
    final player = AudioPlayer();
    await player.play(UrlSource('https://pokemoncries.com/cries/$pokemonId.mp3'));

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
          ],
        ),
      ),
    );
  }
}
