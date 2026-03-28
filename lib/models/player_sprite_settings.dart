import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:flame/components.dart';

class PlayerSpriteSettings {
  final StateSpriteSettings attack1;
  final StateSpriteSettings attack2;
  final StateSpriteSettings attack3;
  final StateSpriteSettings dead;
  final StateSpriteSettings hurt;
  final StateSpriteSettings idle;
  final StateSpriteSettings jump;
  final StateSpriteSettings run;
  final StateSpriteSettings special;
  final StateSpriteSettings walk;

  PlayerSpriteSettings._({
    required this.attack1,
    required this.attack2,
    required this.attack3,
    required this.dead,
    required this.hurt,
    required this.idle,
    required this.jump,
    required this.run,
    required this.special,
    required this.walk,
  });

  StateSpriteSettings getSettingsForState(CharacterState state) =>
      switch (state) {
        CharacterState.attack1 => attack1,
        CharacterState.attack2 => attack2,
        CharacterState.attack3 => attack3,
        CharacterState.dead => dead,
        CharacterState.hurt => hurt,
        CharacterState.idle => idle,
        CharacterState.jump => jump,
        CharacterState.run => run,
        CharacterState.special => special,
        CharacterState.walk => walk,
      };

  factory PlayerSpriteSettings.fromCharacterType(CharacterType characterType) =>
      switch (characterType) {
        CharacterType.fireWizard => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.1, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.25, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.2, Anchor.bottomLeft),
          idle: StateSpriteSettings(0.25, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.2, Anchor.bottomCenter),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomCenter),
          walk: StateSpriteSettings(0.18, Anchor.bottomCenter),
        ),
        CharacterType.lightningWizard => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomCenter),
          attack3: StateSpriteSettings(0.1, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.25, Anchor.bottomCenter),
          hurt: StateSpriteSettings(0.2, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomRight),
          jump: StateSpriteSettings(0.2, Anchor.bottomCenter),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomCenter),
        ),
        CharacterType.wandererMagician => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.1, Anchor.bottomCenter),
          dead: StateSpriteSettings(0.28, Anchor.bottomCenter),
          hurt: StateSpriteSettings(0.2, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomRight),
          jump: StateSpriteSettings(0.16, Anchor.bottomCenter),
          run: StateSpriteSettings(0.08, Anchor.bottomRight),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomCenter),
        ),
        CharacterType.skeletonWarrior => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.1, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomCenter),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.25, Anchor.bottomCenter),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.5, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.skeletonArcher => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomCenter),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.28, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomCenter),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.25, Anchor.bottomCenter),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.skeletonSpearman => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.2, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.25, Anchor.bottomCenter),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.3, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.knight1 => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.25, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.2, Anchor.bottomLeft),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.knight2 => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.25, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.2, Anchor.bottomLeft),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.knight3 => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.25, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.2, Anchor.bottomLeft),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.samurai => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.25, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.18, Anchor.bottomLeft),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.samuraiArcher => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.25, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.15, Anchor.bottomLeft),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
        CharacterType.samuraiCommander => PlayerSpriteSettings._(
          attack1: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSettings(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSettings(0.25, Anchor.bottomLeft),
          dead: StateSpriteSettings(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSettings(0.3, Anchor.bottomCenter),
          idle: StateSpriteSettings(0.3, Anchor.bottomCenter),
          jump: StateSpriteSettings(0.2, Anchor.bottomLeft),
          run: StateSpriteSettings(0.08, Anchor.bottomCenter),
          special: StateSpriteSettings(0.1, Anchor.bottomLeft),
          walk: StateSpriteSettings(0.18, Anchor.bottomLeft),
        ),
      };
}

class StateSpriteSettings {
  final double time;
  final Anchor anchor;

  StateSpriteSettings(this.time, this.anchor);
}
