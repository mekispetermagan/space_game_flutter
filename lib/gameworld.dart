import 'sprites.dart';
import 'dart:math';

enum GamePhase {title, gameOn, gameOver}

// time is measured consistently in seconds, and is double
// velocity is pixel per second
// size should be adjucted to screen later;
// for now it is 360x640, fitting the safe area in old phones
class GameWorld {
  GamePhase gamePhase = GamePhase.title;
  final double width = 360;
  final double height = 640;
  final Player _player = Player(x: 180, y: 560);
  List<Enemy> _enemies = [];
  List<EnemyBullet> _enemyBullets = [];
  List<PlayerBullet> _playerBullets = [];
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

  int get playerLives => _player.lives;

  void update(Duration elapsed) {
    sprites = [_player, ..._enemies, ..._enemyBullets, ..._playerBullets];
    final double e = elapsed.inMilliseconds / 1000;
    final double dt = e - _elapsed;
    _elapsed = e;
    _moveSprites(dt);
    _checkCollisions();
    _checkDeathConditions();
    _removeDead();
    _createEnemies(dt);
    _createPlayerBullets(dt);
    _createEnemyBullets(dt);
    _checkGameOver();
  }

  void adjustPlayerPosition(double dx) {
    _player.x = min(max(0, _player.x + dx), width);
    debugText = "${_player.x}";
  }

  void _moveSprites(double dt) {
    for (final sprite in sprites) {
      final double dx = sprite.vx * dt;
      final double dy = sprite.vy * dt;
      sprite.x += dx;
      sprite.y += dy;
    }
  }

  void _checkCollisions() {
    for (final b1 in _playerBullets) {
      for (final b2 in _enemyBullets) {
        if (_collide(b1, b2)) {
          b1.isDead = true;
          b2.isDead = true;
          }
      }
    }
    for (final b in _playerBullets) {
      for (final e in _enemies) {
        if (_collide(b, e)) {
          b.isDead = true;
          e.isDead = true;
          }
      }
    }
    for (final b in _enemyBullets) {
        if (_collide(b, _player)) {
          b.isDead = true;
          _player.lives = max(0, _player.lives-1);
        }
    }
    for (final e in _enemies) {
        if (_collide(e, _player)) {
          e.isDead = true;
          _player.lives = max(0, _player.lives-1);
        }
    }
  }

  bool _collide(Sprite s1, Sprite s2) {
    final double dx = s1.x-s2.x;
    final double dy = s1.y-s2.y;
    final double limit = s1.size/2 + s2.size/2;
    return dx*dx + dy*dy < limit * limit;
  }

  void _checkDeathConditions() {
    for (final s in sprites) {
      for (final cond in s.deathConditions) {
        switch (cond) {
          case DeathCondition.atLowerEdge: if (height<s.y) {
            s.isDead = true;
          }
          case DeathCondition.atUpperEdge: if (s.y<0) {
            s.isDead = true;
          }
        }
      }
    }
  }

  void _removeDead() {
    _enemies = [ for (final e in _enemies) if (!e.isDead) e ];
    _enemyBullets = [ for (final b in _enemyBullets) if (!b.isDead) b ];
    _playerBullets = [ for (final b in _playerBullets) if (!b.isDead) b ];
  }


  void _createEnemies(double dt) {
    spawnTimer -= dt;
    if (spawnTimer <= 0) {
      spawnTimer = spawnInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      final double x = r.nextDouble() * width;
      _enemies.add(Enemy(x: x, y: 0, fireInterval: enemyBulletInterval));
    }
  }

  void _createPlayerBullets(double dt) {
    playerBulletTimer -= dt;
    if (playerBulletTimer <= 0) {
      playerBulletTimer = playerBulletInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      _playerBullets.add(PlayerBullet(x: _player.x, y: _player.y-_player.size/2));
    }
  }

  void _createEnemyBullets(double dt) {
    List<Sprite> newBullets = [];
    for (final enemy in _enemies) {
        enemy.fireTimer -= dt;
    if (enemy.fireTimer <= 0) {
      enemy.fireTimer = enemy.fireInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      _enemyBullets.add(EnemyBullet(x: enemy.x, y: enemy.y+enemy.size/2));
    }
      }
    sprites.addAll(newBullets);
  }

  void _checkGameOver() {
    if (_player.lives == 0) {
      _enemies = [];
      _enemyBullets = [];
      _playerBullets = [];
      gamePhase = GamePhase.gameOver;
    }
  }

  void reset() {
    _player.x = 180;
    _player.lives = 5;
  }
}