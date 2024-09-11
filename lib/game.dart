// game.dart

import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'char.dart';
import 'ground.dart';
import 'obstacle.dart';
import 'collision.dart';

class ZarbGame extends FlameGame {
  Timer? obstacleTimer;
  final Random random = Random();
  String currentProblem = "";
  List<int> answerOptions = [];
  late int correctAnswer;
  bool isCollisionHandled = false;

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
    // Spawn an obstacle immediately and then start the timer for subsequent spawns
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
    // Stop obstacle spawning when answering questions
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
    stopObstacleSpawning(); // Stop spawning new obstacles when the game is paused
  }

  void resumeGame() {
    for (final obstacle in children.whereType<Obstacle>()) {
      obstacle.speed = 200;
    }
    startObstacleSpawning(); // Restart spawning obstacles immediately when the game resumes
  }

  void resetGameAfterCorrectAnswer() {
    overlays.remove('MultiplicationOverlay');
    resumeGame();
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
  }

  void clearObstacles() {
    // Remove all Obstacle components from the game
    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });
  }

  @override
  void onRemove() {
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
