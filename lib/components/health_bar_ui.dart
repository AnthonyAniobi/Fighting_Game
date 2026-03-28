import 'dart:ui';

import 'package:fighting_game/components/fighter_component.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;

class HealthBarUi extends PositionComponent {
  final FighterComponent player;
  final double maxWidth;
  final double maxHeight;
  final Direction direction;

  HealthBarUi({
    required this.player,
    required this.maxWidth,
    this.maxHeight = 20,
    this.direction = Direction.right,
  }) : super(size: Vector2(maxWidth, maxHeight));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // health bar
    canvas.drawRect(
      Rect.fromLTWH(0, 0, maxWidth, maxHeight),
      Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.fill,
    );

    final healthPercent = player.health / GameConstants.maxLife;

    final healthColor = healthPercent > 0.5
        ? Colors.green
        : (healthPercent > 0.2 ? Colors.orange : Colors.red);

    final double healthWidth = maxWidth * healthPercent;

    canvas.drawRect(
      Rect.fromLTWH(
        direction.isRight ? (maxWidth - healthWidth) : 0,
        0,
        healthWidth,
        maxHeight,
      ),
      Paint()
        ..color = healthColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, maxWidth, maxHeight),
      Paint()
        ..color = Colors.black45
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // power up bar
    double xpHeight = maxHeight / 3;
    double xpBarWidth = maxWidth * 0.7;
    canvas.drawRect(
      Rect.fromLTWH(
        direction.isLeft ? 0 : (maxWidth - xpBarWidth),
        maxHeight + 5,
        xpBarWidth,
        xpHeight,
      ),
      Paint()
        ..color = Colors.blueGrey
        ..style = PaintingStyle.fill,
    );

    // double powerUpPercent = player.powerUpTimer / player.stats.powerUpDuration;
    // double powerUpWidth = xpBarWidth * powerUpPercent;

    // canvas.drawRect(
    //   Rect.fromLTWH(
    //     direction.isLeft ? 0 : (maxWidth - powerUpWidth),
    //     maxHeight + 5,
    //     powerUpWidth,
    //     xpHeight,
    //   ),
    //   Paint()
    //     ..color = Colors.lightGreenAccent
    //     ..style = PaintingStyle.fill,
    // );

    // canvas.drawRect(
    //   Rect.fromLTWH(
    //     direction.isLeft ? 0 : (maxWidth - xpBarWidth),
    //     maxHeight + 5,
    //     xpBarWidth,
    //     xpHeight,
    //   ),
    //   Paint()
    //     ..color = player.isPowerup ? Colors.red : Colors.black
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 2,
    // );
  }
}
