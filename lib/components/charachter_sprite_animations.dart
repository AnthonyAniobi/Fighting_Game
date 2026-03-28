import 'package:fighting_game/constants/sprite_vectors.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/models/sprite_vector.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

Future<void> loadAllSprites() async {
  final List<String> spritePaths = [
    'Buttons/attack.png',
    'Buttons/left.png',
    'Buttons/right.png',
    'Buttons/special.png',
    'Buttons/sprint.png',
    'Buttons/up.png',
    'Buttons/pause.png',
    'Fire_Wizard/Projectile1.png',
    'Lightning_Mage/Projectile1.png',
    'Wanderer_Magican/Projectile1.png',
    'Wanderer_Magican/Projectile2.png',
    'Samurai_Archer/Projectile1.png',
    'Skeleton_Archer/Projectile1.png',
    'Background/selection_background.png',
  ];
  // add charachters
  for (final characterType in CharacterType.values) {
    for (final characterState in CharacterState.values) {
      if (characterType.canJump && characterState == CharacterState.jump) {
        continue; // skeletons cant Jump
      }
      final path = '${characterType.spritePath}/${characterState.spritePath}';
      spritePaths.add(path);
    }
  }
  // add all background
  for (int index = 1; index <= 7; index++) {
    spritePaths.add('Background/bg$index.png');
  }
  // load all sprites
  await Flame.images.loadAll(spritePaths);
}

SpriteAnimationComponent playerAnimationComponentFromSpriteSheet({
  required CharacterType characterType,
  required CharacterState characterState,
  required double stepTime,
  required Anchor anchor,
  required bool loop,
}) {
  final spriteAnimation = SpriteAnimation.spriteList(
    frames(characterType, characterState)
        .map(
          (vector) => Sprite(
            Flame.images.fromCache(
              '${characterType.spritePath}/${characterState.spritePath}',
            ),
            srcPosition: Vector2(vector.x, vector.y),
            srcSize: Vector2(vector.width, vector.height),
          ),
        )
        .toList(),
    stepTime: stepTime,
    loop: loop,
  );
  return SpriteAnimationComponent(animation: spriteAnimation, anchor: anchor);
}

SpriteAnimation playerAnimationFromSpriteSheet({
  required CharacterType characterType,
  required CharacterState characterState,
  required double stepTime,
  required bool loop,
}) {
  return SpriteAnimation.spriteList(
    frames(characterType, characterState)
        .map(
          (vector) => Sprite(
            Flame.images.fromCache(
              '${characterType.spritePath}/${characterState.spritePath}',
            ),
            srcPosition: Vector2(vector.x, vector.y),
            srcSize: Vector2(vector.width, vector.height),
          ),
        )
        .toList(),
    stepTime: stepTime,
    loop: loop,
  );
}

