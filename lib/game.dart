import 'dart:async'; // Import dart:async to use Timer
import 'dart:math'; // Import dart:math for random number generation
import 'package:flame/game.dart';
import 'char.dart';   // Import the updated char.dart file
import 'ground.dart'; // Import the ground.dart file
import 'obstacle.dart'; // Import the obstacle.dart file

class ZarbGame extends FlameGame {
  Timer? obstacleTimer; // Timer for obstacle spawning
  final Random random = Random(); // Random number generator

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
    spawnObstacleWithRandomDelay();
  }

  // Function to spawn obstacles with a random delay of at least 5 seconds
  void spawnObstacleWithRandomDelay() {
    // Randomize delay with a minimum of 5 seconds and add a random value up to 3 seconds (adjustable)
    int randomDelay = 5000 + random.nextInt(3000); // 5000ms (5s) minimum + 0 to 3000ms (0 to 3s) random

    // Set up a timer to spawn an obstacle after the randomized delay
    obstacleTimer = Timer(Duration(milliseconds: randomDelay), () {
      add(Obstacle(width: 30.0, height: 60.0, speed: 200.0)); // Customize obstacle size and speed as needed
      // Schedule the next obstacle with another random delay
      spawnObstacleWithRandomDelay();
    });
  }

  @override
  void onRemove() {
    // Cancel the timer when the game is removed
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
