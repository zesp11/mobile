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
  List<String> _otherPokemonNames = [];
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
            children: _otherPokemonNames.asMap().entries.map((entry) {
              final buttonLabel = entry.value;
              final pokemonId = _currentPokemonId + entry.key + 1;

              return Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _fetchPokemon(pokemonId),
                    child: Text(
                      buttonLabel,
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

  void _populateOtherPokemonButtons() {
    final nextPokemons = List.generate(4, (i) => _currentPokemonId + i + 1);
    setState(() {
      _otherPokemonNames = nextPokemons.map((id) => "Pokemon $id").toList();
    });
  }
}
