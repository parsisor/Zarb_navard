// timer_bar.dart

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TimerBar extends PositionComponent with HasGameRef {
  final double totalTime;
  double elapsedTime = 0;
  late RectangleComponent outerBar;
  late RectangleComponent innerBar;

  TimerBar({required this.totalTime});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Create the outer bar (white background)
    outerBar = RectangleComponent(
      size: Vector2(150, 20),
      paint: BasicPalette.white.paint(),
    );
    add(outerBar);

    // Create the inner bar (black shrinking bar)
    innerBar = RectangleComponent(
      size: Vector2(150, 20),
      paint: BasicPalette.black.paint(),
    );
    add(innerBar);

    // Position the timer bar at the top right corner
    position = Vector2(gameRef.size.x - 160, 10); // Adjust positions as needed
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    // Calculate the percentage of time remaining
    double remainingTimePercentage = (totalTime - elapsedTime) / totalTime;
    innerBar.size.x = outerBar.size.x * remainingTimePercentage;

    // Reset the timer bar if time runs out
    if (elapsedTime >= totalTime) {
      // You can trigger additional actions here if needed when time runs out
      elapsedTime = totalTime; // Cap elapsedTime at totalTime
      gameRef.overlays.remove('MultiplicationOverlay');
      gameRef.overlays.add('LossOverlay'); // Show the overlay
    }
  }

  void resetTimer() {
    elapsedTime = 0;
    innerBar.size.x = outerBar.size.x;
  }
}
