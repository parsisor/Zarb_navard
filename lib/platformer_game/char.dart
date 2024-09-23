import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class WhiteRectangle extends PositionComponent {
  final double width;   
  final double height;  
  final double leftMargin;   
  final double bottomMargin; 

  WhiteRectangle({
    this.width = 20.0,
    this.height = 40.0, 
    this.leftMargin = 20.0,
    this.bottomMargin = 50.0,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    size = Vector2(width, height);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    
    position = Vector2(leftMargin, size.y - height - bottomMargin);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = BasicPalette.white.paint();
    
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }
}
