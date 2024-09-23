import 'package:flame/components.dart';
import 'char.dart'; // Import the WhiteRectangle class
import 'game.dart';
import 'obstacle.dart'; // Import the Obstacle class

class CollisionDetection extends Component with HasGameRef<ZarbGame> {
  final SpriteComponent player; // Reference to the player (white rectangle)

  CollisionDetection(this.player);

  @override
  void update(double dt) {
    super.update(dt);

    
    bool isTouchingObstacle = false;

    for (final obstacle in gameRef.children.whereType<Obstacle>()) {
      if (player.toRect().overlaps(obstacle.toRect())) {
        isTouchingObstacle = true;

        if (!gameRef.isCollisionHandled) {
          gameRef.handleCollision(); 
          break; 
        }
      }
    }

    
    if (!isTouchingObstacle && gameRef.isCollisionHandled) {
      gameRef.isCollisionHandled = false;
    }
  }

  
}
