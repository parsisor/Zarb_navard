import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with HasGameRef {
  final double width;
  final double height;
  double speed; // Speed at which the obstacle falls towards the player

  Obstacle({
    this.width = 20.0,
    this.height = 60.0,
    this.speed = 200.0, // Adjust speed as needed
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set the size of the obstacle
    size = Vector2(width, height);

    // Position the obstacle at the top center of the screen
    final gameWidth = gameRef.size.x;
    position = Vector2((gameWidth / 2) - (width / 2), -height); // Start at the top
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the obstacle downwards towards the white rectangle
    position.y += speed * dt;

    // Remove the obstacle if it goes off the bottom of the screen
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.red; // Set the color of the obstacle to red
    canvas.drawRect(size.toRect(), paint);
  }
}
