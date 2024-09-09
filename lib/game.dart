import 'dart:async'; // Import dart:async to use Timer
import 'package:flame/game.dart';
import 'char.dart';   // Import the updated char.dart file
import 'ground.dart'; // Import the ground.dart file
import 'obstacle.dart'; // Import the obstacle.dart file

class ZarbGame extends FlameGame {
  Timer? obstacleTimer; // Timer for obstacle spawning

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add the WhiteRectangle component with custom dimensions and margins
    add(WhiteRectangle(width: 60.0, height: 100.0, leftMargin: 60.0, bottomMargin: 150.0)); // Adjust the margins as needed

    // Add the Ground component with height and margins
    add(Ground(height: 150.0, leftMargin: 0.0, rightMargin: 0.0)); // Adjust height and margins as needed

    // Start spawning obstacles
    startObstacleSpawning();
  }

  // Function to start spawning obstacles periodically
  void startObstacleSpawning() {
    // Set up a timer to spawn obstacles every 3 seconds or more
    obstacleTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      add(Obstacle(width: 30.0, height: 60.0, speed: 200.0)); // Customize obstacle size and speed as needed
    });
  }

  @override
  void onRemove() {
    // Cancel the timer when the game is removed
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
