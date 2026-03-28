import 'dart:ui';

import 'package:fighting_game/components/charachter_sprite_animations.dart'
    show frames;
import 'package:fighting_game/enums/character_state.dart' show CharacterState;
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/game/select_player_scene.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' show Colors;

class PlayerSelectTile extends PositionComponent
    with TapCallbacks, HasGameReference<SelectPlayerScene> {
  final CharacterType characterType;

  PlayerSelectTile({required this.characterType, super.position, super.size});

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // render the character sprite for selection

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.x, size.y),
        Radius.circular(8),
      ),
      Paint()
        ..color = const Color(0xFFFFFFFF).withAlpha(isSelected ? 200 : 100),
    );

    final frame = frames(characterType, CharacterState.idle)[0];
    final sprite = Sprite(
      Flame.images.fromCache('${characterType.spritePath}/Idle.png'),
      srcPosition: Vector2(frame.x, frame.y),
      srcSize: Vector2(frame.width, frame.height),
    );

    sprite.render(
      canvas,
      size: Vector2(frame.width, frame.height),
      position: Vector2((size.x - frame.width) / 2, size.y - 5),
      anchor: Anchor.bottomLeft,
    );
    if (isSelected) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(0, 0, size.x, size.y),
          Radius.circular(8),
        ),
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
      );
    }

    if (temporalSelection) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(0, 0, size.x, size.y),
          Radius.circular(8),
        ),
        Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.selectCharacter(characterType);
  }

  bool get isSelected {
    return game.player1Character == characterType ||
        game.player2Character == characterType;
  }

  bool get temporalSelection {
    return game.selectedCharacter == characterType;
  }
}
