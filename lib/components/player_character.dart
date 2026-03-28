import 'package:fighting_game/components/charachter_sprite_animations.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/extensions/player_character_extension.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/models/player_sprite_settings.dart';
import 'package:fighting_game/models/player_stats.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlayerCharacter extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameReference<FightingGame> {
  PlayerCharacter({
    required this.playerType,
    this.direction = Direction.right,
  }) {
    stats = PlayerStats.fromPlayerType(playerType);
    spriteSettings = PlayerSpriteSettings.fromCharacterType(playerType);
    priority = 1;
  }

  final CharacterType playerType;
  late final PlayerStats stats;
  late final PlayerSpriteSettings spriteSettings;
  late final RectangleHitbox hitbox;

  Direction direction;
  double lives = GameConstants.maxLife;
  CharacterState playerState = CharacterState.idle;
  Vector2 velocity = Vector2.zero();
  late SpriteAnimationComponent spriteAnimation;

  double actionTimer = 0.0;
  bool isMoving = false;
  double jumpTime = 0;
  bool isPowerup = false;
  double powerUpTimer = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // load sprite image

    final stateSpriteSettings = spriteSettings.getSettingsForState(playerState);
    spriteAnimation = playerAnimationComponentFromSpriteSheet(
      characterType: playerType,
      characterState: playerState,
      stepTime: stateSpriteSettings.time,
      anchor: stateSpriteSettings.anchor,
      loop: false,
    );

    actionTimer =
        stateSpriteSettings.time * spriteAnimation.animation!.frames.length;
    hitbox = RectangleHitbox(
      size: spriteAnimation.size * 0.8,
      anchor: spriteAnimation.anchor,
      position: spriteAnimation.position,
    );
    powerUpTimer = stats.powerUpDuration;
    // hitbox.debugMode = true;
    add(hitbox);

    add(spriteAnimation);
    if (direction.isLeft) {
      _flipDirection();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateBoundaries();
    _updateMovement(dt);
    if (isPowerup) {
      powerUpTimer -= dt;
      if (powerUpTimer <= 0) {
        isPowerup = false;
      }
    }
    if (actionTimer > 0) {
      actionTimer -= dt;
      if (actionTimer <= 0) {
        if (playerState == CharacterState.dead) {
          _endGame();
        } else if (isMoving) {
          moveStart(direction);
        } else {
          updateState(CharacterState.idle);
        }
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    // if (other is PlayerCharacter) {
    //   if (playerState.isAttacking && !other.playerState.isAttacking) {
    //     double attackPower = stats.getAttackPower(playerState);
    //     other._takeDamage(attackPower, direction);
    //     _giveDamage(attackPower);
    //   }
    // } else if (other is ProjectileComponent) {
    //   // if hit by projectile
    //   if (other.player != this) {
    //     _takeDamage(other.attackPower, other.direction);
    //     other.removeFromParent();
    //   }
    // }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerCharacter) {
      if (playerState.isAttacking && !other.playerState.isAttacking) {
        if (other.isAtBoundary) {
          _slideBack(0.2);
        } else {
          other._slideBack(0.2);
        }
      } else if (other.playerState.isAttacking && playerState.isAttacking) {
        _slideBack(0.1);
        other._slideBack(0.1);
      }
    }
  }

  void updateState(CharacterState newState) {
    if (lives <= 0 && playerState.isDead) {
      return;
    }
    if (actionTimer >= 0 && playerState == CharacterState.hurt) {
      return; // prevent state change while hurt animation is playing
    }
    if (playerType.canJump && newState == CharacterState.jump) {
      return; // skeletons cant Jump
    }
    if (playerState.isAttacking && playerState == newState && actionTimer > 0) {
      return;
    }
    playerState = newState;
    final stateSpriteSettings = spriteSettings.getSettingsForState(playerState);
    spriteAnimation.animation = playerAnimationFromSpriteSheet(
      characterType: playerType,
      characterState: playerState,
      stepTime: stateSpriteSettings.time,
      loop: false,
    );

    spriteAnimation.anchor = stateSpriteSettings.anchor;
    actionTimer =
        stateSpriteSettings.time * spriteAnimation.animation!.frames.length;
    // set action timer for the duration of the animation
    if (newState.isAttacking) {
      _projectileAttack(newState, direction);
    }
  }

  void moveStart(Direction direction) {
    updateState(isPowerup ? CharacterState.run : CharacterState.walk);
    isMoving = true;
    if (this.direction != direction) {
      _flipDirection();
    }
    this.direction = direction;
  }

  void moveStop() {
    updateState(CharacterState.idle);
    isMoving = false;
  }

  void jump() {
    // hitbox.onCollisionStartCallback;

    if (playerType.canJump) {
      return; // skeletons cant Jump
    }
    if (playerState == CharacterState.hurt) return; // prevent jump while hurt
    if (playerState == CharacterState.dead) return; // prevent jump while hurt
    if (playerState == CharacterState.jump) return; // prevent double jump

    isMoving = false;
    updateState(CharacterState.jump);
    jumpTime =
        spriteAnimation.animation!.frames.length *
        spriteSettings.jump.time *
        0.9;
    velocity = Vector2(
      stats.jumpDistance * direction.intValue,
      -stats.jumpPower,
    );
  }

  void sprint() {
    isPowerup = !isPowerup;
  }

  bool get canJump {
    if (playerType.canJump) {
      return false; // skeletons cant Jump
    }
    return true;
  }

  /// private helper functions

  void _updateMovement(double dt) {
    if (isMoving) {
      double moveSpeed = isPowerup ? stats.runSpeed : stats.walkSpeed;
      // update position based on direction
      if (direction == Direction.right &&
          position.x + spriteAnimation.size.x < GameConstants.screenSize.x) {
        position.add(Vector2(moveSpeed, 0));
      } else if (direction == Direction.left &&
          position.x > spriteAnimation.size.x) {
        position.add(Vector2(-moveSpeed, 0));
      }
    }

    if (position.x <= spriteAnimation.x && velocity.x < 0) {
      velocity.x = 0;
    } else if (position.x + spriteAnimation.size.x >=
            GameConstants.screenSize.x &&
        velocity.x > 0) {
      velocity.x = 0;
    }
    position += velocity * dt;
    if (position.y < GameConstants.groundLevel) {
      velocity.y += (stats.jumpPower * dt * 2) / jumpTime; // gravity
    } else {
      position.y = GameConstants.groundLevel;
      velocity = Vector2.zero();
    }
  }

  void _takeDamage(double damage, Direction direction) {
    moveStop();
    if (this.direction == direction) {
      this.direction = direction.opposite;
      _flipDirection();
    }
    lives -= damage;
    if (lives <= 0) {
      lives = 0;
      updateState(CharacterState.dead);
      return;
    } else {
      updateState(CharacterState.hurt);
    }
  }

  void _giveDamage(double damage) {
    // add powerup points to the attacker
    powerUpTimer += (damage * 0.1);
    if (powerUpTimer > stats.powerUpDuration) {
      powerUpTimer = stats.powerUpDuration;
    }
  }

  void _updateBoundaries() {
    hitbox.position = spriteAnimation.position;
    hitbox.size = Vector2(spriteAnimation.size.x * 0.9, spriteAnimation.size.y);
    hitbox.anchor = spriteAnimation.anchor;
  }

  void _flipDirection() {
    spriteAnimation.flipHorizontallyAroundCenter();
    hitbox.flipHorizontallyAroundCenter();
  }

  void _endGame() {
    game.endGame();
  }

  void _projectileAttack(CharacterState attackState, Direction direction) {
    final projectile = playerType.getProjectile(playerState, direction);
    // if (projectile != null) {
    //   projectile.player = this;
    //   projectile.position =
    //       position +
    //       Vector2(
    //         spriteAnimation.size.x,
    //         -spriteAnimation.size.y * projectile.attackHeight,
    //       );
    //   projectile.scale = Vector2.all(1.5);
    //   Future.delayed(Duration(milliseconds: projectile.delayTime.toInt()), () {
    //     game.add(projectile);
    //   });
    // }
  }

  void _slideBack(double multiplier) {
    // slide the character back when hit by an attack
    double slideDistance = spriteAnimation.size.x * multiplier;
    if (direction == Direction.right) {
      position.add(Vector2(-slideDistance, 0));
    } else {
      position.add(Vector2(slideDistance, 0));
    }
  }
}
