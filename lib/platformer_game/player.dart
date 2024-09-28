import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class Player extends SpriteComponent {
  Player({
    required Sprite sprite,
    required Vector2 position,
  }) : super(sprite: sprite, size: Vector2(160, 160), position: position);

  @override
  Rect toRect() {
    // Adjust the hitbox to match the sprite's size and visible area
    // The hitbox can be a little smaller or larger depending on how precise it needs to be.
    
    final double hitboxPadding = 20.0; // Reduce or adjust this for more precision
    return Rect.fromLTWH(
      position.x + hitboxPadding / 2, // Adjust position to center the hitbox
      position.y + hitboxPadding / 2,
      size.x - hitboxPadding, // Subtract padding from width
      size.y - hitboxPadding, // Subtract padding from height
    );
  }
}
