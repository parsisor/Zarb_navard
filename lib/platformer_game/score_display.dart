

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends TextComponent with HasGameRef {
  int score = 0;

  ScoreDisplay()
      : super(
          text: '000000', 
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
    position = Vector2(15, 50); 
  }

  
  void updateScore(int points) {
    score += points;
    text = score.toString().padLeft(6, '0'); 
  }

}
