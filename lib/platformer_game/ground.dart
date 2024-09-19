import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  final double height;   // Height of the ground
  final double leftMargin; // Margin from the left side
  final double rightMargin; // Margin from the right side

  Ground({this.height = 50.0, this.leftMargin = 0.0, this.rightMargin = 0.0});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // The size will be set in the onGameResize method to cover the full width of the screen minus margins
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // Set the size of the ground to span the screen width minus left and right margins
    size = Vector2(gameSize.x - leftMargin - rightMargin, height);
    // Position the ground at the bottom of the screen
    position = Vector2(leftMargin, gameSize.y - height);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.green; // Set the color of the rectangle to green
    canvas.drawRect(size.toRect(), paint);
  }
}