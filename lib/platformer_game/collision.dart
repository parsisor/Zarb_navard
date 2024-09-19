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
    bool isTouchingObstacle = false;

    for (final obstacle in gameRef.children.whereType<Obstacle>()) {
      if (player.toRect().overlaps(obstacle.toRect())) {
        isTouchingObstacle = true;

        if (!gameRef.isCollisionHandled) {
          gameRef.handleCollision(); // Use handleCollision to centralize the logic
          break; // Stop checking once a collision is detected
        }
      }
    }

    // If no obstacle is touching the player, reset the collision handled flag
    if (!isTouchingObstacle && gameRef.isCollisionHandled) {
      gameRef.isCollisionHandled = false;
    }
  }

  // Remove unnecessary check for the obstacle hitting the left boundary, as the game is now vertical.
}
