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
  final String costumePrefix;
  bool isDead = false;

  Sprite({
    required this.x,
    required this.y,
    required this.vy,
    required this.size,
    required this.costumePrefix,
  });
}

class Player extends Sprite {
  Player({
    required super.x,
    required super.y,
  })
  : super(
      size: 75,
      vy: 0,
      costumePrefix: "player",
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
      costumePrefix: "enemy",
    );
}

class PlayerBullet extends Sprite {
  PlayerBullet({
    required super.x,
    required super.y,
  })
  : super(
      size: 30,
      vy: -300,
      costumePrefix: "player_bullet",
    );
}

class EnemyBullet extends Sprite {
  EnemyBullet({
    required super.x,
    required super.y,
  })

  : super(
      size: 15,
      vy: 200,
      costumePrefix: "enemy_bullet",
    );
}

