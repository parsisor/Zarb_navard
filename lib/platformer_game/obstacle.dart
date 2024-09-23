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
  ];
  final Random random = Random();

  Obstacle({
    required this.speed,
    required Vector2 size,
  }) : super(size: size);

  @override
  Future<void> onLoad() async {
    
    position = Vector2(random.nextDouble() * (gameRef.size.x - size.x), -size.y);
    
    
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
  }
}
