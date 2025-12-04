import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'widgets.dart';
import 'gameconfig.dart';
import 'gameworld.dart';

enum GamePhase {title, gameOn, levelChange, gameOver}

class ShootingApp extends StatelessWidget {
  const ShootingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamePage(),
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
  int _level = 0;
  int _highScore = 0;
  // ignore: unused_field
  late final Ticker _ticker;
  late final GameWorld _gameWorld;
  String debugText = "";

  GamePageState();

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

  void _onLevelComplete() {
    _gameWorld.levelReset();
    _level += 1;
    _gamePhase = GamePhase.levelChange;
  }

  void _onLevelStart() => setState(() {
      _gameWorld.setConfig(
        gameConfigs[min(_level, gameConfigs.length-1)]
      );
      _gamePhase = GamePhase.gameOn;
    }
  );

  void _onRestart() => setState(() {
    _gameWorld.reset();
    _level = 0;
      _gameWorld.setConfig(gameConfigs[0]);
    _gamePhase = GamePhase.gameOn;
  });

  void _onShoot() => _player.resume();

void _checkHighScore() {
  if (_highScore < _gameWorld.score) {
    _setHighScore(_gameWorld.score);
  }
}

  Future<void> _getHighScore() async {
    _highScore = await _prefs.getInt("highscore") ?? 0;
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
        child: Center(
          child: GestureDetector(
            onPanUpdate: (details) => setState(() =>
              _gameWorld.adjustPlayerPosition(details.delta.dx)
            ),
            child: Container(
              width: _gameWorld.width,
              height: _gameWorld.height,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                children: switch(_gamePhase) {
                  GamePhase.title => [
                    TitleText(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height * 1/3,
                      text: "Space Shooter Game"
                    ),
                    PrimaryActionButton(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height * 2/3,
                      text: "Start",
                      onPressed: _onStart,
                    ),
                  ],
                  GamePhase.gameOver => [
                    TitleText(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height * 1/3,
                      text: "Game Over",
                    ),
                    HudText(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height / 2,
                      text: "Score: ${_gameWorld.score}",
                    ),
                    PrimaryActionButton(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height * 2/3,
                      text: "Restart",
                      onPressed: _onRestart,
                    ),
                  ],
                  GamePhase.levelChange => [
                    TitleText(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height * 1/3,
                      text: "Level ${_level+1}",
                    ),
                    HudText(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height / 2,
                      text: "Score: ${_gameWorld.score}",
                    ),
                    PrimaryActionButton(
                      x: _gameWorld.width / 2,
                      y: _gameWorld.height * 2/3,
                      text: "Start",
                      onPressed: _onLevelStart,
                    ),
                  ],
                  GamePhase.gameOn => <Widget>[
                    if (kDebugMode) DebugInfo(text: "level: $_level"),
                    LifeDisplay(
                      x: _gameWorld.width/2,
                      y: 30,
                      lives: _gameWorld.lives,
                    ),
                    HudText(
                      x: _gameWorld.width-60,
                      y: 30,
                      text: "Score: ${_gameWorld.score}",
                    ),
                    HudText(
                      x: 60,
                      y: 30,
                      text: "Kills: ${_gameWorld.kills}/${_gameWorld.requiredKills}",
                    ),
                    HudText(
                      x: _gameWorld.width-60,
                      y: _gameWorld.height-30,
                      text: "Level: ${_level+1}",
                    ),
                    HudText(
                      x: 75,
                      y: _gameWorld.height-30,
                      text: "High score: $_highScore",
                    ),
                    for (final sprite in _gameWorld.sprites)
                    SpriteWidget.fromSprite(sprite: sprite),
                  ]
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(ShootingApp());
}
