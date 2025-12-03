import 'sprites.dart';
import 'dart:math';

// time is measured consistently in seconds, and is double
// velocity is pixel per second
// size should be adjucted to screen later;
// for now it is 360x640, fitting the safe area in old phones
class GameWorld {
  final double width = 360;
  final double height = 640;
  final player = Player(x: 180, y: 560);
  List<Sprite> sprites = [];
  double _elapsed = 0;
  final double spawnInterval = 1.5;
  double spawnTimer = 1.5;
  final double enemyBulletInterval = 2;
  final double playerBulletInterval = 0.5;
  double playerBulletTimer = 0.5;
  String debugText = "";
  final Random r;
  GameWorld({
    Random? random,
  }) : r = random ?? Random();

  int get numberOfSprites => sprites.length;

  // void populateWith(List<Sprite> newSprites) {
  //   sprites.addAll(newSprites);
  // }

  void update(Duration elapsed) {
    final double e = elapsed.inMilliseconds / 1000;
    final double dt = e - _elapsed;
    _elapsed = e;
    _moveSprites(dt);
    _removeDead();
    _createEnemies(dt);
    _createPlayerBullets(dt);
    _createEnemyBullets(dt);
  }

  void startLevel() {
    sprites = [player];
  }

  void adjustPlayerPosition(double dx) {
    player.x = min(max(0, player.x + dx), width);
    debugText = "${player.x}";
  }

  void _moveSprites(double dt) {
    for (final sprite in sprites) {
      final double dx = sprite.vx * dt;
      final double dy = sprite.vy * dt;
      sprite.x += dx;
      sprite.y += dy;
    }
  }

  void _createEnemies(double dt) {
    spawnTimer -= dt;
    if (spawnTimer <= 0) {
      spawnTimer = spawnInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      final double x = r.nextDouble() * width;
      sprites.add(Enemy(x: x, y: 0, fireInterval: enemyBulletInterval));
    }
  }

  void _createPlayerBullets(double dt) {
    playerBulletTimer -= dt;
    if (playerBulletTimer <= 0) {
      playerBulletTimer = playerBulletInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      sprites.add(PlayerBullet(x: player.x, y: player.y));
    }
  }

  void _createEnemyBullets(double dt) {
    List<Sprite> newBullets = [];
    for (final sprite in sprites) {
      if (sprite is Enemy) {
        sprite.fireTimer -= dt;
    if (sprite.fireTimer <= 0) {
      sprite.fireTimer = sprite.fireInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      newBullets.add(EnemyBullet(x: sprite.x, y: sprite.y));
    }
      }
    }
    sprites.addAll(newBullets);
  }

  void _removeDead() {
    sprites = [ for (final sprite in sprites) if (!isDead(sprite)) sprite ];
  }

  bool isDead(Sprite sprite) {
    for (final cond in sprite.deathConditions) {
      switch (cond) {
        case DeathCondition.atLowerEdge: if (640<sprite.y) {
          return true;
        }
        case DeathCondition.atUpperEdge: if (sprite.y<60) return true;
        case DeathCondition.atCollision: if (false) return true;
      }
    }
    return false;
  }
}