import 'package:fighting_game/enums/attack_type.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/enums/fighter_id.dart';
import 'package:fighting_game/enums/move_direction.dart';
import 'package:flame/components.dart';

/// Every possible action in the fight — from either local or remote input
sealed class PlayerCommand {
  final FighterId target;
  const PlayerCommand(this.target);
}

class MoveCommand extends PlayerCommand {
  final MoveDirection direction;
  const MoveCommand(super.target, this.direction);
}

class SprintCommand extends PlayerCommand {
  final bool active;
  const SprintCommand(super.target, this.active);
}

class JumpCommand extends PlayerCommand {
  const JumpCommand(super.target);
}

class AttackCommand extends PlayerCommand {
  final AttackType type;
  const AttackCommand(super.target, this.type);
}

class TakeDamageCommand extends PlayerCommand {
  final double amount;
  final AttackType source;
  const TakeDamageCommand(super.target, this.amount, this.source);
}
