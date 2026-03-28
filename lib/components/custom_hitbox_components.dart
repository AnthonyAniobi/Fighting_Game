import 'package:flame/collisions.dart';
import 'package:flame/src/components/position_component.dart';

/// Hitbox components to manage different game states
///
/// Attack, Projectile and health are related to damage of player
///
/// SpriteContent and PlatformHitboxes are related to physics
///

class AttackHitbox extends RectangleHitbox {
  AttackHitbox({super.position, super.size});
}

class HealthHitbox extends RectangleHitbox {
  HealthHitbox({super.position, super.size});
}

class ProjectileHitbox extends RectangleHitbox {
  ProjectileHitbox({super.position, super.size});
}

/// physics hitboxes

class SpriteContentHitbox extends RectangleHitbox {
  SpriteContentHitbox({super.position, super.size});
}

class PlatformHitbox extends RectangleHitbox {
  PlatformHitbox({super.position, super.size});

  // @override
  // bool onComponentTypeCheck(PositionComponent other) {
  //   if (other.runtimeType == SpriteContentHitbox ||
  //       other.runtimeType == HealthHitbox ||
  //       other.runtimeType == PlatformHitbox) {
  //     return false;
  //   }
  //   return super.onComponentTypeCheck(other);
  // }
}
