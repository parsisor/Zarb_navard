import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class WhiteRectangle extends PositionComponent {
  final double width;   // Width of the rectangle
  final double height;  // Height of the rectangle
  final double leftMargin;   // Margin from the left side
  final double bottomMargin; // Margin from the bottom side

  WhiteRectangle({
    this.width = 20.0,
    this.height = 40.0, // Double the height of the original circle
    this.leftMargin = 20.0,
    this.bottomMargin = 50.0,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set the size of the rectangle
    size = Vector2(width, height);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // Position the rectangle at the bottom left with specified margins
    position = Vector2(leftMargin, gameSize.y - height - bottomMargin);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = BasicPalette.white.paint();
    // Draw the rectangle
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }
}
