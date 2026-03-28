import 'package:fighting_game/enums/attack_type.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/enums/fighter_id.dart';
import 'package:fighting_game/enums/move_direction.dart';
import 'package:fighting_game/game/combat_game.dart';
import 'package:fighting_game/models/player_command/player_command.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

const Color _greyColor = Color(0xAAFFFFFF);
const Color _darkColor = Color(0xAA000000);
const Color _ligherDarkColor = Color(0x66000000);

class HudControls extends PositionComponent with HasGameReference<CombatGame> {
  final FighterId localFighterId;
  final CharacterType localCharacterType;
  final void Function(PlayerCommand) onCommand;

  //
  late JoystickComponent _joystick;

  HudControls({
    required this.localFighterId,
    required this.localCharacterType,
    required this.onCommand,
  }) : super(priority: 5) {
    // _joystick = joystickComponent(game.size);
  }

  @override
  Future<void> onLoad() async {
    final screenSize = game.size;

    // joystick.direction;

    // ── Left D-pad ────────────────────────────────────────────────
    addAll([
      if (localCharacterType.canJump)
        _makeRoundButton(
          sprite: 'up',
          position: Vector2(110, screenSize.y - 100),
          onDown: () => onCommand(JumpCommand(localFighterId)),
          onUp: () {},
        ),
      _makeRoundButton(
        sprite: 'left',
        position: Vector2(50, screenSize.y - 40),
        onDown: () =>
            onCommand(MoveCommand(localFighterId, MoveDirection.left)),
        onUp: () => onCommand(MoveCommand(localFighterId, MoveDirection.idle)),
      ),
      _makeRoundButton(
        sprite: 'right',
        position: Vector2(170, screenSize.y - 40),
        onDown: () =>
            onCommand(MoveCommand(localFighterId, MoveDirection.right)),
        onUp: () => onCommand(MoveCommand(localFighterId, MoveDirection.idle)),
      ),
      _makeRoundButton(
        sprite: 'sprint',
        position: Vector2(110, screenSize.y - 40),
        onDown: () => onCommand(SprintCommand(localFighterId, true)),
        onUp: () {},
      ),

      // ── Four attack buttons ────────────────────────────────────
      _makeRoundButton(
        sprite: 'attack',
        position: Vector2(screenSize.x - 40, screenSize.y - 80),
        onDown: () => onCommand(AttackCommand(localFighterId, AttackType.one)),
        onUp: () {},
      ),
      _makeRoundButton(
        sprite: 'attack',
        position: Vector2(screenSize.x - 90, screenSize.y - 120),
        onDown: () => onCommand(AttackCommand(localFighterId, AttackType.two)),
        onUp: () {},
      ),
      _makeRoundButton(
        sprite: 'attack',
        position: Vector2(screenSize.x - 140, screenSize.y - 80),
        onDown: () =>
            onCommand(AttackCommand(localFighterId, AttackType.three)),
        onUp: () {},
      ),
      _makeRoundButton(
        sprite: 'special',
        position: Vector2(screenSize.x - 90, screenSize.y - 40),
        onDown: () =>
            onCommand(AttackCommand(localFighterId, AttackType.special)),
        onUp: () {},
      ),
    ]);
  }

  HudButtonComponent _makeRoundButton({
    required String sprite,
    // required String? tapdownSprite,
    required Vector2 position,
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return HudButtonComponent(
      button: _CircleButtonSprite(sprite: sprite, pressed: false),
      buttonDown: _CircleButtonSprite(sprite: sprite, pressed: true),
      onPressed: onDown,
      onReleased: onUp,
      onCancelled: onUp,
      position: position,
      size: Vector2(50, 50),
      anchor: Anchor.center,
    );
  }

  HudButtonComponent _makeRectButton({
    required String sprite,
    // required String? tapdownSprite,
    required Vector2 position,
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return HudButtonComponent(
      button: _RoundRectButtonSprite(sprite: sprite, pressed: false),
      buttonDown: _RoundRectButtonSprite(sprite: sprite, pressed: true),
      onPressed: onDown,
      onReleased: onUp,
      position: position,
      size: Vector2(50, 50),
      anchor: Anchor.center,
    );
  }
}

// Simple painted button — replace with your sprite assets
class _CircleButtonSprite extends PositionComponent {
  final String sprite;
  final bool pressed;
  _CircleButtonSprite({required this.sprite, required this.pressed})
    : super(size: Vector2(50, 50));
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = pressed ? _greyColor : _ligherDarkColor;
    final oppositePaint = Paint()
      ..color = pressed ? _ligherDarkColor : _greyColor;
    final spritePath = 'Buttons/$sprite${pressed ? '' : '_white'}.png';

    canvas.drawCircle(Offset(25, 25), 25, paint);
    canvas.drawCircle(
      Offset(25, 25),
      25,
      oppositePaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final spriteImg = Sprite(Flame.images.fromCache(spritePath));
    spriteImg.render(
      canvas,
      size: Vector2(20, 20),
      anchor: Anchor.center,
      position: Vector2(25, 25),
    );
  }
}

// Simple painted button — replace with your sprite assets
class _RoundRectButtonSprite extends PositionComponent {
  final String sprite;
  final bool pressed;
  _RoundRectButtonSprite({required this.sprite, required this.pressed})
    : super(size: Vector2(50, 50));
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = pressed ? _greyColor : _ligherDarkColor;
    final oppositePaint = Paint()
      ..color = pressed ? _ligherDarkColor : _greyColor;
    final spritePath = 'Buttons/$sprite${pressed ? '' : '_white'}.png';

    canvas.drawCircle(Offset(25, 25), 25, paint);
    canvas.drawCircle(
      Offset(25, 25),
      25,
      oppositePaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final spriteImg = Sprite(Flame.images.fromCache(spritePath));
    spriteImg.render(
      canvas,
      size: Vector2(20, 20),
      anchor: Anchor.center,
      position: Vector2(25, 25),
    );
  }
}