List<SpriteVector> frames(
  CharacterType characterType,
  CharacterState characterState,
) => switch (characterState) {
  CharacterState.idle => switch (characterType) {
    CharacterType.fireWizard => fireWizardIdle,
    CharacterType.lightningWizard => lightningMageIdle,
    CharacterType.wandererMagician => wandererMagicianIdle,
    CharacterType.skeletonWarrior => skeletonWarriorIdle,
    CharacterType.skeletonArcher => skeletonArcherIdle,
    CharacterType.skeletonSpearman => skeletonSpearmanIdle,
    CharacterType.knight1 => knight1Idle,
    CharacterType.knight2 => knight2Idle,
    CharacterType.knight3 => knight3Idle,
    CharacterType.samurai => samuraiIdle,
    CharacterType.samuraiArcher => samuraiArcherIdle,
    CharacterType.samuraiCommander => samuraiCommanderIdle,
  },
  CharacterState.attack1 => switch (characterType) {
    CharacterType.fireWizard => fireWizardAttack1,
    CharacterType.lightningWizard => lightningMageAttack1,
    CharacterType.wandererMagician => wandererMagicianAttack1,
    CharacterType.skeletonWarrior => skeletonWarriorAttack1,
    CharacterType.skeletonArcher => skeletonArcherAttack1,
    CharacterType.skeletonSpearman => skeletonSpearmanAttack1,
    CharacterType.knight1 => knight1Attack1,
    CharacterType.knight2 => knight2Attack1,
    CharacterType.knight3 => knight3Attack1,
    CharacterType.samurai => samuraiAttack1,
    CharacterType.samuraiArcher => samuraiArcherAttack1,
    CharacterType.samuraiCommander => samuraiCommanderAttack1,
  },
  CharacterState.attack2 => switch (characterType) {
    CharacterType.fireWizard => fireWizardAttack2,
    CharacterType.lightningWizard => lightningMageAttack2,
    CharacterType.wandererMagician => wandererMagicianAttack2,
    CharacterType.skeletonWarrior => skeletonWarriorAttack2,
    CharacterType.skeletonArcher => skeletonArcherAttack2,
    CharacterType.skeletonSpearman => skeletonSpearmanAttack2,
    CharacterType.knight1 => knight1Attack2,
    CharacterType.knight2 => knight2Attack2,
    CharacterType.knight3 => knight3Attack2,
    CharacterType.samurai => samuraiAttack2,
    CharacterType.samuraiArcher => samuraiArcherAttack2,
    CharacterType.samuraiCommander => samuraiCommanderAttack2,
  },
  CharacterState.attack3 => switch (characterType) {
    CharacterType.fireWizard => fireWizardAttack3,
    CharacterType.lightningWizard => lightningMageAttack3,
    CharacterType.wandererMagician => wandererMagicianAttack3,
    CharacterType.skeletonArcher => skeletonArcherAttack3,
    CharacterType.skeletonSpearman => skeletonSpearmanAttack3,
    CharacterType.skeletonWarrior => skeletonWarriorAttack3,
    CharacterType.knight1 => knight1Attack3,
    CharacterType.knight2 => knight2Attack3,
    CharacterType.knight3 => knight3Attack3,
    CharacterType.samurai => samuraiAttack3,
    CharacterType.samuraiArcher => samuraiArcherAttack3,
    CharacterType.samuraiCommander => samuraiCommanderAttack3,
  },
  CharacterState.special => switch (characterType) {
    CharacterType.fireWizard => fireWizardSpecial,
    CharacterType.lightningWizard => lightningMageSpecial,
    CharacterType.wandererMagician => wandererMagicianSpecial,
    CharacterType.skeletonWarrior => skeletonWarriorSpecial,
    CharacterType.skeletonArcher => skeletonArcherSpecial,
    CharacterType.skeletonSpearman => skeletonSpearmanSpecial,
    CharacterType.knight1 => knight1Special,
    CharacterType.knight2 => knight2Special,
    CharacterType.knight3 => knight3Special,
    CharacterType.samurai => samuraiSpecial,
    CharacterType.samuraiArcher => samuraiArcherSpecial,
    CharacterType.samuraiCommander => samuraiCommanderSpecial,
  },
  CharacterState.hurt => switch (characterType) {
    CharacterType.fireWizard => fireWizardHurt,
    CharacterType.lightningWizard => lightningMageHurt,
    CharacterType.wandererMagician => wandererMagicianHurt,
    CharacterType.skeletonWarrior => skeletonWarriorHurt,
    CharacterType.skeletonArcher => skeletonArcherHurt,
    CharacterType.skeletonSpearman => skeletonSpearmanHurt,
    CharacterType.knight1 => knight1Hurt,
    CharacterType.knight2 => knight2Hurt,
    CharacterType.knight3 => knight3Hurt,
    CharacterType.samurai => samuraiHurt,
    CharacterType.samuraiArcher => samuraiArcherHurt,
    CharacterType.samuraiCommander => samuraiCommanderHurt,
  },
  CharacterState.dead => switch (characterType) {
    CharacterType.fireWizard => fireWizardDie,
    CharacterType.lightningWizard => lightningMageDie,
    CharacterType.wandererMagician => wandererMagicianDead,
    CharacterType.skeletonWarrior => skeletonWarriorDead,
    CharacterType.skeletonArcher => skeletonArcherDead,
    CharacterType.skeletonSpearman => skeletonSpearmanDie,
    CharacterType.knight1 => knight1Die,
    CharacterType.knight2 => knight2Dead,
    CharacterType.knight3 => knight3Die,
    CharacterType.samurai => samuraiDies,
    CharacterType.samuraiArcher => samuraiArcherDies,
    CharacterType.samuraiCommander => samuraiCommanderDies,
  },
  CharacterState.run => switch (characterType) {
    CharacterType.fireWizard => fireWizardRun,
    CharacterType.lightningWizard => lightningMageRun,
    CharacterType.wandererMagician => wandererMagicianRun,
    CharacterType.skeletonWarrior => skeletonWarriorRun,
    CharacterType.skeletonArcher => skeletonArcherRun,
    CharacterType.skeletonSpearman => skeletonSpearmanRun,
    CharacterType.knight1 => knight1Run,
    CharacterType.knight2 => knight2Run,
    CharacterType.knight3 => knight3Run,
    CharacterType.samurai => samuraiRun,
    CharacterType.samuraiArcher => samuraiArcherRun,
    CharacterType.samuraiCommander => samuraiCommanderRun,
  },
  CharacterState.walk => switch (characterType) {
    CharacterType.fireWizard => fireWizardWalk,
    CharacterType.lightningWizard => lightningMageWalk,
    CharacterType.wandererMagician => wandererMagicianWalk,
    CharacterType.skeletonWarrior => skeletonWarriorWalk,
    CharacterType.skeletonArcher => skeletonArcherWalk,
    CharacterType.skeletonSpearman => skeletonSpearmanWalk,
    CharacterType.knight1 => knight1Walk,
    CharacterType.knight2 => knight2Walk,
    CharacterType.knight3 => knight3Walk,
    CharacterType.samurai => samuraiWalk,
    CharacterType.samuraiArcher => samuraiArcherWalk,
    CharacterType.samuraiCommander => samuraiCommanderWalk,
  },
  CharacterState.jump => switch (characterType) {
    CharacterType.fireWizard => fireWizardJump,
    CharacterType.lightningWizard => lightningMageJump,
    CharacterType.wandererMagician => wandererMagicianJump,
    CharacterType.skeletonWarrior => skeletonWarriorIdle, // cant Jump
    CharacterType.skeletonArcher => skeletonArcherIdle, // cant Jump
    CharacterType.skeletonSpearman => skeletonSpearmanIdle, // cant Jump
    CharacterType.knight1 => knight1Jump,
    CharacterType.knight2 => knight2Jump,
    CharacterType.knight3 => knight3Jump,
    CharacterType.samurai => samuraiJump,
    CharacterType.samuraiArcher => samuraiArcherJump,
    CharacterType.samuraiCommander => samuraiCommanderJump,
  },
};
