import 'package:flame/components.dart';
import 'game.dart';
import 'obstacle.dart';
import 'player.dart';

class CustomCollisionDetection extends Component with HasGameRef<ZarbGame> {
  final Player player; // Reference to the player (custom class)

  CustomCollisionDetection(this.player);

  @override
  void update(double dt) {
    super.update(dt);

    bool isTouchingObstacle = false;

    for (final obstacle in gameRef.children.whereType<Obstacle>()) {
      if (player.toRect().overlaps(obstacle.toRect())) {
        isTouchingObstacle = true;

        if (!gameRef.isCollisionHandled) {
          gameRef.handleCollision(obstacle); 
          break; 
        }
      }
    }

    if (!isTouchingObstacle && gameRef.isCollisionHandled) {
      gameRef.isCollisionHandled = false;
    }
  }
}
