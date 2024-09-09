import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'char.dart';   // Import the updated char.dart file
import 'ground.dart'; // Import the ground.dart file
import 'obstacle.dart'; // Import the obstacle.dart file
import 'game.dart'; // Import the newly created game.dart file

void main() {
  runApp(GameWidget(game: ZarbGame()));
}
