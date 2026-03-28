import 'dart:async';

import 'package:fighting_game/components/custom_hitbox_components.dart';
import 'package:fighting_game/components/player_component/player_component.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlatformComponent extends PositionComponent {
  PlatformComponent({super.position, super.size, this.allowBottomJump = false});
  late final PlatformHitbox hitbox;
  final bool allowBottomJump;
  @override
  FutureOr<void> onLoad() {
    hitbox = PlatformHitbox(size: size);
    hitbox.activeCollisions;
    hitbox.onCollisionCallback = _collisionCallback;
    hitbox.debugMode = true;
    hitbox.debugColor = Colors.yellow;

    add(hitbox);
    return super.onLoad();
  }

  void _collisionCallback(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is SpriteContentHitbox) {
      _handleContentCollision(intersectionPoints, other);
    }
  }

  void _handleContentCollision(
    Set<Vector2> intersectionPoints,
    SpriteContentHitbox contentBox,
  ) {
    final player = contentBox.parent;
    if (player is PlayerComponent) {
      // final playerBoundary = player.contentFixedBorders;
      // final playerCenter = Vector2(
      //   (playerBoundary.left + playerBoundary.right) / 2,
      //   (playerBoundary.up + playerBoundary.down) / 2,
      // );
      // for (Vector2 point in intersectionPoints) {
      //   bool playerLeftOfPlatform = point.x < playerCenter.x;
      //   bool playerAbovePlatform = point.y < playerCenter.y;
      //   bool onLeftSideOfPlatform =
      //       ((position.x + size.x) - playerBoundary.left).abs() < 2;
      //   bool onRightSideOfPlatform =
      //       (position.x - playerBoundary.right).abs() < 2;

      //   if (point.x > playerCenter.x && point.x <= playerBoundary.right) {
      //     _handleRightCollision(contentBox);
      //   } else if (point.x < playerCenter.x && point.x >= playerBoundary.left) {
      //     _handleLeftCollision(contentBox);
      //   }
      //   if (point.y > playerCenter.y && point.y <= playerBoundary.down) {
      //     _handleBottomCollision(player, contentBox);
      //   } else if (point.y < playerCenter.y && point.y >= playerBoundary.up) {
      //     _handleTopCollision(player, contentBox);
      //   } else {
      //     _handleBottomCollision(player, contentBox);
      //   }
      // }
      final playerBoundary = player.contentFixedBorders;

      bool onLeftSideOfPlatform =
          ((absolutePosition.x + size.x + 2) < playerBoundary.left);
      bool onRightSideOfPlatform =
          (absolutePosition.x - 2) > playerBoundary.right;

      if (onLeftSideOfPlatform || onRightSideOfPlatform) {
        if (onLeftSideOfPlatform) {
          _handleLeftCollision(player, contentBox);
        } else {
          _handleRightCollision(player, contentBox);
        }
      } else {
        final intersectionY =
            intersectionPoints.map((p) => p.y).reduce((a, b) => a + b) /
            intersectionPoints.length;

        // Get the player's vertical midpoint in world space
        final playerMidY = player.position.y - (player.size.y / 2);
        if (intersectionY <= playerMidY) {
          // Player hit from the top (landing on platform)
          _handleTopCollision(player, contentBox);
        } else {
          // Player hit from the bottom (jumping into platform)
          _handleBottomCollision(player, contentBox);
        }
      }
    }
  }

  void _handleTopCollision(
    PlayerComponent player,
    SpriteContentHitbox contentBox,
  ) {
    player.velocity.y = 0;
    // final positionFromTop = (player.position.y + player.size)
    // contentBox.position.y = position.y;
    // // player._jumpVelocity = Vector2.zero();
    // // player._jumpTime = 0;
    // player.stopJump();
    player.velocity.y = 0;
  }

  void _handleBottomCollision(
    PlayerComponent player,
    SpriteContentHitbox contentBox,
  ) {
    // Snap to bottom of platform
    // bottom of content box
    final positionFromBottom =
        (player.size.y -
        (player.contentHitbox.height + player.contentHitbox.y));

    player.position.y =
        position.y -
        ((player.size.y - positionFromBottom) * GameConstants.scaleFactor) -
        1;
    // position.y -
    // (player.size.y * GameConstants.scaleFactor) -
    // positionFromBottom;
    if (!player.isOnGround) {
      player.velocity = Vector2.zero();
    }
    player.isOnGround = true;
  }

  void _handleLeftCollision(
    PlayerComponent player,
    SpriteContentHitbox contentBox,
  ) {
    final positionFromLeft = player.direction.isRight
        ? (player.size.x - contentBox.size.x)
        : (player.size.x - contentBox.size.x);

    player.position.x = (position.x + size.x) + positionFromLeft;
  }

  void _handleRightCollision(
    PlayerComponent player,
    SpriteContentHitbox contentBox,
  ) {
    final positionFromRight = player.direction.isRight
        ? -(player.size.x - contentBox.size.x)
        : -(player.size.x - contentBox.size.x);
    player.position.x = position.x + positionFromRight;
    // Snap player to the right edge of the platform
    // contentBox.position.x = position.x + size.x + (contentBox.size.x / 2);
  }
}
