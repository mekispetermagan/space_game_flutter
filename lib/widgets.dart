import 'package:flutter/material.dart';
import 'sprites.dart';

class CenterPositioned extends StatelessWidget {
  final double x;
  final double y;
  final Widget child;
  const CenterPositioned({
    required this.x,
    required this.y,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: FractionalTranslation(
        translation: Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}

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
    return CenterPositioned(
      x: x,
      y: y,
      child: Image(
        width: size,
        image: AssetImage(costumePath)
        ),
    );
  }
}

class DebugInfo extends StatelessWidget {
  final String text;
  const DebugInfo({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CenterPositioned(
      x: 60,
      y: 20,
      child: Text(text)
      );
  }
}

class LifeDisplay extends StatelessWidget {
  final double x;
  final double y;
  final int lives;

  const LifeDisplay({
    required this.x,
    required this.y,
    required this.lives,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CenterPositioned(
      x: x,
      y: y,
      child: Row(
        children: List<Widget>.generate(lives, (_) => Padding(
          padding: const EdgeInsets.all(3),
          child: Image(
            width: 20,
            image: AssetImage("assets/images/player_bg.png")
          ),
        ),
        ),
      )
    );
  }
}

class TitleText extends StatelessWidget {
  final double x;
  final double y;
  final String text;
  final double? size;

  const TitleText({
    required this.x,
    required this.y,
    required this.text,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CenterPositioned(
      x: x,
      y: y,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size ?? 30,
          color: Colors.purpleAccent[100],
        ),
      ),
    );
  }
}

class ScoreText extends StatelessWidget {
  final double x;
  final double y;
  final String text;

  const ScoreText({
    required this.x,
    required this.y,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TitleText(
      x: x,
      y: y,
      text: text,
      size: 18,
    );
  }

}

class PrimaryActionButton extends StatelessWidget {
  final double x;
  final double y;
  final String text;
  final VoidCallback onPressed;

  const PrimaryActionButton({
    required this.x,
    required this.y,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CenterPositioned(
      x: x,
      y: y,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[800]),
          foregroundColor: WidgetStatePropertyAll(Colors.purple[100]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}