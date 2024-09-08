import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class SpaceShooterGame extends FlameGame {
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}