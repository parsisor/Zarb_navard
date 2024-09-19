// game.dart

import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'char.dart';
import 'ground.dart';
import 'obstacle.dart';
import 'collision.dart';
import 'timer_bar.dart';
import 'lives_display.dart';
import 'score_display.dart';

class ZarbGame extends FlameGame {
  Timer? obstacleTimer;
  final Random random = Random();
  String currentProblem = "";
  List<int> answerOptions = [];
  late int correctAnswer;
  bool isCollisionHandled = false;
  TimerBar? timerBar;
  int lives = 3; // Initialize lives to 3
  int score = 0;
  LivesDisplay? livesDisplay; // Reference to the lives display
  ScoreDisplay? scoreDisplay; // Reference to the score display

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final player = WhiteRectangle(
      width: 60.0,
      height: 20.0,
      leftMargin: (size.x / 2) - 30.0, // Center the player horizontally
      bottomMargin: size.y - 800.0, // Position it 250px from the bottom
    );
    add(player);

    add(CollisionDetection(player));

    livesDisplay = LivesDisplay(lives: lives); // Initialize lives display
    add(livesDisplay!); // Add lives display to the game

    scoreDisplay = ScoreDisplay(); // Initialize score display
    add(scoreDisplay!); // Add score display to the game

    startObstacleSpawning();
  }

  // Update score after a correct answer
  void incrementScore() {
    scoreDisplay?.updateScore(100); // Add 100 points for each correct answer
    score++;
  }

  void resetScore() {
    scoreDisplay?.updateScore(-100 * score);
  }

  void startObstacleSpawning() {
    spawnObstacleWithRandomDelay();
  }

  void spawnObstacleWithRandomDelay() {
    int randomDelay = 500 + random.nextInt(3000);
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
  int num1, num2, additionalNum = 0;
  String operator = '+'; // Declare the operator string for '+' or '-'

  if (score * 100 < 700) {
    // Easy difficulty: Score less than 700
    num1 = random.nextInt(9) + 1; // Random number between 1 and 9
    num2 = random.nextInt(5) + 1; // Random number between 1 and 5
    correctAnswer = num1 * num2;
    currentProblem = '$num1 × $num2 = ?';
  } else if (score * 100 >= 700 && score * 100 <= 2000) {
    // Medium difficulty: Score between 700 and 2000
    num1 = random.nextInt(10) + 1; // Random number between 1 and 10
    num2 = random.nextInt(10) + 1; // Random number between 1 and 10
    correctAnswer = num1 * num2;
    currentProblem = '$num1 × $num2 = ?';
  } else {
    // Hard difficulty: Score greater than 2000
    if (random.nextBool()) {
      // Case 1: num1 is between 1 and 10, num2 is between 1 and 10 +/- random 1 to 30
      num1 = random.nextInt(10) + 1;
      num2 = random.nextInt(10) + 1;
      additionalNum = random.nextInt(30) + 1; // Random number between 1 and 30

      // Randomly decide whether to add or subtract
      if (random.nextBool()) {
        operator = '+';  // Set operator to '+'
        correctAnswer = num1 * num2 + additionalNum;
      } else {
        operator = '-';  // Set operator to '-'
        correctAnswer = num1 * num2 - additionalNum;
      }

      currentProblem = '$num1 × $num2 $operator ${additionalNum.abs()} = ?';
    } else {
      // Case 2: num1 is between 10 and 15, num2 is between 1 and 5
      num1 = random.nextInt(6) + 10; // Random number between 10 and 15
      num2 = random.nextInt(5) + 1;  // Random number between 1 and 5
      correctAnswer = num1 * num2;
      currentProblem = '$num1 × $num2 = ?';
    }
  }

  // Generate answer options
  answerOptions = [correctAnswer];
  while (answerOptions.length < 4) {
    int wrongAnswer = random.nextInt(100); // Generate a random wrong answer
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
    incrementScore(); // Increment score when the answer is correct
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
    resumeGame();
    timerBar?.removeFromParent();
    timerBar = null;
  }

  void gameOver() {
    pauseGame();
    overlays.remove('MultiplicationOverlay');
    timerBar?.removeFromParent();
    overlays.add('LossOverlay'); // Show the loss overlay when lives are 0
  }

  void reset() {
    resetScore();
    score = 0;
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
