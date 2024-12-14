import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("This is GamePage"),
      ],
    );
  }
}


    // Column(
    //   children: <Widget>[
    //     const Expanded(
    //       child: Center(
    //         child: Text(
    //           "Choose an action:",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Column(
    //       children:
    //           ["Button 1", "Button 2", "Button 3", "Button 4"].map((label) {
    //         return SizedBox(
    //           width: double.infinity, // fill horizontal space
    //           child: ElevatedButton(
    //               onPressed: () {
    //                 print('$label pressed');
    //               },
    //               child: Text(
    //                 label,
    //                 style: const TextStyle(
    //                   fontSize: 24,
    //                 ),
    //               )),
    //         );
    //       }).toList(),
    //     )
    //   ],
    // ),