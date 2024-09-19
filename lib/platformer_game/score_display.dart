// score_display.dart

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends TextComponent with HasGameRef {
  int score = 0;

  ScoreDisplay()
      : super(
          text: '000000', // Initialize with six zeros
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Arial',
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(15, 50); // Position at the top left corner
  }

  // Method to update the score
  void updateScore(int points) {
    score += points;
    text = score.toString().padLeft(6, '0'); // Keep the score display to six digits
  }

}
