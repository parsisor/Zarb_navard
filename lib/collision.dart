// collision.dart

import 'package:flame/components.dart';
import 'char.dart'; // Import the WhiteRectangle class
import 'game.dart';
import 'obstacle.dart'; // Import the Obstacle class

class CollisionDetection extends Component with HasGameRef<ZarbGame> {
  final WhiteRectangle player; // Reference to the player (white rectangle)

  CollisionDetection(this.player);

  @override
  void update(double dt) {
    super.update(dt);

    // Check for collisions between the player and obstacles
    for (final obstacle in gameRef.children.whereType<Obstacle>()) {
      if (player.toRect().overlaps(obstacle.toRect()) && !gameRef.isCollisionHandled) {
        // Set collision flag to true
        gameRef.isCollisionHandled = true;

        // Pause all obstacles
        for (final obs in gameRef.children.whereType<Obstacle>()) {
          obs.speed = 0; // Set speed to 0 to pause the obstacles
        }

        // Trigger the multiplication problem generation from game.dart
        gameRef.generateNewProblem(); // Generate a problem only on collision
        game.overlays.add('MultiplicationOverlay'); // Show the overlay

        Future.delayed(Duration(seconds: 6), () {game.isCollisionHandled = false;});
        
        break; // Stop checking once a collision is detected
      }
    }
  }
}
