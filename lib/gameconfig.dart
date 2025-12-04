class LevelConfig {
  final int maxLives;
  final int requiredKills;
  final double width;
  final double height;
  final double spawnInterval;
  final double enemyBulletInterval;
  final double playerBulletInterval;

  const LevelConfig({
    required this.maxLives,
    required this.requiredKills,
    required this.width,
    required this.height,
    required this.spawnInterval,
    required this.enemyBulletInterval,
    required this.playerBulletInterval,
  });
}

final List<LevelConfig> gameConfigs = [
  // level 0, displayed as 1
  LevelConfig(
    maxLives: 5,
    requiredKills: 8,
    width: 360,
    height: 640,
    spawnInterval: 3,
    enemyBulletInterval: 3,
    playerBulletInterval: 0.5,
  ),
  // level 1, displayed as 2
  LevelConfig(
    maxLives: 5,
    requiredKills: 10,
    width: 360,
    height: 640,
    spawnInterval: 2.2,
    enemyBulletInterval: 2,
    playerBulletInterval: 0.5,
  ),
  // level 2, displayed as 3
  LevelConfig(
    maxLives: 5,
    requiredKills: 12,
    width: 360,
    height: 640,
    spawnInterval: 1.5,
    enemyBulletInterval: 1.7,
    playerBulletInterval: 0.5,
  ),
  // level 3, displayed as 4
  LevelConfig(
    maxLives: 5,
    requiredKills: 14,
    width: 360,
    height: 640,
    spawnInterval: 1.3,
    enemyBulletInterval: 1.6,
    playerBulletInterval: 0.5,
  ),
  // level 4, displayed as 5
  LevelConfig(
    maxLives: 5,
    requiredKills: 16,
    width: 360,
    height: 640,
    spawnInterval: 1.2,
    enemyBulletInterval: 1.5,
    playerBulletInterval: 0.5,
  ),
  // level 5, displayed as 6
  LevelConfig(
    maxLives: 5,
    requiredKills: 18,
    width: 360,
    height: 640,
    spawnInterval: 1.2,
    enemyBulletInterval: 1.4,
    playerBulletInterval: 0.5,
  ),
  // level 6, displayed as 7
  LevelConfig(
    maxLives: 5,
    requiredKills: 18,
    width: 360,
    height: 640,
    spawnInterval: 1.1,
    enemyBulletInterval: 1.4,
    playerBulletInterval: 0.5,
  ),
  // level 7, displayed as 8
  LevelConfig(
    maxLives: 5,
    requiredKills: 20,
    width: 360,
    height: 640,
    spawnInterval: 1.1,
    enemyBulletInterval: 1.3,
    playerBulletInterval: 0.5,
  ),
];

