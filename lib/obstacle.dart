import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with HasGameRef {
  final double width;
  final double height;
  double speed; // Speed at which the obstacle moves towards the white rectangle

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
    
    // Position the obstacle just outside the right side of the screen
    final gameWidth = gameRef.size.x;
    final groundHeight = gameRef.size.y - 150.0; // Height of the ground from bottom

    // Position obstacle just outside the right border of the screen
    position = Vector2(gameWidth, groundHeight - height);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the obstacle towards the white rectangle
    position.x -= speed * dt;

    // Remove the obstacle if it goes off the left side of the screen
    if (position.x < -width) {
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
