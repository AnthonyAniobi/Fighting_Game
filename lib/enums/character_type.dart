import 'package:fighting_game/components/projectile_component.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/models/box_position.dart';
import 'package:fighting_game/models/sprite_vector.dart';
import 'package:flame/components.dart';

enum CharacterType {
  fireWizard,
  lightningWizard,
  wandererMagician,
  knight1,
  knight2,
  knight3,
  samurai,
  samuraiArcher,
  samuraiCommander,
  skeletonArcher,
  skeletonWarrior,
  skeletonSpearman;

  String get spritePath => switch (this) {
    fireWizard => 'Fire_Wizard',
    lightningWizard => 'Lightning_Mage',
    wandererMagician => 'Wanderer_Magican',
    knight1 => 'Knight_1',
    knight2 => 'Knight_2',
    knight3 => 'Knight_3',
    samurai => 'Samurai',
    samuraiArcher => 'Samurai_Archer',
    samuraiCommander => 'Samurai_Commander',
    skeletonArcher => 'Skeleton_Archer',
    skeletonWarrior => 'Skeleton_Warrior',
    skeletonSpearman => 'Skeleton_Spearman',
  };

  // check if character is skeleton
  bool get canJump => switch (this) {
    skeletonArcher => false,
    skeletonWarrior => false,
    skeletonSpearman => false,
    _ => true,
  };

  bool hasProjectile(CharacterState state) {
    return switch (this) {
      fireWizard => switch (state) {
        CharacterState.special => true,
        _ => false,
      },
      lightningWizard => switch (state) {
        CharacterState.special => true,
        _ => false,
      },
      wandererMagician => switch (state) {
        CharacterState.attack3 => true,
        CharacterState.special => true,
        _ => false,
      },
      samuraiArcher => switch (state) {
        CharacterState.special => true,
        _ => false,
      },
      skeletonArcher => switch (state) {
        CharacterState.special => true,
        _ => false,
      },
      _ => false,
    };
  }

  ProjectileComponent? getProjectile(
    CharacterState attackState,
    Direction direction,
  ) => switch (this) {
    fireWizard => switch (attackState) {
      CharacterState.special => ProjectileComponent(
        spritePath: '${fireWizard.spritePath}/Projectile1.png',
        frames: 12,
        textureSize: Vector2(64, 64),
        hitboxSize: BoxPosition(30, 20, 30, 30),
        stepTime: 0.04,
        speed: 300,
        direction: direction,
        attackOffset: Vector2(60, 30),
        attackPower: 5,
        canDisperse: true,
        loopAnimation: false,
      ),
      _ => null,
    },
    lightningWizard => switch (attackState) {
      CharacterState.special => ProjectileComponent(
        spritePath: '${lightningWizard.spritePath}/Projectile1.png',
        frames: 10,
        textureSize: Vector2(64, 64),
        hitboxSize: BoxPosition(18, 20, 25, 25),
        stepTime: 0.1,
        speed: 300,
        direction: direction,
        attackOffset: Vector2(60, 25),
        attackPower: 5,
        loopAnimation: true,
      ),
      _ => null,
    },
    wandererMagician => switch (attackState) {
      CharacterState.attack3 => ProjectileComponent(
        spritePath:
            '${CharacterType.wandererMagician.spritePath}/Projectile2.png',
        frames: 9,
        textureSize: Vector2(64, 128),
        hitboxSize: BoxPosition(18, 55, 30, 15),
        stepTime: 0.04,
        speed: 400,
        direction: direction,
        attackOffset: Vector2(60, 30),
        attackPower: 5,
        canDisperse: true,
        loopAnimation: false,
      ),
      CharacterState.special => ProjectileComponent(
        spritePath:
            '${CharacterType.wandererMagician.spritePath}/Projectile1.png',
        frames: 6,
        textureSize: Vector2(64, 128),
        hitboxSize: BoxPosition(18, 45, 40, 35),
        stepTime: 0.05,
        speed: 600,
        direction: direction,
        attackOffset: Vector2(45, 25),
        attackPower: 5,
        canDisperse: false,
        loopAnimation: false,
      ),
      _ => null,
    },
    samuraiArcher => switch (attackState) {
      CharacterState.special => ProjectileComponent(
        spritePath: '${CharacterType.samuraiArcher.spritePath}/Projectile1.png',
        frames: 1,
        textureSize: Vector2(64, 64),
        hitboxSize: BoxPosition(5, 29, 55, 8),
        stepTime: 0.1,
        speed: 650,
        direction: direction,
        attackOffset: Vector2(60, 25),
        attackPower: 5,
        loopAnimation: false,
      ),
      _ => null,
    },
    skeletonArcher => switch (attackState) {
      CharacterState.special => ProjectileComponent(
        spritePath:
            '${CharacterType.skeletonArcher.spritePath}/Projectile1.png',
        frames: 1,
        textureSize: Vector2(48, 48),
        hitboxSize: BoxPosition(2, 20, 43, 8),
        stepTime: 0.1,
        speed: 600,
        direction: direction,
        attackOffset: Vector2(45, 18),
        attackPower: 5,
        loopAnimation: false,
      ),
      _ => null,
    },

    _ => null,
  };
}
