import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'obstacle.dart';
import 'collision.dart';
import 'timer_bar.dart';
import 'lives_display.dart';
import 'score_display.dart';

class ScrollingBackground extends Component with HasGameRef<ZarbGame> {
  SpriteComponent bg1;
  SpriteComponent bg2;
  double speed;

  ScrollingBackground({
    required Sprite backgroundImage,
    required Vector2 size,
    this.speed = 100.0,
  })  : bg1 = SpriteComponent(sprite: backgroundImage, size: size),
        bg2 = SpriteComponent(sprite: backgroundImage, size: size) {
    bg2.position = Vector2(
        0, -size.y); 
  }

  @override
  Future<void> onLoad() async {
    add(bg1);
    add(bg2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    bg1.position.y += speed * dt;
    bg2.position.y += speed * dt;

    if (bg1.position.y >= gameRef.size.y) {
      bg1.position.y = bg2.position.y - bg1.size.y; 
    }

    if (bg2.position.y >= gameRef.size.y) {
      bg2.position.y = bg1.position.y - bg2.size.y; 
    }
  }
}

class ZarbGame extends FlameGame {
  bool shouldSpawnObstacles = true;
  Timer? obstacleTimer;
  final Random random = Random();
  String currentProblem = "";
  List<int> answerOptions = [];
  late int correctAnswer;
  bool isCollisionHandled = false;
  TimerBar? timerBar;
  int lives = 3; 
  int score = 0;
  LivesDisplay? livesDisplay; 
  ScoreDisplay? scoreDisplay; 
  double ospeed = 150;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final backgroundImage = await loadSprite('background.jpg');
    final scrollingBackground = ScrollingBackground(
      backgroundImage: backgroundImage,
      size: Vector2(size.x, size.y),
      speed: 100.0,
    );
    add(scrollingBackground);
    
    final playerImage = await loadSprite('character.png');
    final player = SpriteComponent(
      sprite: playerImage,
      size: Vector2(160.0, 160.0),
      position:
          Vector2((size.x / 2) - 100.0, size.y - 190.0), 
    );
    add(player); 

    add(CollisionDetection(player));

    livesDisplay = LivesDisplay(lives: lives);
    add(livesDisplay!);

    scoreDisplay = ScoreDisplay();
    add(scoreDisplay!);

    startObstacleSpawning();
  }

  void startObstacleSpawning() {
    shouldSpawnObstacles = true;
    spawnObstacleWithRandomDelay();
  }

  void spawnObstacleWithRandomDelay() {
    if (!shouldSpawnObstacles) return; 

    int randomDelay = 700 + random.nextInt(3000);

    Future.delayed(Duration(milliseconds: randomDelay), () {
      if (!shouldSpawnObstacles) return; 

      spawnObstacle();
      spawnObstacleWithRandomDelay(); 
    });
  }

  void spawnObstacle() {
    add(Obstacle(
      speed: ospeed, 
      size: Vector2(60.0, 60.0), 
    ));
  }

  void stopObstacleSpawning() {
    shouldSpawnObstacles = false;
  }

  @override
  void onRemove() {
    shouldSpawnObstacles = false;
    super.onRemove();
  }

  void generateNewProblem() {
    int num1, num2, additionalNum = 0;
    String operator = '+';

    if (score * 100 < 700) {
      num1 = random.nextInt(9) + 1;
      num2 = random.nextInt(5) + 1;
      correctAnswer = num1 * num2;
      currentProblem = '$num1 × $num2 = ?';
    } else if (score * 100 >= 700 && score * 100 <= 2000) {
      num1 = random.nextInt(10) + 1;
      num2 = random.nextInt(10) + 1;
      correctAnswer = num1 * num2;
      currentProblem = '$num1 × $num2 = ?';
    } else {
      if (random.nextBool()) {
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(10) + 1;
        additionalNum = random.nextInt(30) + 1;

        if (random.nextBool()) {
          operator = '+';
          correctAnswer = num1 * num2 + additionalNum;
        } else {
          operator = '-';
          correctAnswer = num1 * num2 - additionalNum;
        }

        currentProblem = '$num1 × $num2 $operator ${additionalNum.abs()} = ?';
      } else {
        num1 = random.nextInt(6) + 10;
        num2 = random.nextInt(5) + 1;
        correctAnswer = num1 * num2;
        currentProblem = '$num1 × $num2 = ?';
      }
    }

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

  void incrementScore() {
    scoreDisplay?.updateScore(100); 
    score++;
  }

  void resumeGame() {
    for (final obstacle in children.whereType<Obstacle>()) {
      obstacle.speed = ospeed;
    }
    startObstacleSpawning();
  }

  void resetGameAfterCorrectAnswer() {
    overlays.remove('MultiplicationOverlay');
    incrementScore();
    resumeGame();
    ospeed = ospeed + ospeed / 100;
    timerBar?.removeFromParent();
    timerBar = null;
  }

  bool checkAnswer(int answer) {
    if (answer == correctAnswer) {
      resetGameAfterCorrectAnswer();
      return true;
    } else {
      loseLife();
      return false;
    }
  }

  void resetScore() {
    scoreDisplay?.updateScore(-100 * score);
  }

  void loseLife() {
    lives--;
    livesDisplay?.updateLives(lives);
    if (lives <= 0) {
      gameOver();
    } else {
      resetGameAfterIncorrectAnswer();
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
    overlays.add('LossOverlay');
  }

  void reset() {
    resetScore();
    score = 0;
    overlays.remove('LossOverlay');
    isCollisionHandled = false;
    resumeGame();
    clearObstacles();
    lives = 3;
    livesDisplay?.updateLives(lives);
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
      timerBar = TimerBar(totalTime: 8);
      add(timerBar!);
    } else {
      timerBar!.resetTimer();
    }
  }
}
