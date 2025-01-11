import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/ui/widgets/gamebook_card.dart';

class GamebookListView extends StatelessWidget {
  final List<Gamebook> gamebooks;
  final AuthController authController;

  GamebookListView({required this.gamebooks, required this.authController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gamebooks.length,
      itemBuilder: (context, index) {
        final gamebook = gamebooks[index];
        return GamebookCard(
          gamebook: gamebook,
          authController: authController,
        );
      },
    );
  }
}
