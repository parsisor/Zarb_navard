import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'game.dart';

class TimerBar extends PositionComponent with HasGameRef<ZarbGame> {
  final double totalTime;
  double elapsedTime = 0;
  late RectangleComponent outerBar;
  late RectangleComponent innerBar;

  bool isPaused = false; // Flag to track if the timer is paused

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

    if (!isPaused) {
      elapsedTime += dt;

      double remainingTimePercentage = (totalTime - elapsedTime) / totalTime;
      innerBar.size.x = outerBar.size.x * remainingTimePercentage;

      // Check if time is up
      if (elapsedTime >= totalTime) {
        elapsedTime = totalTime; 
        gameRef.loseLife(); 
      }
    }
  }

  // Pause the timer
  void pause() {
    isPaused = true; // Set the paused flag
  }

  // Resume the timer
  void resume() {
    isPaused = false; // Reset the paused flag
  }

  // Reset the timer to its initial state
  void resetTimer() {
    elapsedTime = 0;
    innerBar.size.x = outerBar.size.x;
    isPaused = false; // Ensure the timer is running after reset
  }
}
