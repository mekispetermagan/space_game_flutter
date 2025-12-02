import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'widgets.dart';
import 'gameworld.dart';
import 'sprites.dart';

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
  final GameWorld _gameWorld = GameWorld();
  GamePageState();

  @override
  initState() {
    super.initState();
    _gameWorld.populateWith([
      Player(x: 200, y: 600),
      Enemy(x: 100, y: 100),
      Enemy(x: 200, y: 200),
      Enemy(x: 300, y: 300),
      PlayerBullet(x: 200, y: 400),
      EnemyBullet(x: 300, y: 450),
      EnemyBullet(x: 100, y: 250),
    ]);
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) => setState(
    () => _gameWorld.update(elapsed)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: <Widget>[
              for (final sprite in _gameWorld.sprites)
              SpriteWidget.fromSprite(sprite: sprite),
              Positioned(
                left: 50,
                top: 50,
                child: Text("${_gameWorld.numberOfSprites} ${_gameWorld.isSomeoneDead} ${_gameWorld.conditioncounter}")
                ),
            ],
          ),
        ),
      ),
    );
  }
}



void main() {
  runApp(ShootingApp());
}
