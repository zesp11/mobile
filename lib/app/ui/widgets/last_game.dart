// Displays details of the last game played by the user.
import 'package:flutter/material.dart';
import 'package:gotale/app/ui/widgets/section_widget.dart';

class LastGameWidget extends StatelessWidget {
  const LastGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        color: Colors.blueAccent,
        child: ListTile(
          leading: const Icon(Icons.play_arrow, size: 40, color: Colors.white),
          title: const Text(
            "Mock Game Title", // Mocked data
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Started: Mock Date", // Mocked data
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                "Steps: 0", // Mocked data
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
