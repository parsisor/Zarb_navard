// game.dart

import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'char.dart';
import 'ground.dart';
import 'obstacle.dart';
import 'collision.dart';
import 'timer_bar.dart';
import 'lives_display.dart'; // Import the LivesDisplay component

class ZarbGame extends FlameGame {
  Timer? obstacleTimer;
  final Random random = Random();
  String currentProblem = "";
  List<int> answerOptions = [];
  late int correctAnswer;
  bool isCollisionHandled = false;
  TimerBar? timerBar;
  int lives = 3; // Initialize lives to 3
  LivesDisplay? livesDisplay; // Reference to the lives display

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

    livesDisplay = LivesDisplay(lives: lives); // Initialize lives display
    add(livesDisplay!); // Add lives display to the game

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
    timerBar?.removeFromParent();
    timerBar = null;
  }

  bool checkAnswer(int answer) {
    if (answer == correctAnswer) {
      resetGameAfterCorrectAnswer();
      return true;
    } else {
      loseLife(); // Lose a life when the wrong answer is chosen
      return false;
    }
  }

  void loseLife() {
    lives--; // Decrement lives
    livesDisplay?.updateLives(lives); // Update the lives display
    if (lives <= 0) {
      gameOver(); // Trigger game over when lives reach 0
    } else {
      resetGameAfterIncorrectAnswer(); // Continue game after losing a life
    }
  }

  void resetGameAfterIncorrectAnswer() {
    overlays.remove('MultiplicationOverlay');
    for (final obstacle in children.whereType<Obstacle>()) {
      obstacle.speed = 200;
    }
    timerBar?.removeFromParent();
    timerBar = null;
  }

  void gameOver() {
    pauseGame();
    overlays.remove('MultiplicationOverlay');
    overlays.add('LossOverlay'); // Show the loss overlay when lives are 0
  }

  void reset() {
    overlays.remove('LossOverlay');
    isCollisionHandled = false;
    resumeGame();
    clearObstacles();
    lives = 3; // Reset lives to 3
    livesDisplay?.updateLives(lives); // Reset the lives display
    timerBar?.removeFromParent();
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

    if (timerBar == null) {
      timerBar = TimerBar(totalTime: 4);
      add(timerBar!);
    } else {
      timerBar!.resetTimer();
    }
  }

  @override
  void onRemove() {
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
