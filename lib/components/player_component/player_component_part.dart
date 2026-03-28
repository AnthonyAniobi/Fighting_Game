part of 'player_component.dart';

///
/// contains all methods used only by the player component class
///
extension _PlayerComponentExtension on PlayerComponent {
  void _loadSprites() {
    animations = {
      CharacterState.idle: _loadStateData(CharacterState.idle, true),
      CharacterState.walk: _loadStateData(CharacterState.walk, true),
      if (characterType.canJump)
        CharacterState.jump: _loadStateData(CharacterState.jump, false),
      CharacterState.attack1: _loadStateData(CharacterState.attack1, false),
      CharacterState.attack2: _loadStateData(CharacterState.attack2, false),
      CharacterState.attack3: _loadStateData(CharacterState.attack3, false),
      CharacterState.hurt: _loadStateData(CharacterState.hurt, false),
      CharacterState.dead: _loadStateData(CharacterState.dead, false),
      CharacterState.run: _loadStateData(CharacterState.run, true),
      CharacterState.special: _loadStateData(CharacterState.special, false),
    };
  }

  SpriteAnimation _loadStateData(CharacterState state, bool loop) {
    final statData = config.stateData(state);
    return SpriteAnimation.fromFrameData(
      Flame.images.fromCache("${characterType.spritePath}/${state.spritePath}"),
      SpriteAnimationData.sequenced(
        amount: statData.spriteCount,
        stepTime: statData.time,
        textureSize: config.spriteSize,
        loop: loop,
      ),
    );
  }

  void _frameListener(int frame) {
    if (_playerState.isJump) {
      if (config.jumpInterval.startFrame == frame) {
        _pushUpwards(config.jumpInterval.midAirFrames);
      }
    }
    if (_playerState.isAttacking) {
      final attackFrame = config.attackFrame(_playerState);
      if (attackFrame == frame) {
        if (characterType.hasProjectile(_playerState)) {
          _sendProjectile(_playerState);
        } else {
          attackHitbox.collisionType = CollisionType.active;
        }
      } else {
        attackHitbox.collisionType = CollisionType.inactive;
      }
    } else {
      attackHitbox.collisionType = CollisionType.inactive;
    }
  }

  void _pushUpwards(int frameCount) {
    // add jump logic
    _jumpTime = config.jump.time * frameCount;
    velocity = _jumpPower;
    isOnGround = false;
  }

  void _sendProjectile(CharacterState state) {
    final projectile = characterType.getProjectile(state, direction)!;
    projectile.player = this;
    projectile.position =
        (contentHitbox.absolutePosition +
        Vector2(
          direction.isRight
              ? projectile.attackOffset.x
              : -projectile.attackOffset.x,
          projectile.attackOffset.y,
        ));
    game.add(projectile);
  }

  void _updateMovement(double dt) {
    position += velocity * dt;
    // // update movements
    // if (velocity.isHorizontalMove && !_isOnBoundary) {
    //   double speed = _moveSpeed * dt * move.x;
    //   position += Vector2(speed, 0);
    // }
    // // update jumps
    // position += _jumpVelocity * dt;
    // if (jumping) {
    //   velocity.y += (stats.jumpPower * dt * 2) / _jumpTime; // gravity
    // }
    // if (position.y < GameConstants.groundLevel) {
    //   _jumpVelocity.y += (stats.jumpPower * dt * 2) / _jumpTime; // gravity
    // } else {
    //   position.y = GameConstants.groundLevel;
    //   _jumpVelocity = Vector2.zero();
    // }
    // update boundary
    // if (_isOnBoundary) {
    //   velocity.x = 0;
    // }
  }

  void _applyGravity(double dt) {
    velocity.y += GameConstants.gravity;
    velocity.y = velocity.y.clamp(-stats.jumpPower, stats.jumpPower * 2);
    position.y += velocity.y * dt;
  }

  void _jump() {
    playerState = CharacterState.jump;
    actionTimer = config.stateTime(CharacterState.jump);
  }

  void _move(MoveDirection input) {
    velocity = Vector2(input.integerValue * _moveSpeed, 0);
    playerState = _moveState;
  }

