import 'package:flutter/material.dart';
import 'sprites.dart';

class SpriteWidget extends StatelessWidget {
  final double x;
  final double y;
  final double size;
  final String costumePath;
  const SpriteWidget({
    required this.x,
    required this.y,
    required this.size,
    required this.costumePath,
    super.key,
  });

  SpriteWidget.fromSprite({
    required Sprite sprite,
    super.key
  })
  : x = sprite.x,
    y = sprite.y,
    costumePath = sprite.costumePath,
    size = sprite.size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: FractionalTranslation(
        translation: Offset(-0.5, -0.5),
        child: Image(
          width: size,
          image: AssetImage(costumePath)
          ),
      ),
    );
  }
}