import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final GameWorld _gameWorld = GameWorld();
  GamePageState();

  @override
  initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _gameWorld.startLevel();
  }

  void _onTick(Duration elapsed) => setState(
    () => _gameWorld.update(elapsed)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SizedBox.expand(
          child: GestureDetector(
            onPanUpdate: (details) => setState(() =>
              _gameWorld.adjustPlayerPosition(details.delta.dx)
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Container(
                  width: _gameWorld.width,
                  height: _gameWorld.height,
                  color: Colors.black,
                ),
                DebugInfo(text: _gameWorld.debugText),
                for (final sprite in _gameWorld.sprites)
                SpriteWidget.fromSprite(sprite: sprite),
              ],
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
