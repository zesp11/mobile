import 'package:goadventure/app/models/pokemon.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

class GameService {
  final ApiService apiService;

  GameService({required this.apiService});

  // Fetch a single Pokémon
  Future<Pokemon> fetchPokemon(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id';
    try {
      final response = await apiService.getData(url);
      return Pokemon.fromJson(response);
    } catch (e) {
      throw Exception("Error fetching Pokémon: $e");
    }
  }

  // Fetch multiple Pokémon
  Future<List<Pokemon>> fetchMultiplePokemon(List<int> ids) async {
    try {
      // Fetch all Pokémon concurrently
      return await Future.wait(ids.map((id) => fetchPokemon(id)));
    } catch (e) {
      throw Exception("Error fetching multiple Pokémon: $e");
    }
  }
}
