import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';

class GameScreen extends StatelessWidget {
  final GameController controller =
      Get.put(GameController(apiService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Game'),
      ),
      body: Column(
        children: [
          // Pokémon Display Section
          Expanded(
            flex: 3,
            child: Obx(() {
              if (controller.currentPokemon.value == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final pokemon = controller.currentPokemon.value!;
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
              }
            }),
          ),

          // Other Pokémon Buttons Section
          Flexible(
            flex: 2,
            child: Obx(() {
              if (controller.otherPokemons.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: controller.otherPokemons.map((pokemon) {
                    return Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.updateCurrentPokemon(pokemon.id),
                          child: Text(
                            '${pokemon.name.toUpperCase()} (#${pokemon.id})',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
