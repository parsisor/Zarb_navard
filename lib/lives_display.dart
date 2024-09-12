// lives_display.dart

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LivesDisplay extends PositionComponent {
  int lives;

  LivesDisplay({required this.lives});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    updateLives(lives); // Initial rendering of lives
  }

  void updateLives(int lives) {
    this.lives = lives;
    children.clear(); // Clear previous circles

    // Draw circles representing the remaining lives
    for (int i = 0; i < lives; i++) {
      add(CircleComponent(
        radius: 10.0,
        position: Vector2(20.0 + i * 25.0, 20.0), // Position circles horizontally
        paint: Paint()..color = Colors.redAccent, // Bright red color for the lives
      ));
    }
  }
}
