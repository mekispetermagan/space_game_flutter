class GameConfig {
  final int maxLives;
  final int requiredKills;
  final double width;
  final double height;
  final double spawnInterval;
  final double enemyBulletInterval;
  final double playerBulletInterval;

  const GameConfig({
    required this.maxLives,
    required this.requiredKills,
    required this.width,
    required this.height,
    required this.spawnInterval,
    required this.enemyBulletInterval,
    required this.playerBulletInterval,
  });
}

final List<GameConfig> gameConfigs = [
  GameConfig(
    maxLives: 5,
    requiredKills: 8,
    width: 360,
    height: 640,
    spawnInterval: 3,
    enemyBulletInterval: 4,
    playerBulletInterval: 0.5,
  ),
  GameConfig(
    maxLives: 5,
    requiredKills: 10,
    width: 360,
    height: 640,
    spawnInterval: 2.2,
    enemyBulletInterval: 3,
    playerBulletInterval: 0.5,
  ),
  GameConfig(
    maxLives: 5,
    requiredKills: 12,
    width: 360,
    height: 640,
    spawnInterval: 1.5,
    enemyBulletInterval: 2,
    playerBulletInterval: 0.5,
  ),
  GameConfig(
    maxLives: 5,
    requiredKills: 14,
    width: 360,
    height: 640,
    spawnInterval: 1.2,
    enemyBulletInterval: 1.5,
    playerBulletInterval: 0.5,
  ),
  GameConfig(
    maxLives: 5,
    requiredKills: 16,
    width: 360,
    height: 640,
    spawnInterval: 1.1,
    enemyBulletInterval: 1.4,
    playerBulletInterval: 0.5,
  ),
  GameConfig(
    maxLives: 5,
    requiredKills: 18,
    width: 360,
    height: 640,
    spawnInterval: 1,
    enemyBulletInterval: 1.3,
    playerBulletInterval: 0.5,
  ),
];

