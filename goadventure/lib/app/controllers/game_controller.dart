import 'package:get/get.dart';
import 'package:goadventure/app/models/pokemon.dart';
import 'package:goadventure/app/services/api_service.dart';

// This screen focuses on the active game session.
// It manages the game logic, decisions, and interactions with other players.
// class GameController extends GetxController {
//   final ApiService apiService = Get.find();

//   // Observables
//   var currentGame = {}.obs; // Current game data
//   var isWaitingForPlayers = false.obs;

//   void loadGame(String gameId) async {
//     currentGame.value = await apiService.getGameDetails(gameId);
//   }

//   void submitDecision(String decision) async {
//     isWaitingForPlayers.value = true;
//     await apiService.submitDecision(currentGame['id'], decision);

//     // Wait for other players
//     while (isWaitingForPlayers.value) {
//       var status = await apiService.getDecisionStatus(currentGame['id']);
//       if (status == 'complete') {
//         isWaitingForPlayers.value = false;
//         // Navigate to next step or results
//       } else {
//         await Future.delayed(Duration(seconds: 2));
//       }
//     }
//   }
// }

class GameController extends GetxController {
  final ApiService apiService;

  GameController({required this.apiService});

  var currentPokemonId = 1.obs;
  var currentPokemon = Rx<Pokemon?>(null);
  var otherPokemons = <Pokemon>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemonData(currentPokemonId.value);
  }

  // Fetch a single Pokémon
  Future<void> fetchPokemonData(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id';

    try {
      final response = await apiService.getData(url);

      currentPokemon.value = Pokemon.fromJson(response);
      fetchOtherPokemons(id); // Fetch other Pokemons once the current is loaded
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch other Pokémon
  Future<void> fetchOtherPokemons(int currentId) async {
    final nextIds = List.generate(4, (i) => currentId + i + 1);
    final futures = nextIds.map((id) => fetchSinglePokemon(id)).toList();

    try {
      final results = await Future.wait(futures);
      otherPokemons.assignAll(results);
    } catch (e) {
      throw Exception("Failed to load other Pokémon: $e");
    }
  }

  Future<Pokemon> fetchSinglePokemon(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id';
    final response = await apiService.getData(url);
    return Pokemon.fromJson(response);
  }

  // Update the current Pokémon
  void updateCurrentPokemon(int id) {
    currentPokemonId.value = id;
    fetchPokemonData(id); // Reload the Pokémon data
  }
}
