import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Obstacle extends SpriteComponent with HasGameRef {
  double speed;
  static final List<String> obstacleAssets = [
    'meteor_1.png',
    'planet_D.png',
    'planet_D_2.png',
    'planet_D_3.png',
    'planet_D_4.png',
    'planet_Dx.png',
    'planet_D_2x.png',
    'planet_D_3x.png',
    'planet_D_4x.png',
  ];
  final Random random = Random();
  late String obstacleType;

  Obstacle({
    required this.speed,
    required Vector2 size,
  }) : super(size: size);

  @override
  Future<void> onLoad() async {
    position =
        Vector2(random.nextDouble() * (gameRef.size.x - size.x), -size.y / 2);
    
    await _chooseRandomSprite();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  Future<void> _chooseRandomSprite() async {
    String chosenAsset = obstacleAssets[random.nextInt(obstacleAssets.length)];
    sprite = await gameRef.loadSprite(chosenAsset);
    obstacleType = chosenAsset; // Track which obstacle type it is
  }
}
