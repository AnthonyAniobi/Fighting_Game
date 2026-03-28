// ignore_for_file: library_private_types_in_public_api
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:flame/components.dart';

part 'player_config_part.dart';

class PlayerConfig {
  final _PlayerStateData idle;
  final _PlayerStateData walk;
  final _PlayerStateData jump;
  final _PlayerStateData attack1;
  final _PlayerStateData attack2;
  final _PlayerStateData attack3;
  final _PlayerStateData special;
  final _PlayerStateData hurt;
  final _PlayerStateData dead;
  final _PlayerStateData run;
  final _PositionSize healthBox;
  final _PositionSize contentBox;
  final _PositionSize attack1HitBox;
  final _PositionSize attack2HitBox;
  final _PositionSize attack3HitBox;
  final double flipOffset;
  final _JumpInterval jumpInterval;
  final int attack1Frame;
  final int attack2Frame;
  final int attack3Frame;
  final int specialAttackFrame;
  final Vector2 spriteSize;

  PlayerConfig({
    required this.idle,
    required this.walk,
    required this.jump,
    required this.attack1,
    required this.attack2,
    required this.attack3,
    required this.special,
    required this.hurt,
    required this.dead,
    required this.run,
    required this.healthBox,
    required this.contentBox,
    required this.attack1HitBox,
    required this.attack2HitBox,
    required this.attack3HitBox,
    required this.flipOffset,
    required this.jumpInterval,
    required this.attack1Frame,
    required this.attack2Frame,
    required this.attack3Frame,
    required this.specialAttackFrame,
    required this.spriteSize,
  });

  factory PlayerConfig.fromType(CharacterType character) {
    return switch (character) {
      CharacterType.fireWizard => _fireWizard,
      CharacterType.lightningWizard => _lightningWizard,
      CharacterType.wandererMagician => _wandererMagician,
      CharacterType.knight1 => _knight1,
      CharacterType.knight2 => _knight2,
      CharacterType.knight3 => _knight3,
      CharacterType.skeletonWarrior => _skeletonWarrior,
      CharacterType.skeletonArcher => _skeletonArcher,
      CharacterType.skeletonSpearman => _skeletonSpearman,
      CharacterType.samurai => _samurai,
      CharacterType.samuraiArcher => _samuraiArcher,
      CharacterType.samuraiCommander => _samuraiCommander,
    };
  }

  _PlayerStateData stateData(CharacterState state) {
    return switch (state) {
      CharacterState.idle => idle,
      CharacterState.walk => walk,
      CharacterState.jump => jump,
      CharacterState.attack1 => attack1,
      CharacterState.attack2 => attack2,
      CharacterState.attack3 => attack3,
      CharacterState.special => special,
      CharacterState.hurt => hurt,
      CharacterState.dead => dead,
      CharacterState.run => run,
    };
  }

  double stateTime(CharacterState state) {
    final data = stateData(state);
    return data.time * data.spriteCount;
  }

  int attackFrame(CharacterState state) => switch (state) {
    CharacterState.attack1 => attack1Frame,
    CharacterState.attack2 => attack2Frame,
    CharacterState.attack3 => attack3Frame,
    CharacterState.special => specialAttackFrame,
    _ => 0,
  };

  _PositionSize getAttackBox(CharacterState state) => switch (state) {
    CharacterState.attack1 => attack1HitBox,
    CharacterState.attack2 => attack2HitBox,
    CharacterState.attack3 => attack3HitBox,
    _ => _PositionSize.zero(),
  };
}

class _PositionSize {
  final double x;
  final double y;
  final double width;
  final double height;

  _PositionSize(this.x, this.y, this.width, this.height);
  factory _PositionSize.zero() => _PositionSize(0, 0, 0, 0);
}

class _PlayerStateData {
  final int spriteCount;
  final double time;
  _PlayerStateData(this.spriteCount, this.time);
}

class _JumpInterval {
  final int startFrame;
  final int midAirFrames;
  _JumpInterval(this.startFrame, this.midAirFrames);

  factory _JumpInterval.none() => _JumpInterval(0, 0);
}
