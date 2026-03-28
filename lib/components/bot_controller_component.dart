import 'dart:math';

import 'package:fighting_game/components/player_character.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class BotControllerComponent extends Component {
  final PlayerCharacter player;
  final PlayerCharacter bot;

  BotControllerComponent({required this.player, required this.bot});

  @override
  void update(double dt) {
    super.update(dt);

    // Simple AI logic for the bot
    if (bot.playerState == CharacterState.dead ||
        player.playerState == CharacterState.dead)
      return;
    makeDescision();
  }

  void makeDescision() {
    final dx = player.position.x - bot.position.x;
    final distance = dx.abs();

    if (distance < 120 && bot.isMoving) {
      bot.moveStop();
    }

    if (bot.actionTimer > 0 && bot.playerState != CharacterState.idle) return;

    if (distance < 120) {
      bot.moveStop();
      attackOpponent();
    } else if (distance < GameConstants.screenSize.x / 2) {
      bot.moveStart(dx > 0 ? Direction.right : Direction.left);
    } else {
      if (bot.canJump) {
        bot.jump();
      } else {
        bot.moveStart(dx > 0 ? Direction.right : Direction.left);
      }
    }
  }

  void attackOpponent() {
    int random = Random().nextInt(4);
    switch (random) {
      case 0:
        bot.updateState(CharacterState.attack1);
        break;
      case 1:
        bot.updateState(CharacterState.attack2);
        break;
      case 2:
        bot.updateState(CharacterState.attack3);
        break;
      case 3:
        break;
    }
  }

  bool canPerformAction() {
    if (bot.actionTimer <= 0) {
      return true;
    } else if (bot.playerState == CharacterState.idle) {
      return true;
    }

    return false;
  }
}