  double get _moveSpeed => onPowerup ? stats.runSpeed : stats.walkSpeed;
  CharacterState get _moveState =>
      onPowerup ? CharacterState.run : CharacterState.walk;
  Vector2 get _jumpPower {
    double jumpHeight = onPowerup ? stats.jumpPower * 1.5 : stats.jumpPower;
    double jumpDistance = onPowerup
        ? stats.jumpDistance * 1.5
        : stats.jumpDistance;
    return Vector2(jumpDistance * direction.intValue, -jumpHeight);
  }

  bool get _isOnBoundary =>
      position.x <= 0 || position.x >= GameConstants.screenSize.x;

  void _slidePlayer(Vector2 vector) {
    if (_isOnBoundary) return;
    position += vector;
  }

  void _handleHealthCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is HealthHitbox) {
      final otherPlayer = other.parent;
      if (otherPlayer is PlayerComponent) {
        // if (otherPlayer.direction == direction) {
        //   // If players are facing the same direction, push them apart based on their relative positions
        //   final myPushX = position.x < otherPlayer.position.x ? -2.0 : 2.0;
        //   final otherPushX = position.x < otherPlayer.position.x ? 2.0 : -2.0;
        //   _slidePlayer(Vector2(myPushX, 0));
        //   otherPlayer._slidePlayer(Vector2(otherPushX, 0));
        // }
        // else {
        //   // if players are facing each other, push them apart based on their directions
        //   _slidePlayer(Vector2(-direction.intValue * 2, 0));
        //   otherPlayer._slidePlayer(
        //     Vector2(-otherPlayer.direction.intValue * 2, 0),
        //   );
        // }
      }
    }
  }

  void _handleContentCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    // collision between sprite hitbox and other player's sprite hitbox
    if (other is SpriteContentHitbox) {
      final otherPlayer = other.parent;
      if (otherPlayer is PlayerComponent) {
        if (otherPlayer.direction == direction) {
          // If players are facing the same direction, push them apart based on their relative positions\
          final playerX = position.x + size.x;
          final otherPlayerX = otherPlayer.position.x + otherPlayer.size.x;
          final myPushX = playerX < otherPlayerX ? -2.0 : 2.0;
          final otherPushX = playerX < otherPlayerX ? 2.0 : -2.0;
          _slidePlayer(Vector2(myPushX, 0));
          otherPlayer._slidePlayer(Vector2(otherPushX, 0));
        } else {
          // if players are facing each other, push them apart based on their directions
          _slidePlayer(Vector2(-direction.intValue * 2, 0));
          otherPlayer._slidePlayer(
            Vector2(-otherPlayer.direction.intValue * 2, 0),
          );
        }
      }
    }
  }

  /// attack start to deal damage
  void _handleAttackStartCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is HealthHitbox) {
      final otherPlayer = other.parent;
      if (otherPlayer is PlayerComponent) {
        if (otherPlayer != this) {
          _damage = stats.getAttackPower(_playerState);
          otherPlayer.takeDamage(_damage);
          _damage = 0; // reset damage to zero so it doesn't collide continously
          // _attackHitbox.collisionType = CollisionType.inactive;
        }
      }
    }
  }

  /// attack collision to apply knockback
  void _handleAttackCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is HealthHitbox) {
      final otherPlayer = other.parent;
      if (otherPlayer is PlayerComponent) {
        if (otherPlayer != this) {
          otherPlayer._damageSlideBack(direction);
        }
      }
    }
  }

  void _damageSlideBack(Direction direction) {
    _slidePlayer(Vector2(1.0 * direction.intValue, 0));
    playerState = CharacterState.hurt;
    actionTimer = config.stateTime(CharacterState.hurt);
    if (this.direction == direction) {
      _flipDirection();
    }
  }

  void _flipDirection() {
    if (direction.isRight) {
      flipHorizontallyAroundCenter();
      direction = Direction.left;
      position -= Vector2(config.flipOffset, 0);
    } else {
      flipHorizontallyAroundCenter();
      position += Vector2(config.flipOffset, 0);
      direction = Direction.right;
    }
  }

  bool get _isDefending {
    // defending occurs in special attack and the frame count is -1
    return playerState.isSpecial && config.specialAttackFrame == -1;
  }
}
