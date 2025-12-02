import 'sprites.dart';
import 'dart:math';

// time is measured consistently in seconds, and is double
// velocity is pixel per second
// size should be adjucted to screen later;
// for now it is 360x640, fitting the safe area in old phones
class GameWorld {
  final width = 360;
  final height = 640;
  List<Sprite> sprites = [];
  double _elapsed = 0;
  double _dtUntilNextEnemy = 0;
  final Random r;
  bool isSomeoneDead = false;
  int conditioncounter = 0;
  GameWorld({
    Random? random,
  }) : r = random ?? Random();

  int get numberOfSprites => sprites.length;

  void populateWith(List<Sprite> newSprites) {
    sprites.addAll(newSprites);
  }

  void update(Duration elapsed) {
    final double e = elapsed.inMilliseconds / 1000;
    final double dt = e - _elapsed;
    _elapsed = e;
    _moveSprites(dt);
    _removeDead();
    _createEnemies(dt);
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
    _dtUntilNextEnemy -= dt;
    if (_dtUntilNextEnemy <= 0) {
      _dtUntilNextEnemy = 0.9+r.nextDouble() * 0.2; // approx 1
      final double x = r.nextDouble() * 360;
      sprites.add(Enemy(x: x, y: 0));
    }
  }

  void _removeDead() {
    sprites = [ for (final sprite in sprites) if (!isDead(sprite)) sprite ];
  }

  bool isDead(Sprite sprite) {
    for (final cond in sprite.deathConditions) {
      conditioncounter++;
      switch (cond) {
        case DeathCondition.atLowerEdge: if (640<sprite.y) {
          isSomeoneDead = true;
          return true;
        }
        case DeathCondition.atUpperEdge: if (sprite.y<60) return true;
        case DeathCondition.atCollision: if (false) return true;
      }
    }
    return false;
  }
}