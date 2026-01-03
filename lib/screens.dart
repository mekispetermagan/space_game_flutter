import 'package:flutter/material.dart';
import 'widgets.dart';
import 'sprites.dart';

class TitleScreen {
  List<Widget> content;
  TitleScreen({
    required double width,
    required double height,
    required double zoom,
    required VoidCallback onStart,
  }) : content = [
    TitleText(
      x: width / 2,
      y: height * 1/3,
      zoom: zoom,
      text: "Space Shooter Game"
    ),
    PrimaryActionButton(
      x: width / 2,
      y: height * 2/3,
      zoom: zoom,
      text: "Start",
      onPressed: onStart,
    ),
  ];
}

class GameOverScreen {
  List<Widget> content;
  GameOverScreen({
    required double width,
    required double height,
    required double zoom,
    required int score,
    required VoidCallback onRestart,
  }) : content = [
    TitleText(
      x: width / 2,
      y: height * 1/3,
      zoom: zoom,
      text: "Game Over",
    ),
    HudText(
      x: width / 2,
      y: height / 2,
      zoom: zoom,
      text: "Score: $score",
    ),
    PrimaryActionButton(
      x: width / 2,
      y: height * 2/3,
      zoom: zoom,
      text: "Restart",
      onPressed: onRestart,
    ),
  ];
}

class LevelChangeScreen {
  List<Widget> content;
  LevelChangeScreen({
    required double width,
    required double height,
    required double zoom,
    required int level,
    required int score,
    required VoidCallback onLevelStart,
  }) : content = [
    TitleText(
      x: width / 2,
      y: height * 1/3,
      zoom: zoom,
      text: "Level $level",
    ),
    HudText(
      x: width / 2,
      y: height / 2,
      zoom: zoom,
      text: "Score: $score",
    ),
    PrimaryActionButton(
      x: width / 2,
      y: height * 2/3,
      zoom: zoom,
      text: "Start",
      onPressed: onLevelStart,
    ),
  ];
}

class GameScreen {
  List<Widget> content;
  GameScreen({
    required double width,
    required double height,
    required double zoom,
    required int level,
    required int lives,
    required int kills,
    required int requiredKills,
    required int score,
    required int highScore,
    required List<Sprite> sprites,
  }) : content = [
    LifeDisplay(
      x: width/2,
      y: 30,
      zoom: zoom,
      lives: lives,
    ),
    HudText(
      x: width-60,
      y: 30,
      zoom: zoom,
      text: "Score: $score",
    ),
    HudText(
      x: 60 * zoom,
      y: 30 * zoom,
      zoom: zoom,
      text: "Kills: $kills/$requiredKills",
    ),
    HudText(
      x: width - 60 * zoom,
      y: height - 30 * zoom,
      zoom: zoom,
      text: "Level: $level",
    ),
    HudText(
      x: 75 * zoom,
      y: height - 30 * zoom,
      zoom: zoom,
      text: "High score: $highScore",
    ),
    for (final sprite in sprites)
    SpriteWidget.fromSprite(
      sprite: sprite,
      zoom: zoom,
      ),
  ];
}
