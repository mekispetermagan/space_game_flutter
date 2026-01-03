class LevelConfig {
  final int maxLives;
  final int requiredKills;
  /// All interval fields are in seconds
  final double spawnInterval;
  final double enemyBulletInterval;
  final double playerBulletInterval;

  const LevelConfig({
    required this.maxLives,
    required this.requiredKills,
    required this.spawnInterval,
    required this.enemyBulletInterval,
    required this.playerBulletInterval,
  });
}

final List<LevelConfig> gameConfigs = [
  const LevelConfig(
    maxLives: 5,
    requiredKills: 8,
    spawnInterval: 3,
    enemyBulletInterval: 3,
    playerBulletInterval: 0.5,
  ),
  LevelConfig(
    maxLives: 5,
    requiredKills: 10,
    spawnInterval: 2.2,
    enemyBulletInterval: 2,
    playerBulletInterval: 0.5,
  ),
  const LevelConfig(
    maxLives: 5,
    requiredKills: 12,
    spawnInterval: 1.5,
    enemyBulletInterval: 1.7,
    playerBulletInterval: 0.5,
  ),
  const LevelConfig(
    maxLives: 5,
    requiredKills: 14,
    spawnInterval: 1.3,
    enemyBulletInterval: 1.6,
    playerBulletInterval: 0.5,
  ),
  const LevelConfig(
    maxLives: 5,
    requiredKills: 16,
    spawnInterval: 1.2,
    enemyBulletInterval: 1.5,
    playerBulletInterval: 0.5,
  ),
  const LevelConfig(
    maxLives: 5,
    requiredKills: 18,
    spawnInterval: 1.2,
    enemyBulletInterval: 1.4,
    playerBulletInterval: 0.5,
  ),
  const LevelConfig(
    maxLives: 5,
    requiredKills: 18,
    spawnInterval: 1.1,
    enemyBulletInterval: 1.4,
    playerBulletInterval: 0.5,
  ),
  const LevelConfig(
    maxLives: 5,
    requiredKills: 20,
    spawnInterval: 1.1,
    enemyBulletInterval: 1.3,
    playerBulletInterval: 0.5,
  ),
];

