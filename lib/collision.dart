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
      if (player.toRect().overlaps(obstacle.toRect()) &&
          !gameRef.isCollisionHandled) {
        // Set collision flag to true
        gameRef.isCollisionHandled = true;

        // Pause all obstacles
        for (final obs in gameRef.children.whereType<Obstacle>()) {
          obs.speed = 0; // Set speed to 0 to pause the obstacles
        }

        // Trigger the multiplication problem generation from game.dart
        gameRef.generateNewProblem(); // Generate a problem only on collision
        gameRef.overlays.add('MultiplicationOverlay'); // Show the overlay
        gameRef.stopObstacleSpawning();

        

        break; // Stop checking once a collision is detected
      }
    }
    checkObstacleLeftScreenBoundary();
    // Check if any obstacle hits the left side of the screen
  }

  void checkObstacleLeftScreenBoundary() {
    for (final obstacle in gameRef.children.whereType<Obstacle>()) {
      if (obstacle.x <= 0) {
        // Set isCollisionHandled to false if any obstacle hits the left screen boundary
        gameRef.isCollisionHandled = false;

        // Optionally, remove the obstacle to prevent it from lingering at the edge
        obstacle.removeFromParent();
      }
    }
  }
}
