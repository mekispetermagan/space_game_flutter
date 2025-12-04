
enum DeathCondition {atLowerEdge, atUpperEdge}

class Sprite {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  bool isDead = false;
  Set<DeathCondition> deathConditions;
  final String costumePath;

  Sprite({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.costumePath,
    required this.deathConditions,
  });
}

class Player extends Sprite {
  Player({
    required super.x,
    required super.y,
  }) : super(
    size: 90,
    vx: 0,
    vy: 0,
    costumePath: "assets/images/player_bg.png",
    deathConditions: {},
  );
}

class Enemy extends Sprite {
  final double fireInterval;
  double fireTimer;
  Enemy({
    required super.x,
    required super.y,
    required this.fireInterval,
  }) : fireTimer = fireInterval,
    super(
      size: 60,
      vx: 0,
      vy: 60,
      costumePath: "assets/images/enemy_bg.png",
      deathConditions: {DeathCondition.atLowerEdge},
    );
  }

class PlayerBullet extends Sprite {
  PlayerBullet({
    required super.x,
    required super.y,
  }) : super(
    size: 15,
    vx: 0,
    vy: -300,
    costumePath: "assets/images/player_bullet.png",
    deathConditions: {DeathCondition.atUpperEdge},
  );
}

class EnemyBullet extends Sprite {
  EnemyBullet({
    required super.x,
    required super.y,
  }) : super(
    size: 6,
    vx: 0,
    vy: 200,
    costumePath: "assets/images/enemy_bullet.png",
    deathConditions: {DeathCondition.atLowerEdge},
  );
}

