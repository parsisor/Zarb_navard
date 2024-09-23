

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LivesDisplay extends PositionComponent {
  int lives;

  LivesDisplay({required this.lives});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    updateLives(lives); 
  }

  void updateLives(int lives) {
    this.lives = lives;
    children.clear(); 

    
    for (int i = 0; i < lives; i++) {
      add(CircleComponent(
        radius: 10.0,
        position: Vector2(20.0 + i * 25.0, 20.0), 
        paint: Paint()..color = Colors.redAccent, 
      ));
    }
  }
}
