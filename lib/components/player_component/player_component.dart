import 'dart:async';

import 'package:fighting_game/components/custom_hitbox_components.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/enums/attack_type.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/enums/move_direction.dart';
import 'package:fighting_game/game/combat_game.dart';
import 'package:fighting_game/models/box_position.dart';
import 'package:fighting_game/models/player_config/player_config.dart';
import 'package:fighting_game/models/player_stats.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

part 'player_component_part.dart';

class PlayerComponent extends SpriteAnimationGroupComponent<CharacterState>
    with CollisionCallbacks, HasGameReference<CombatGame> {
  PlayerComponent(this.characterType, {this.direction = Direction.right}) {
    stats = PlayerStats.fromPlayerType(characterType);
    config = PlayerConfig.fromType(characterType);
    priority = 1;
    size = config.spriteSize;
  }

  final CharacterType characterType;
  late final PlayerStats stats;
  late final PlayerConfig config;
  late final HealthHitbox healthHitbox;
  late final AttackHitbox attackHitbox;
  late final SpriteContentHitbox contentHitbox;

  Direction direction;
  double health = GameConstants.maxLife;
  CharacterState _playerState = CharacterState.idle;

  CharacterState get playerState => _playerState;
  set playerState(CharacterState state) {
    _playerState = state;
    current = state;
    animationTicker?.onFrame = _frameListener;
  }

  // controls
  bool isOnGround = false;
  bool onPowerup = false;
  Vector2 velocity = Vector2.zero();
  double actionTimer = 0;
  // jump variables
  double _jumpTime = 0;
  // damage
  double _damage = 0;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    debugMode = true;

    healthHitbox = HealthHitbox(
      size: Vector2(config.healthBox.width, config.healthBox.height),
      position: Vector2(config.healthBox.x, config.healthBox.y),
    );
    healthHitbox.debugMode = true;
    healthHitbox.onCollisionCallback = _handleHealthCollision;
    add(healthHitbox);
    contentHitbox = SpriteContentHitbox(
      size: Vector2(config.contentBox.width, config.contentBox.height),
      position: Vector2(config.contentBox.x, config.contentBox.y),
    );
    contentHitbox.debugMode = true;
    contentHitbox.debugColor = Colors.blue;
    contentHitbox.onCollisionCallback = _handleContentCollision;
    add(contentHitbox);
    _loadSprites();
    playerState = CharacterState.idle;

    //
    attackHitbox = AttackHitbox(position: Vector2.zero(), size: Vector2.zero());
    attackHitbox.debugColor = Colors.red;
    attackHitbox.debugMode = true;
    attackHitbox.collisionType = CollisionType.inactive;
    attackHitbox.onCollisionStartCallback = _handleAttackStartCollision;
    attackHitbox.onCollisionCallback = _handleAttackCollision;
    add(attackHitbox);

    if (direction.isLeft) {
      flipHorizontallyAroundCenter();
      position -= Vector2(config.flipOffset, 0);
    }

    // test for combat fixed positions
    // final borders = contentFixedBorders;
    // game.addAll([right]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateMovement(dt);
    _applyGravity(dt);

    if (actionTimer > 0) {
      actionTimer -= dt;
    } else if (!playerState.isMoving) {
      playerState = CharacterState.idle;
    }
    // if (health <= 0) {
    //   playerState = CharacterState.dead;
    // } else
    //if (actionTimer > 0) {
    //   //
    //   actionTimer -= dt;
    // } else if (velocity.isZero() || velocity.isJump) {

    //   playerState = CharacterState.idle;
    // } else {
    //   playerState = _moveState;
    // }
  }

  void movePlayer(MoveDirection dir) {
    // flip ddirection if movement is in the opposite direction
    if ((direction.isRight && dir.isLeft) ||
        (direction.isLeft && dir.isRight)) {
      _flipDirection();
    }
    _move(dir);
  }

  void jump() {
    if (isOnGround && !_playerState.isJump) {
      _jump();
    }
  }

  void attack(AttackType attackType) {
    if (playerState == attackType.toState) return;
    playerState = attackType.toState;
    actionTimer = config.stateTime(attackType.toState);
    final attackBox = config.getAttackBox(attackType.toState);
    attackHitbox.size = Vector2(attackBox.width, attackBox.height);
    attackHitbox.position = Vector2(attackBox.x, attackBox.y);
    _damage = stats.getAttackPower(attackType.toState);
  }

  void stopMoving() {
    velocity = Vector2.zero();
    playerState = CharacterState.idle;
  }

  void takeDamage(double damage) {
    if (_isDefending) return;
    health -= damage;
  }

  FixedBorders get contentFixedBorders => FixedBorders(
    left: direction.isRight
        ? contentHitbox.absolutePosition.x
        : contentHitbox.absolutePosition.x - contentHitbox.size.x,
    right: direction.isRight
        ? contentHitbox.absolutePosition.x + contentHitbox.size.x
        : contentHitbox.absolutePosition.x,
    up: contentHitbox.absolutePosition.y,
    down: contentHitbox.y + contentHitbox.size.y,
  );
}
