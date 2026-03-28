import 'dart:async';
import 'package:fighting_game/components/player_component/player_component.dart';
import 'package:fighting_game/enums/attack_type.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/enums/fighter_id.dart';
import 'package:fighting_game/enums/move_direction.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

/// Fight-specific states layered on top of CharacterState.
/// Your adventure game uses CharacterState — the fight adds these on top.
enum FightState {
  available, // can act
  attacking, // in an attack animation
  hit, // stagger frames after receiving damage
  knockedDown, // full knockdown
  blocking, // future: block mechanic
}

class FighterComponent extends PlayerComponent {
  FighterComponent(
    super.characterType, {
    super.direction,
    required this.fighterId,
  });

  final FighterId fighterId;

  // ── Fight state ───────────────────────────────────────────────────
  FightState fightState = FightState.available;
  AttackType currentAttack = AttackType.none;
  int comboCount = 0;
  double _stateTimer = 0; // counts down invincibility / stagger frames

  // Attack durations in seconds (tune per character config)
  static const Map<AttackType, double> _attackDuration = {
    AttackType.one: 0.30,
    AttackType.two: 0.55,
    AttackType.special: 0.70,
    AttackType.three: 1.10,
  };

  static const double _hitStaggerDuration = 0.35;
  static const double _knockdownDuration = 1.20;
  static const double _invincibilityWindow = 0.12; // after hit, brief iframe

  // Attack hitbox — active only during attack frames
  late final RectangleHitbox _attackHitbox;
  bool _attackHitboxActive = false;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad(); // loads your sprites, healthHitbox, etc.

    // Attack hitbox sits in front of the fighter (adjusted by direction)
    _attackHitbox = RectangleHitbox(
      size: Vector2(80, 60),
      position: Vector2(size.x * 0.5, size.y * 0.3),
      isSolid: false,
    )..collisionType = CollisionType.active;
    _attackHitbox.debugMode = true;
    _attackHitbox.debugColor = Colors.red; // set to false in production
    position += Vector2(config.flipOffset, 0);
    // Not added until an attack is triggered
  }

  // ── Called by FightingGameController only ─────────────────────────

  /// Execute a movement command — delegates to your existing move field
  void applyMove(MoveDirection dir) {
    if (!_canAct) return;
    if (dir.isIdle) {
      stopMoving();
    } else {
      movePlayer(dir);
    }
  }

  void applyPowerup() {
    if (!_canAct) return;
    onPowerup = !onPowerup;
  }

  /// Jump — delegates to your existing jumping bool
  void applyJump() {
    if (!_canAct) return;
    jump();
  }

  /// Trigger an attack — starts hitbox + state timer
  void applyAttack(AttackType type) {
    if (!_canAct) return;
    if (type == AttackType.none) return;

    currentAttack = type;
    fightState = FightState.attacking;
    // _stateTimer = config.stateTime(type.toState);
    // comboCount++;

    // // Activate attack hitbox
    // _positionAttackHitbox();
    // add(_attackHitbox);
    // _attackHitboxActive = true;

    // Map to your CharacterState (assumes these exist in your enum)
    // playerState = _attackStateFor(type);
    // current = playerState;
    attack(type);
  }

  /// Receive damage — called by controller after collision resolution
  // void applyDamage(double amount, AttackType source) {
  //   // Your existing takeDamage signature is (Set<Vector2>, ShapeHitbox)
  //   // so we handle fight damage separately here
  //   health -= amount;

  //   if (health <= 0) {
  //     health = 0;
  //     fightState = FightState.knockedDown;
  //     _stateTimer = _knockdownDuration;
  //     // playerState = CharacterState.dead; // assumes this exists in your enum
  //     playerState = CharacterState.dead;
  //   } else {
  //     fightState = FightState.hit;
  //     _stateTimer = _hitStaggerDuration;
  //     // playerState = CharacterState.hurt;
  //     playerState = CharacterState.hurt;
  //   }

  //   // current = playerState;
  //   _cancelAttackHitbox();
  // }

  /// Snap position from server state (reconciliation)
  void applyServerReconcile(Vector2 serverPos, double serverLives) {
    final drift = position.distanceTo(serverPos);
    if (drift > 40) position.setFrom(serverPos);
    health = serverLives;
  }

  // ── Flame update ──────────────────────────────────────────────────

  @override
  void update(double dt) {
    super.update(dt); // your existing physics runs here

    // if (_stateTimer > 0) {
    //   _stateTimer -= dt;
    //   if (_stateTimer <= 0) _resolveStateEnd();
    // }

    // Deactivate attack hitbox halfway through the attack window
    // if (_attackHitboxActive && currentAttack != AttackType.none) {
    //   final half = (_attackDuration[currentAttack] ?? 0.4) * 0.5;
    //   if (_stateTimer < half) _cancelAttackHitbox();
    // }
  }

  // ── Private helpers ───────────────────────────────────────────────

  bool get _canAct =>
      fightState == FightState.available ||
      fightState == FightState.attacking; // can chain light attacks

  // void _resolveStateEnd() {
  //   switch (fightState) {
  //     case FightState.attacking:
  //       currentAttack = AttackType.none;
  //       comboCount = 0;
  //       fightState = FightState.available;
  //       // playerState = CharacterState.idle;
  //       // current = playerState;
  //       current = CharacterState.idle;
  //     case FightState.hit:
  //       fightState = FightState.available;
  //       // playerState = CharacterState.idle;
  //       // current = playerState;
  //       current = CharacterState.idle;
  //     case FightState.knockedDown:
  //       // stay down — game controller checks lives to end round
  //       break;
  //     default:
  //       break;
  //   }
  // }

  void _positionAttackHitbox() {
    // Flip hitbox to face the correct direction
    _attackHitbox.position = direction == Direction.right
        ? Vector2(size.x * 0.5, size.y * 0.3)
        : Vector2(-size.x * 0.1, size.y * 0.3);
  }

  void _cancelAttackHitbox() {
    if (_attackHitboxActive) {
      remove(_attackHitbox);
      _attackHitboxActive = false;
    }
  }
}
