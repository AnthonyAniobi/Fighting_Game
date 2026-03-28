import 'package:fighting_game/enums/attack_type.dart';

enum CharacterState {
  idle,
  walk,
  jump,
  attack1,
  attack2,
  attack3,
  special,
  hurt,
  dead,
  run;

  String get spritePath => switch (this) {
    idle => 'Idle.png',
    walk => 'Walk.png',
    jump => 'Jump.png',
    attack1 => 'Attack_1.png',
    attack2 => 'Attack_2.png',
    attack3 => 'Attack_3.png',
    special => 'Special.png',
    hurt => 'Hurt.png',
    dead => 'Dead.png',
    run => 'Run.png',
  };

  bool get isAttacking => switch (this) {
    attack1 || attack2 || attack3 || special => true,
    _ => false,
  };

  static bool isAttackState(CharacterState state) => switch (state) {
    attack1 || attack2 || attack3 || special => true,
    _ => false,
  };

  bool get isDead => this == CharacterState.dead;
  bool get isHurt => this == CharacterState.hurt;
  bool get isJump => this == CharacterState.jump;
  bool get isSpecial => this == CharacterState.special;
  bool get isMoving =>
      this == CharacterState.walk || this == CharacterState.run;

  String get id => switch (this) {
    idle => 'idle',
    walk => 'walk',
    jump => 'jump',
    attack1 => 'attack1',
    attack2 => 'attack2',
    attack3 => 'attack3',
    special => 'special',
    hurt => 'hurt',
    dead => 'dead',
    run => 'run',
  };

  static CharacterState fromString(String state) => switch (state) {
    'idle' => CharacterState.idle,
    'walk' => CharacterState.walk,
    'jump' => CharacterState.jump,
    'attack1' => CharacterState.attack1,
    'attack2' => CharacterState.attack2,
    'attack3' => CharacterState.attack3,
    'special' => CharacterState.special,
    'hurt' => CharacterState.hurt,
    'dead' => CharacterState.dead,
    'run' => CharacterState.run,
    _ => throw ArgumentError('Invalid character state: $state'),
  };

  AttackType get toAttackType => switch (this) {
    attack1 => AttackType.one,
    attack2 => AttackType.two,
    attack3 => AttackType.three,
    special => AttackType.special,
    _ => AttackType.none,
  };
}
