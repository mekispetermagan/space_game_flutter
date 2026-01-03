import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// only used in debug:
// import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'statecontroller.dart';
import 'screens.dart';
import 'gameconfig.dart';
import 'gameworld.dart';

enum GamePhase {title, gameOn, levelChange, gameOver}

class ShootingApp extends StatelessWidget {
  const ShootingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GamePage(),
      theme: ThemeData.dark(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage>
  with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop)
    ..setVolume(0.4)
    ..setPlaybackRate(1.5)
    ..setSourceAsset("audio/laser_shot.wav");
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
    GamePhase _gamePhase = GamePhase.title;
  /// Level count is 0-based, but displayed as 1-based:
  /// Level 3 is displayed as level 4
  int _level = 0;
  int _highScore = 0;
  late final Ticker _ticker;
  late final GameWorld _gameWorld;
  // final _controller = StateController();

  @override
  initState() {
    super.initState();
    _gameWorld = GameWorld(
      config: gameConfigs[0],
      onLevelComplete: _onLevelComplete,
      onGameOver: _onGameOver,
      onShoot: _onShoot,
    );
    _ticker = createTicker(_onTick)
      ..start();
    _getHighScore();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _player.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_gamePhase == GamePhase.gameOn) {
      setState(() {
          _gameWorld.update(elapsed);
          _checkHighScore();
        }
      );
    }
  }

  void _onStart() => setState(
    () => _gamePhase = GamePhase.gameOn
  );

  void _onGameOver() => setState(
    () => _gamePhase = GamePhase.gameOver
  );

  void _onLevelComplete() => setState(() {
    _level += 1;
    _gamePhase = GamePhase.levelChange;
  });

  void _onLevelStart() => setState(() {
      _gameWorld.startLevel(
        gameConfigs[min(_level, gameConfigs.length-1)]
      );
      _gamePhase = GamePhase.gameOn;
    }
  );

  void _onRestart() => setState(() {
    _level = 0;
      _gameWorld.restartGame(gameConfigs[0]);
    _gamePhase = GamePhase.gameOn;
  });

  Future<void> _onShoot() async {
    await _player.seek(Duration.zero);
    _player.resume();
  }

  void _checkHighScore() {
    if (_highScore < _gameWorld.score) {
      _setHighScore(_gameWorld.score);
    }
  }

  Future<void> _getHighScore() async {
    final storedHs = await _prefs.getInt("highscore") ?? 0;
    setState(() => _highScore = storedHs);
  }

  Future<void> _setHighScore(int n) async {
    _highScore = n;
    await _prefs.setInt("highscore", _highScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final ratio = _gameWorld.width / _gameWorld.height;
            double width, height;
            if (constraints.maxWidth / ratio <  constraints.maxHeight) {
              width = constraints.maxWidth;
              height = width / ratio;
            } else {
              height = constraints.maxHeight;
              width = height * ratio;
            }
            final double zoom = width / _gameWorld.width;

            return GestureDetector(
              onPanUpdate: (details) => setState(() =>
                _gameWorld.adjustPlayerPosition(details.delta.dx)
              ),
              child: Center(
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    children: switch(_gamePhase) {
                      GamePhase.title => TitleScreen(
                        width: width,
                        height: height,
                        zoom: zoom,
                        onStart: _onStart,
                      ).content,

                      GamePhase.gameOver => GameOverScreen(
                        width: width,
                        height: height,
                        zoom: zoom,
                        score: _gameWorld.score,
                        onRestart: _onRestart,
                      ).content,

                      GamePhase.levelChange => LevelChangeScreen(
                        width: width,
                        height: height,
                        zoom: zoom,
                        level: _level+1,
                        score: _gameWorld.score,
                        onLevelStart: _onLevelStart,
                      ).content,

                      GamePhase.gameOn => GameScreen(
                        width: width,
                        height: height,
                        zoom: zoom,
                        level: _level+1,
                        lives: _gameWorld.lives,
                        kills: _gameWorld.kills,
                        requiredKills: _gameWorld.requiredKills,
                        score: _gameWorld.score,
                        highScore: _highScore,
                        sprites: _gameWorld.sprites,
                      ).content,
                    },
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

void main() {
  runApp(const ShootingApp());
}
