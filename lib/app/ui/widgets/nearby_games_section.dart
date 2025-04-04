// Lists games near the user's location.
import 'package:flutter/material.dart';
import 'package:gotale/app/ui/widgets/section_widget.dart';

class NearbyGamesWidget extends StatelessWidget {
  const NearbyGamesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      child: Column(
        children: List.generate(3, (index) {
          // Mocked data for nearby games
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.location_on,
                  color: Colors.redAccent, size: 30),
              title: Text(
                "Mock Game Title $index", // Mocked data
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Started: Mock Date"), // Mocked data
            ),
          );
        }),
      ),
    );
  }
}
