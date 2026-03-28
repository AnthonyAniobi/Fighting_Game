import 'package:fighting_game/components/player_character.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show Colors, Paint;
import 'package:flutter/painting.dart' show PaintingStyle;

class MovementControlComponents extends PositionComponent {
  final PlayerCharacter player;

  late final PositionComponent sprintButton;

  MovementControlComponents({required this.player})
    : super(size: Vector2(210, 130)) {
    priority = 10;
  }
  @override
  Future<void> onLoad() async {
    final jumpButton = button(image: 'Buttons/up.png', onPressed: jump)
      ..position = Vector2(70, 0);
    final moveLeftButton = button(
      image: 'Buttons/left.png',
      onPressed: () => moveStart(Direction.left),
      onReleased: moveStop,
      onCancel: moveStop,
    )..position = Vector2(0, 65);
    sprintButton = button(image: 'Buttons/sprint.png', onPressed: sprint)
      ..position = Vector2(70, 65);
    final moveRightButton = button(
      image: 'Buttons/right.png',
      onPressed: () => moveStart(Direction.right),
      onReleased: moveStop,
      onCancel: moveStop,
    )..position = Vector2(140, 65);

    add(jumpButton);
    add(moveLeftButton);
    add(moveRightButton);
    add(sprintButton);

    super.onLoad();
  }

  void moveStart(Direction direction) {
    player.moveStart(direction);
  }

  void moveStop() {
    player.moveStop();
  }

  void jump() {
    player.jump();
  }

  void sprint() {
    player.sprint();
  }

  PositionComponent button({
    required String image,
    void Function()? onPressed,
    void Function()? onReleased,
    void Function()? onCancel,
  }) {
    return ButtonComponent(
      onPressed: onPressed,
      onReleased: onReleased,
      onCancelled: onCancel,
      size: Vector2(50, 50),
      button: RectangleComponent(
        size: Vector2(50, 50),
        paint: Paint()
          ..color = Colors.black.withAlpha(200)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      ),
      children: [
        RectangleComponent(
          size: Vector2(50, 50),
          paint: Paint()..color = Colors.black.withAlpha(80),
        ),
        SpriteComponent(
          size: Vector2(50, 50),
          position: Vector2(15, 15),
          sprite: Sprite(
            Flame.images.fromCache(image),
            srcSize: Vector2(40, 40),
          ),
        ),
      ],
    );
  }
}
