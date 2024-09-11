// overlay.dart
import 'package:flutter/material.dart';
import 'game.dart'; // Import ZarbGame

class MultiplicationOverlay extends StatelessWidget {
  final ZarbGame game;

  const MultiplicationOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              game.currentProblem,
              style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
          ],
          ),
        
        const SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: game.answerOptions.map((answer) {
            return GestureDetector(
                onTap: () {
                  // Handle answer selection
                  if (game.checkAnswer(answer)) {
                    game.overlays.remove('MultiplicationOverlay'); // Hide the overlay if correct
                    game.generateNewProblem(); // Generate a new problem after a correct answer
                  } else {
                    game.overlays.remove('MultiplicationOverlay'); // Hide the current overlay
                    game.overlays.add('LossOverlay'); // Show the loss overlay
                  }
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.white,
                  child: Text(
                    answer.toString(),
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
              );

          }).toList(),
        ),

          ],
        ),
        
      ],
    );
  }
}

class LossOverlay extends StatelessWidget {
  final ZarbGame game;

  const LossOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'شما باختید',
            style: TextStyle(fontSize: 32.0, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              game.reset(); // Reset the game state
              game.overlays.remove('LossOverlay'); // Hide the loss overlay
            },
            child: const Text('دوباره بازی کن'),
          ),
        ],
      ),
    );
  }
}
