import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String _pokemonName = "Loading...";
  String _pokemonImageUrl = "";
  List<Map<String, dynamic>> _otherPokemonNames = [];
  int _currentPokemonId = 1;

  @override
  void initState() {
    super.initState();
    _fetchPokemon(_currentPokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_pokemonImageUrl.isNotEmpty)
                  Image.network(
                    _pokemonImageUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _pokemonName.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Column(
            children: _otherPokemonData.map((data) {
              final pokemonName = data['name'];
              final pokemonId = data['id'];

              return Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _fetchPokemon(pokemonId),
                    child: Text(
                      '$pokemonName (#$pokemonId)',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchPokemon(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _pokemonName = data['name'];
          _pokemonImageUrl = data['sprites']['front_default'];
          _currentPokemonId = id;
          _populateOtherPokemonButtons();
        });
      } else {
        throw Exception("Failed to load Pokémon");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _populateOtherPokemonButtons() async {
    final nextPokemons = List.generate(4, (i) => _currentPokemonId + i + 1);

    // List to store the Future responses
    // List to store the Future responses
    final List<Future<Map<String, dynamic>?>> pokemonFutures =
        nextPokemons.map((id) async {
      final url = 'https://pokeapi.co/api/v2/pokemon/$id';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'id': data['id'],
          'name': data['name'],
        };
      } else {
        print('Failed to load pokemon with ID $id');
        return null; // Return null if failed
      }
    }).toList();

    // Wait for all requests to complete
    final results = await Future.wait(pokemonFutures);

    // Filter out any null results (failed requests)
    final validResults = results.whereType<Map<String, dynamic>>().toList();

    setState(() {
      // Update _otherPokemonNames with valid results
      _otherPokemonNames = validResults.toList();
    });
  }
}
