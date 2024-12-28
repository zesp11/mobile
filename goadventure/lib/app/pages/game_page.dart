import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';

class GameScreen extends StatelessWidget {
  final GameController controller =
      Get.put(GameController(gameService: Get.find()));

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Game'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Pokémon Display Section
              Flexible(
                flex: 3,
                child: Obx(() {
                  if (controller.isCurrentPokemonLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final pokemon = controller.currentPokemon.value;
                  if (pokemon == null) {
                    return const Center(child: Text("No Pokémon found!"));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Pokémon Image
                          Image.network(
                            pokemon.imageUrl,
                            height: screenHeight * 0.25,
                            width: screenWidth * 0.5,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          // Pokémon Name
                          Text(
                            pokemon.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // Pokémon ID
                          Text(
                            '#${pokemon.id}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              // Other Pokémon Buttons Section
              Flexible(
                flex: 2,
                child: Obx(() {
                  if (controller.isOtherPokemonsLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.otherPokemons.isEmpty) {
                    return const Center(
                        child: Text("No other Pokémon available!"));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.otherPokemons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final pokemon = controller.otherPokemons[index];

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () =>
                              controller.updateCurrentPokemon(pokemon.id),
                          child: Text(
                            '${pokemon.name.toUpperCase()} (#${pokemon.id})',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
