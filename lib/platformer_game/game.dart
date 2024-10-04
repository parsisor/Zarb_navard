import 'dart:async';
import 'dart:math';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'collision.dart'; // Your custom collision detection
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'obstacle.dart';
import 'timer_bar.dart';
import 'lives_display.dart';
import 'score_display.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:zarb_navard_game/hub/home1.dart';
import 'player.dart'; // Import your new player class


class ScrollingBackground extends Component with HasGameRef<ZarbGame> {
  SpriteComponent bg1;
  SpriteComponent bg2;
  List<Sprite> backgrounds;
  int currentBackgroundIndex = 0;
  double speed;
  

  ScrollingBackground({
    required this.backgrounds, // Accept multiple backgrounds
    required Vector2 size,
    this.speed = 100.0,
  })  : bg1 = SpriteComponent(sprite: backgrounds[0], size: size),
        bg2 = SpriteComponent(sprite: backgrounds[0], size: size) {
    bg2.position = Vector2(0, -size.y);
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

  void changeBackground(int index) {
    currentBackgroundIndex = index;
    bg1.sprite = backgrounds[index];
    bg2.sprite = backgrounds[index];
  }
}


class ZarbGame extends FlameGame with PanDetector {
  
  Player? player; // Change this to use Player
  Vector2 playerPosition = Vector2(100, 100); // Initialize player position
  bool isGameInitialized = false;
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
  ScrollingBackground? scrollingBackground;
  LivesDisplay? livesDisplay;
  ScoreDisplay? scoreDisplay;
  double ospeed = 150;
  Timer? messageDisplayTimer;
  late TextComponent levelMessage;

  @override
  Future<void> onLoad() async {
    super.onLoad();


    final background1 = await loadSprite('background.jpg');
    final background2 = await loadSprite('background2.jpg');
    final background3 = await loadSprite('background3.jpg');

    scrollingBackground = ScrollingBackground(
      backgrounds: [background1, background2, background3],
      size: Vector2(size.x, size.y),
      speed: 100.0,
    );
    add(scrollingBackground!);

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('Juhani Junkala [Retro Game Music Pack] Level 1.wav',
        volume: 0.5);

    final playerImage = await loadSprite('character.png');
    player = Player(
      sprite: playerImage,
      position:
          Vector2((size.x - 160.0) / 2, size.y / 2 + 200), // Centered on x-axis
    );

    add(player!);

    add(CustomCollisionDetection(player!));

    levelMessage = TextComponent(
      text: '', // Start with empty text
      position: Vector2(size.x / 2 - 100, 50), // Set position
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 36,
          color: Colors.white,
        ),
      ),
    );

    add(levelMessage); // Add to the game component tree

    // Adjust properties
    levelMessage.priority = 1; // Ensure it renders above other components
    levelMessage.scale = Vector2.zero(); // Initially hide it by scaling to zero

    livesDisplay = LivesDisplay(lives: lives);
    add(livesDisplay!);

    scoreDisplay = ScoreDisplay();
    add(scoreDisplay!);

    startObstacleSpawning();

    isGameInitialized = true;

    showMessage("مرحله اول");
  }

  void showMessage(String message) {
    levelMessage.text = message;
    levelMessage.scale =
        Vector2.all(1.0); // Show the message by scaling to full size

    // Center the message on the x-axis based on its width
    levelMessage.position.x = (size.x - levelMessage.size.x) / 2;

    // Hide the message after 2 seconds
    messageDisplayTimer?.stop();
    messageDisplayTimer = Timer(2.0, onTick: () {
      levelMessage.scale =
          Vector2.zero(); // Hide the message by scaling to zero
    });
    messageDisplayTimer?.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    messageDisplayTimer?.update(dt);

    // Display messages based on score
    if (score == 15) {
      showMessage("مرحله دوم");
      scrollingBackground?.changeBackground(1); // Switch to background2.jpg
    } else if (score == 35) {
      showMessage("مرحله سوم");
      scrollingBackground?.changeBackground(2); // Switch to background3.jpg
    }
    // Add more
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (player != null) {
      player!.position.add(info.delta.global);
    }
  }

  void startObstacleSpawning() {
    shouldSpawnObstacles = true;
    spawnObstacleWithRandomDelay();
  }

  void spawnObstacleWithRandomDelay() {
    if (!shouldSpawnObstacles) return;

    int randomDelay = 700 + random.nextInt(2000);

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

    if (score * 100 < 1500) {
      num1 = random.nextInt(9) + 1;
      num2 = random.nextInt(5) + 1;
      correctAnswer = num1 * num2;
      currentProblem = '$num1 × $num2 = ?';
    } else if (score * 100 >= 1500 && score * 100 <= 3500) {
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
          // Ensure the multiplication result is greater than or equal to additionalNum
          while (num1 * num2 < additionalNum) {
            num1 = random.nextInt(10) + 1;
            num2 = random.nextInt(10) + 1;
          }
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

  void stopMusicAndNavigate() {
    FlameAudio.bgm.stop(); // Stop the background music
    // Navigate back to HomeScreen
    // Assuming you have a BuildContext available
    // You might want to use a global key or a method to access the context
    Navigator.of(gameRef.context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Widget buildBackButton() {
    return Positioned(
      top: 20,
      left: 20,
      child: FloatingActionButton(
        onPressed: stopMusicAndNavigate,
        child: Icon(Icons.arrow_back),
      ),
    );
  }

  void handleCollision(Obstacle obstacle) {
    if (obstacle.obstacleType == 'meteor_1.png') {
      // Player loses a life if hit by a meteor
      loseLife();
      obstacle.removeFromParent(); // Remove the obstacle after the collision
    } else if(obstacle.obstacleType == 'planet_Dx.png' || obstacle.obstacleType == 'planet_D_2x.png' || obstacle.obstacleType == 'planet_D_3x.png' || obstacle.obstacleType == 'planet_D_4x.png') {
      isCollisionHandled = true;
      obstacle.removeFromParent(); // Remove the obstacle after the collision
      overlays.remove('MultiplicationOverlay');
      generateNewProblem();
      overlays.add('MultiplicationOverlay');

      if (timerBar == null && ( score * 100 <= 3500)) {
        timerBar = TimerBar(totalTime: 8);
        add(timerBar!);
      }else if(timerBar == null && (score * 100 >= 3500))
      {
        timerBar = TimerBar(totalTime: 12);
        add(timerBar!);
      } 
      
      else {
        timerBar!.resetTimer();
      }
    }
  }
}
