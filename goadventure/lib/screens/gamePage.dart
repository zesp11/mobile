import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goadventure/models/pokemon.dart';
import 'package:http/http.dart' as http;

// Fetch a single Pokémon
Future<Pokemon> fetchPokemon(int id) async {
  final url = 'https://pokeapi.co/api/v2/pokemon/$id';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Pokemon.fromJson(data);
  } else {
    throw Exception("Failed to load Pokémon");
  }
}

// Fetch next Pokémon buttons
Future<List<Pokemon>> fetchOtherPokemons(int currentId) async {
  final nextIds = List.generate(4, (i) => currentId + i + 1);
  final futures = nextIds.map((id) => fetchPokemon(id)).toList();

  try {
    return await Future.wait(futures);
  } catch (e) {
    throw Exception("Failed to load other Pokémon: $e");
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentPokemonId = 1; // currently displayed id
  late Future<Pokemon> _currentPokemonFuture;
  late Future<List<Pokemon>> _otherPokemonsFuture;

  @override
  void initState() {
    super.initState();
    _loadPokemonData(_currentPokemonId);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pokémon Display Section
        Expanded(
          flex: 3,
          child: FutureBuilder<Pokemon>(
            future: _currentPokemonFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                final pokemon = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      pokemon.imageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("No Data Found"));
              }
            },
          ),
        ),

        // Other Pokémon Buttons Section
        Flexible(
          flex: 2,
          child: FutureBuilder<List<Pokemon>>(
            future: _otherPokemonsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                final otherPokemons = snapshot.data!;
                return Column(
                  children: otherPokemons.map((pokemon) {
                    return Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _loadPokemonData(pokemon.id),
                          child: Text(
                            '${pokemon.name.toUpperCase()} (#${pokemon.id})',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Center(child: Text("No Data Found"));
              }
            },
          ),
        ),
      ],
    );
  }

  void _loadPokemonData(int id) {
    setState(() {
      _currentPokemonId = id;
      _currentPokemonFuture = fetchPokemon(id);
      _otherPokemonsFuture = fetchOtherPokemons(id);
    });
  }
}
