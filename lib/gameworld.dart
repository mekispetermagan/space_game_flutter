import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:shootinggame/sprites.dart';
import 'package:shootinggame/gameconfig.dart';

/// Time is measured consistently in seconds, and is double
/// (Duration is expressed in milliseconds and divided by 1000)
/// Velocity is measured in pixel per second
/// Game area dimensions are fixed in config as 360x640.
/// They are scaled in the UI to fit the screen.
class GameWorld {
  LevelConfig config;
  final Random r;
  final Future<void> Function() onShoot;
  final VoidCallback onLevelComplete;
  final VoidCallback onGameOver;
  final double width = 360;
  final double height = 640;
  late final Player _player;
  int _score = 0;
  int _kills = 0;
  List<Enemy> _enemies = [];
  List<EnemyBullet> _enemyBullets = [];
  List<PlayerBullet> _playerBullets = [];
  /// Last frame's global time in seconds
  double _lastElapsed = 0;
  int _lives;
  double _spawnTimer;
  double _playerBulletTimer;

  GameWorld({
    required this.config,
    required this.onShoot,
    required this.onLevelComplete,
    required this.onGameOver,
    Random? random,
  }) : r = random ?? Random(),
    _lives = config.maxLives,
    _spawnTimer = config.spawnInterval * 2,
    _playerBulletTimer = config.playerBulletInterval
  {
    _player = Player(
      x: width/2,
      y: height*7/8,
    );
  }

  int get lives => _lives;
  int get score => _score;
  int get kills => _kills;
  int get requiredKills => config.requiredKills;
  List<Sprite> get sprites => [
      _player,
      ..._enemies,
      ..._enemyBullets,
      ..._playerBullets
    ];

  void restartGame(LevelConfig restartConfig) {
    _score = 0;
    startLevel(restartConfig);
  }

  // config is replaced at every new level
  void startLevel(LevelConfig newConfig) {
    config = newConfig;
    // lives are reset at every level
    _lives = config.maxLives;
    _spawnTimer = config.spawnInterval * 2;
    _playerBulletTimer = config.playerBulletInterval;
    _kills = 0;
    // player can only move horizontally
    _player.x = width / 2;
  }

  // called at every frame: holds per-frame game logic together
  void update(Duration elapsed) {
    final double e = elapsed.inMilliseconds / 1000;
    final double dt = e - _lastElapsed;
    _lastElapsed = e;
    if (dt <= 0) return;
    _moveSprites(dt);
    _checkCollisions();
    _checkEdgeCollisions();
    _clearDeadSprites();
    _createEnemies(dt);
    _createPlayerBullets(dt);
    _createEnemyBullets(dt);
    _checkLevelComplete();
    _checkGameOver();
  }

  void adjustPlayerPosition(double dx) {
    // player's center stays within game area
    _player.x = min(max(0, _player.x + dx), width);
  }

  void _moveSprites(double dt) {
    for (final sprite in sprites) {
      final double dy = sprite.vy * dt;
      sprite.y += dy;
    }
  }

  // One sprite can have multiple collisions within a single frame.
  // (Eg. a player bullet kills an enemy and an enemy bullet
  // at the same time.)
  void _checkCollisions() {
    // player bullet vs enemy bullet:
    // both die, score increases
    for (final b1 in _playerBullets) {
      for (final b2 in _enemyBullets) {
        if (_collide(b1, b2)) {
          b1.isDead = true;
          b2.isDead = true;
          _score += 10;
        }
      }
    }
    // player bullet vs enemy:
    // both die, score and kills increase
    for (final b in _playerBullets) {
      for (final e in _enemies) {
        if (_collide(b, e)) {
          b.isDead = true;
          e.isDead = true;
          _score += 30;
          _kills++;
          }
      }
    }
    // player vs enemy bullet:
    // bullet dies, score increases, player loses a life
    for (final b in _enemyBullets) {
        if (_collide(b, _player)) {
          b.isDead = true;
          _lives = max(0, _lives-1);
          _score += 5;
        }
    }
    // player vs enemy:
    // enemy dies, score increases, kills increases, player loses a life
    for (final e in _enemies) {
        if (_collide(e, _player)) {
          e.isDead = true;
          _lives = max(0, _lives-1);
          _score += 15;
          _kills++;
        }
    }
  }

  // sprite collision uses hit circles, not hitboxes
  bool _collide(Sprite s1, Sprite s2) {
    final double dx = s1.x-s2.x;
    final double dy = s1.y-s2.y;
    final double limit = s1.size/2 + s2.size/2;
    return dx*dx + dy*dy < limit * limit;
  }

  // sprites' center stays within game area
  void _checkEdgeCollisions() {
    // enemy vs lower edge: enemy dies, player loses a life
    for (final e in _enemies) {
      if (height<e.y) {
        e.isDead = true;
        _lives = max(0, _lives-1);
      }
    }
    // enemy bullet vs lower edge: bullet dies
    for (final b in _enemyBullets) {
      if (height<b.y) {
        b.isDead = true;
      }
    }
    // player bullet vs upper edge: bullet dies
    for (final b in _playerBullets) {
      if (b.y<0) {
        b.isDead = true;
      }
    }
  }

  void _clearDeadSprites() {
    _enemies = [ for (final e in _enemies) if (!e.isDead) e ];
    _enemyBullets = [ for (final b in _enemyBullets) if (!b.isDead) b ];
    _playerBullets = [ for (final b in _playerBullets) if (!b.isDead) b ];
  }

  void _createEnemies(double dt) {
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnTimer = config.spawnInterval * (0.9 + 0.2 * r.nextDouble());
      // enemy's center is within game area
      final double x = r.nextDouble() * width;
      _enemies.add(Enemy(
        x: x,
        y: 0,
        fireInterval: config.enemyBulletInterval,
      ));
    }
  }

  void _createPlayerBullets(double dt) {
    _playerBulletTimer -= dt;
    if (_playerBulletTimer <= 0) {
      _playerBulletTimer = config.playerBulletInterval * (0.9 + 0.2 * r.nextDouble());
      _playerBullets.add(PlayerBullet(
        x: _player.x,
        y: _player.y-_player.size/2,
      ));
      onShoot();
    }
  }

  void _createEnemyBullets(double dt) {
    for (final enemy in _enemies) {
        enemy.fireTimer -= dt;
      if (enemy.fireTimer <= 0) {
        enemy.fireTimer = enemy.fireInterval * (0.9 + 0.2 * r.nextDouble());
        _enemyBullets.add(EnemyBullet(
          x: enemy.x,
          y: enemy.y+enemy.size/2,
        ));
      }
    }
  }

  void _checkLevelComplete() {
    if (config.requiredKills <= _kills) {
      _clearLevelData();
      onLevelComplete();
    }
  }

  void _checkGameOver() {
    if (_lives == 0) {
      _clearLevelData();
      onGameOver();
    }
  }

  void _clearLevelData() {
    _enemies = [];
    _enemyBullets = [];
    _playerBullets = [];
  }
}