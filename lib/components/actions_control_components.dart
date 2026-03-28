import 'package:fighting_game/components/player_character.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show Colors, Paint;
import 'package:flutter/painting.dart' show PaintingStyle;

class ActionsControlComponents extends PositionComponent {
  final PlayerCharacter player;

  ActionsControlComponents({required this.player})
    : super(size: Vector2(190, 130)) {
    priority = 10;
  }

  @override
  Future<void> onLoad() async {
    final action1Button = button('Buttons/attack.png', onAction1)
      ..position = Vector2(0, 40);
    final action2Button = button('Buttons/attack.png', onAction2)
      ..position = Vector2(70, 0);
    final action3Button = button('Buttons/attack.png', onAction3)
      ..position = Vector2(140, 40);
    final specialMoveButton = button('Buttons/special.png', onSpecialMove)
      ..position = Vector2(70, 80);

    add(action1Button);
    add(action2Button);
    add(action3Button);
    add(specialMoveButton);

    super.onLoad();
  }

  void onAction1() {
    player.updateState(CharacterState.attack1);
  }

  void onAction2() {
    player.updateState(CharacterState.attack2);
  }

  void onAction3() {
    player.updateState(CharacterState.attack3);
  }

  void onSpecialMove() {
    player.updateState(CharacterState.special);
  }

  PositionComponent button(String image, void Function() onPressed) {
    return ButtonComponent(
      onPressed: onPressed,
      size: Vector2(50, 50),
      button: CircleComponent(
        radius: 25,
        paint: Paint()
          ..color = Colors.black.withAlpha(200)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      ),
      children: [
        CircleComponent(
          radius: 25,
          paint: Paint()..color = Colors.black.withAlpha(80),
        ),
        SpriteComponent(
          size: Vector2(50, 50),
          position: Vector2(10, 10),
          sprite: Sprite(
            Flame.images.fromCache(image),
            srcSize: Vector2(40, 40),
          ),
        ),
      ],
    );
  }
}
