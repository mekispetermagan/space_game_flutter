import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';
import 'widgets.dart';
import 'gameworld.dart';

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
  late final Ticker _ticker;
  final GameWorld _gameWorld = GameWorld.fromConfig(config: gameConfig);
  GamePageState();

  @override
  initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_gameWorld.gamePhase == GamePhase.gameOn) {
      setState(
        () => _gameWorld.update(elapsed)
      );
    }
  }

  void _onStart() => setState(
    () => _gameWorld.gamePhase = GamePhase.gameOn
  );

  void _onRestart() => setState(() {
    _gameWorld.reset();
    _gameWorld.gamePhase = GamePhase.gameOn;
  });

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
              color: Colors.grey[900],
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                children: switch(_gameWorld.gamePhase) {
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
                    ScoreText(
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
                  GamePhase.gameOn => <Widget>[
                    if (kDebugMode) DebugInfo(text: _gameWorld.debugText),
                    LifeDisplay(
                      x: _gameWorld.width/2,
                      y: 30,
                      lives: _gameWorld.lives,
                    ),
                    ScoreText(
                      x: _gameWorld.width-60,
                      y: 30,
                      text: "Score: ${_gameWorld.score}",
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
