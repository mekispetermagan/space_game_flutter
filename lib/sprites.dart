
abstract class Sprite {
  /// Coordinate system and bounds:
  /// - `x`/`y` are the sprite's center position in logical pixels.
  /// - A sprite is considered in-bounds as long as its center is within
  ///   the game area; it may be visually clipped at the edges.
  /// - Edge checks use the center, collision checks center and size
  double x;
  double y;
  final double vy;
  /// Logical size in pixels. Interpreted as both
  /// - the sprite’s rendered width, and
  /// - the diameter of its hit circle.
  final double size;
  final String costumePath;
  bool isDead = false;

  Sprite({
    required this.x,
    required this.y,
    required this.vy,
    required this.size,
    required this.costumePath,
  });
}

class Player extends Sprite {
  Player({
    required super.x,
    required super.y,
  })
  : super(
      size: 90,
      vy: 0,
      costumePath: "assets/images/player_bg.png",
    );
}

class Enemy extends Sprite {
  final double fireInterval;
  double fireTimer;
  Enemy({
    required super.x,
    required super.y,
    required this.fireInterval,
  })
  : fireTimer = fireInterval,
    super(
      size: 60,
      vy: 60,
      costumePath: "assets/images/enemy_bg.png",
    );
}

class PlayerBullet extends Sprite {
  PlayerBullet({
    required super.x,
    required super.y,
  })
  : super(
      size: 15,
      vy: -300,
      costumePath: "assets/images/player_bullet.png",
    );
}

class EnemyBullet extends Sprite {
  EnemyBullet({
    required super.x,
    required super.y,
  })

  : super(
      size: 6,
      vy: 200,
      costumePath: "assets/images/enemy_bullet.png",
    );
}

