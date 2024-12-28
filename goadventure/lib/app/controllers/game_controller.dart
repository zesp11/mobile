import 'package:get/get.dart';
import 'package:goadventure/app/models/pokemon.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/game_service.dart';

// This screen focuses on the active game session.
// It manages the game logic, decisions, and interactions with other players.
class GameController extends GetxController {
  final GameService gameService;

  GameController({required this.gameService});

  var currentPokemonId = 1.obs;
  var currentPokemon = Rx<Pokemon?>(null);
  var otherPokemons = <Pokemon>[].obs;

  // Loading indicators
  var isCurrentPokemonLoading = true.obs;
  var isOtherPokemonsLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemonData(currentPokemonId.value);
  }

  Future<void> fetchPokemonData(int id) async {
    isCurrentPokemonLoading.value = true; // Start loading
    try {
      // Start fetching both current Pokémon and other Pokémon concurrently
      final currentPokemonFuture = gameService.fetchPokemon(id);
      final otherPokemonsFuture = fetchOtherPokemons(id);

      // Wait for both futures to complete concurrently
      final pokemon = await currentPokemonFuture;
      currentPokemon.value = pokemon;

      // Make sure otherPokemonsFuture completes, but its errors won't interrupt
      await otherPokemonsFuture;
    } catch (e) {
      print("Error fetching Pokémon: $e");
    } finally {
      isCurrentPokemonLoading.value = false; // End loading
    }
  }

  Future<void> fetchOtherPokemons(int currentId) async {
    isOtherPokemonsLoading.value = true; // Start loading
    try {
      // Generate IDs of other Pokémon
      final nextIds = List.generate(4, (i) => currentId + i + 1);

      // Fetch Pokémon concurrently
      final pokemons = await gameService.fetchMultiplePokemon(nextIds);

      // Update the observable list
      otherPokemons.assignAll(pokemons);
    } catch (e) {
      print("Error fetching other Pokémon: $e");
    } finally {
      isOtherPokemonsLoading.value = false; // End loading
    }
  }

  void updateCurrentPokemon(int id) {
    currentPokemonId.value = id;
    fetchPokemonData(id);
  }
}
