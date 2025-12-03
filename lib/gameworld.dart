import 'sprites.dart';
import 'dart:math';

enum GamePhase {title, gameOn, gameOver}

class GameConfig {
  final int maxLives;
  final double width;
  final double height;
  final double spawnInterval;
  final double enemyBulletInterval;
  final double playerBulletInterval;
  const GameConfig({
    required this.maxLives,
    required this.width,
    required this.height,
    required this.spawnInterval,
    required this.enemyBulletInterval,
    required this.playerBulletInterval,
  });
}

final gameConfig = GameConfig(
  maxLives: 5,
  width: 360,
  height: 640,
  spawnInterval: 1.5,
  enemyBulletInterval: 2,
  playerBulletInterval: 0.5,
);

// time is measured consistently in seconds, and is double
// velocity is pixel per second
// size should be adjucted to screen later;
// for now it is 360x640, fitting the safe area in old phones
class GameWorld {
  final Player _player = Player(x: 180, y: 560);
  final int _maxLives;
  final double width;
  final double height;
  final double _spawnInterval;
  final double _enemyBulletInterval;
  final double _playerBulletInterval;
  final Random r;
  GamePhase gamePhase = GamePhase.title;
  int _score = 0;
  List<Enemy> _enemies = [];
  List<EnemyBullet> _enemyBullets = [];
  List<PlayerBullet> _playerBullets = [];
  List<Sprite> sprites = [];
  double _elapsed = 0;
  String debugText = "";
  int _lives;
  double _spawnTimer;
  double _playerBulletTimer;

  GameWorld({
    required int maxLives,
    required this.width,
    required this.height,
    required double spawnInterval,
    required double enemyBulletInterval,
    required double playerBulletInterval,
    Random? random,
  }
  )
  : r = random ?? Random(),
  _maxLives = maxLives,
  _lives = maxLives,
  _spawnInterval = spawnInterval,
  _spawnTimer = spawnInterval,
  _enemyBulletInterval = enemyBulletInterval,
  _playerBulletInterval = playerBulletInterval,
  _playerBulletTimer = playerBulletInterval;

  factory GameWorld.fromConfig({
    required GameConfig config,
    Random? random,}
  ) {
    return GameWorld(
      maxLives: config.maxLives,
      width: config.width,
      height: config.height,
      spawnInterval: config.spawnInterval,
      enemyBulletInterval: config.enemyBulletInterval,
      playerBulletInterval: config.playerBulletInterval,
    );
  }

  int get lives => _lives;
  int get score => _score;

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
          _score += 10;
        }
      }
    }
    for (final b in _playerBullets) {
      for (final e in _enemies) {
        if (_collide(b, e)) {
          b.isDead = true;
          e.isDead = true;
          _score += 30;
          }
      }
    }
    for (final b in _enemyBullets) {
        if (_collide(b, _player)) {
          b.isDead = true;
          _lives = max(0, _lives-1);
          _score += 5;
        }
    }
    for (final e in _enemies) {
        if (_collide(e, _player)) {
          e.isDead = true;
          _lives = max(0, _lives-1);
          _score += 15;
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
            if (s is Enemy) {_lives = max(0, _lives-1);}
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
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnTimer = _spawnInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
      final double x = r.nextDouble() * width;
      _enemies.add(Enemy(x: x, y: 0, fireInterval: _enemyBulletInterval));
    }
  }

  void _createPlayerBullets(double dt) {
    _playerBulletTimer -= dt;
    if (_playerBulletTimer <= 0) {
      _playerBulletTimer = _playerBulletInterval * (0.9 + 0.2 * r.nextDouble()); // approx 1.5s
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
    if (_lives == 0) {
      _enemies = [];
      _enemyBullets = [];
      _playerBullets = [];
      gamePhase = GamePhase.gameOver;
    }
  }

  void reset() {
    _score = 0;
    _player.x = 180;
    _lives = _maxLives;
  }
}