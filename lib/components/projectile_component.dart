import 'package:fighting_game/components/custom_hitbox_components.dart';
import 'package:fighting_game/components/player_component/player_component.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/models/box_position.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../enums/direction.dart' show Direction;

class ProjectileComponent extends SpriteAnimationComponent {
  final String spritePath;
  final int frames;
  final Vector2 textureSize;
  final BoxPosition hitboxSize;
  final double stepTime;
  final bool canDisperse;
  final double speed;
  final Direction direction;
  final Vector2 attackOffset;
  final double attackPower;
  final bool loopAnimation;

  late final RectangleHitbox hitbox;
  late double timeToDisperse;
  late PlayerComponent player;

  ProjectileComponent({
    required this.spritePath,
    required this.frames,
    required this.textureSize,
    required this.hitboxSize,
    required this.stepTime,
    required this.speed,
    required this.direction,
    required this.attackOffset,
    required this.attackPower,
    required this.loopAnimation,
    this.canDisperse = false,
    super.priority = 5,
    super.anchor = Anchor.center,
  }) {
    animation = SpriteAnimation.fromFrameData(
      Flame.images.fromCache(spritePath),
      SpriteAnimationData.sequenced(
        amount: frames,
        stepTime: stepTime,
        textureSize: textureSize,
        loop: loopAnimation,
      ),
    );
    size = textureSize;
    timeToDisperse = stepTime * frames;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    hitbox = ProjectileHitbox(
      size: Vector2(hitboxSize.width, hitboxSize.height),
      position: Vector2(hitboxSize.x, hitboxSize.y),
    );
    hitbox.debugMode = true;
    hitbox.debugColor = Colors.purple;
    hitbox.onCollisionCallback = _onCollission;
    add(hitbox);
    scale = Vector2.all(GameConstants.scaleFactor);

    if (direction.isLeft) {
      flipHorizontallyAroundCenter();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (canDisperse) {
      timeToDisperse -= dt;
      if (timeToDisperse <= 0) {
        removeFromParent();
      }
    }
    position.x += speed * dt * direction.intValue;
  }

  void _onCollission(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is HealthHitbox) {
      final otherPlayer = other.parent;
      if (otherPlayer is PlayerComponent) {
        if (otherPlayer != player) {
          player.takeDamage(attackPower);
          _destroyProjectile();
        }
      }
    } else if (other is PlatformHitbox) {
      _destroyProjectile();
    } else if (other is ProjectileHitbox) {
      _destroyProjectile();
    }
  }

  void _destroyProjectile() {
    // add explosion pysics and sounds here
    removeFromParent();
  }
}
