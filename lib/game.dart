// game.dart

import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'char.dart';
import 'ground.dart';
import 'obstacle.dart';
import 'collision.dart';
import 'timer_bar.dart'; // Import the TimerBar

class ZarbGame extends FlameGame {
  Timer? obstacleTimer;
  final Random random = Random();
  String currentProblem = "";
  List<int> answerOptions = [];
  late int correctAnswer;
  bool isCollisionHandled = false;
  TimerBar? timerBar; // Declare the timer bar as nullable

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final player = WhiteRectangle(
      width: 60.0,
      height: 100.0,
      leftMargin: 60.0,
      bottomMargin: 150.0,
    );
    add(player);

    add(Ground(
      height: 150.0,
      leftMargin: 0.0,
      rightMargin: 0.0,
    ));

    add(CollisionDetection(player));

    startObstacleSpawning();
  }

  void startObstacleSpawning() {
    spawnObstacle();
    spawnObstacleWithRandomDelay();
  }

  void spawnObstacleWithRandomDelay() {
    int randomDelay = 3000 + random.nextInt(2000);
    obstacleTimer = Timer(Duration(milliseconds: randomDelay), () {
      spawnObstacle();
      spawnObstacleWithRandomDelay();
    });
  }

  void spawnObstacle() {
    add(Obstacle(
      width: 30.0,
      height: 100.0,
      speed: 200.0,
    ));
  }

  void stopObstacleSpawning() {
    obstacleTimer?.cancel();
  }

  void generateNewProblem() {
    int num1 = random.nextInt(8) + 1;
    int num2 = random.nextInt(8) + 1;
    correctAnswer = num1 * num2;
    currentProblem = '$num1 × $num2 = ?';

    answerOptions = [correctAnswer];
    while (answerOptions.length < 4) {
      int wrongAnswer = random.nextInt(100);
      if (!answerOptions.contains(wrongAnswer)) {
        answerOptions.add(wrongAnswer);
      }
    }
    answerOptions.shuffle();
  }

  void pauseGame() {
    for (final obstacle in children.whereType<Obstacle>()) {
      obstacle.speed = 0;
    }
    stopObstacleSpawning();
  }

  void resumeGame() {
    for (final obstacle in children.whereType<Obstacle>()) {
      obstacle.speed = 200;
    }
    startObstacleSpawning();
  }

  void resetGameAfterCorrectAnswer() {
    overlays.remove('MultiplicationOverlay');
    resumeGame();
    timerBar?.removeFromParent(); // Remove the timer bar when the game resumes
    timerBar = null; // Clear the reference
  }

  bool checkAnswer(int answer) {
    if (answer == correctAnswer) {
      resetGameAfterCorrectAnswer();
      return true;
    } else {
      pauseGame();
      overlays.add('LossOverlay');
      return false;
    }
  }

  void reset() {
    overlays.remove('LossOverlay');
    isCollisionHandled = false;
    resumeGame();
    clearObstacles();
    timerBar?.removeFromParent(); // Ensure the timer bar is removed when resetting
    timerBar = null;
  }

  void clearObstacles() {
    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });
  }

  void handleCollision() {
    isCollisionHandled = true;
    pauseGame();
    generateNewProblem();
    overlays.add('MultiplicationOverlay');

    // Start or reset the timer bar specifically on collision
    if (timerBar == null) {
      timerBar = TimerBar(totalTime: 4); // Initialize the timer bar with 4 seconds
      add(timerBar!); // Add the timer bar to the game on collision
    } else {
      timerBar!.resetTimer(); // Reset the timer bar if it already exists
    }
  }

  @override
  void onRemove() {
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
