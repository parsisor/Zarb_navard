// collision.dart

import 'package:flame/components.dart';
import 'package:zarb_navard_game/platformer_game/char.dart';
import 'package:zarb_navard_game/platformer_game/obstacles.dart';


import 'game.dart';


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
        gameRef.handleCollision(); // Use handleCollision to centralize the logic

        
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
