// main.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game.dart'; // Import the renamed ZarbGame
import 'overlay.dart'; // Import the overlay code

void main() {
  runApp(
    GameWidget<ZarbGame>(
      game: ZarbGame(),
      overlayBuilderMap: {
        'MultiplicationOverlay': (context, game) => MultiplicationOverlay(game: game as ZarbGame),
        'LossOverlay': (context, game) => LossOverlay(game: game as ZarbGame), // Add the LossOverlay
      },
      initialActiveOverlays: [],
    ),
  );
}
