import 'package:flutter/material.dart';
import 'package:shootinggame/sprites.dart';

// cute: emojis
// space: Star Wars
enum GameTheme { cute, space }

/// Positions [child] so that (x, y) is its visual center in the parent's Stack.
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
    required double x,
    required double y,
    required double size,
    required double zoom,
    required this.costumePath,
    super.key,
  })
  : x = x * zoom,
    y = y * zoom,
    size = size * zoom;

  SpriteWidget.fromSprite({
    required Sprite sprite,
    required double zoom,
    required GameTheme theme,
    Key? key,
  })
  : this(
      x: sprite.x,
      y: sprite.y,
      costumePath: switch(theme) {
        GameTheme.cute => "assets/images/${sprite.costumePrefix}_cute.png",
        GameTheme.space => "assets/images/${sprite.costumePrefix}_space.png",
      },
      size: sprite.size,
      zoom: zoom,
      key: key,
    );

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

/// The display only works with up to five lives;
/// beyond that hud elements will overlap.
class LifeDisplay extends StatelessWidget {
  final double x;
  final double y;
  final double size;
  final int lives;
  final String path;

  LifeDisplay({
    required this.x,
    required this.y,
    required double zoom,
    required this.lives,
    required GameTheme theme,
    super.key,
  })
  : size = 20 * zoom,
    path = switch(theme) {
        GameTheme.cute => "assets/images/player_cute.png",
        GameTheme.space => "assets/images/player_space.png",
      };

  @override
  Widget build(BuildContext context) {
    return CenterPositioned(
      x: x,
      y: y,
      child: Row(
        children: List<Widget>.generate(lives, (_) => Padding(
          padding: const EdgeInsets.all(3),
          child: Image(
            width: size,
            image: AssetImage(path),
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
  final double size;

  const TitleText({
    required this.x,
    required this.y,
    required double zoom,
    required this.text,
    double? size,
    super.key,
  })
  : size = (size ?? 30) * zoom;

  @override
  Widget build(BuildContext context) {
    return CenterPositioned(
      x: x,
      y: y,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: Colors.pink[200],
        ),
      ),
    );
  }
}

class HudText extends StatelessWidget {
  final double x;
  final double y;
  final double zoom;
  final String text;

  const HudText({
    required this.x,
    required this.y,
    required this.zoom,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TitleText(
      x: x,
      y: y,
      zoom: zoom,
      text: text,
      size: 18,
    );
  }

}

class PrimaryActionButton extends StatelessWidget {
  final double x;
  final double y;
  final double fontSize;
  final double padding;
  final String text;
  final VoidCallback onPressed;

  const PrimaryActionButton({
    required this.x,
    required this.y,
    required double zoom,
    required this.text,
    required this.onPressed,
    super.key,
  })
  : fontSize = 24 * zoom,
    padding = 12 * zoom;

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
          padding: EdgeInsets.all(padding),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}