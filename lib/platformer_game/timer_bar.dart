

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'game.dart'; 

class TimerBar extends PositionComponent with HasGameRef<ZarbGame> {
  final double totalTime;
  double elapsedTime = 0;
  late RectangleComponent outerBar;
  late RectangleComponent innerBar;

  TimerBar({required this.totalTime});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    
    outerBar = RectangleComponent(
      size: Vector2(150, 20),
      paint: BasicPalette.white.paint(),
    );
    add(outerBar);

    
    innerBar = RectangleComponent(
      size: Vector2(150, 20),
      paint: BasicPalette.black.paint(),
    );
    add(innerBar);

    
    position = Vector2(gameRef.size.x - 160, 10); 
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    
    double remainingTimePercentage = (totalTime - elapsedTime) / totalTime;
    innerBar.size.x = outerBar.size.x * remainingTimePercentage;

    
    if (elapsedTime >= totalTime) {
      elapsedTime = totalTime; 
      gameRef.loseLife(); 
    }
  }

  void resetTimer() {
    elapsedTime = 0;
    innerBar.size.x = outerBar.size.x;
  }
}
