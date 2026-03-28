import 'package:fighting_game/components/charachter_sprite_animations.dart';
import 'package:fighting_game/components/player_select_tile.dart';
import 'package:fighting_game/components/selection_button.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/game/background_selection_scene.dart';
import 'package:fighting_game/models/player_sprite_settings.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart'
    show Paint, Colors, PaintingStyle, MaterialPageRoute, Navigator;

class SelectPlayerScene extends FlameGame {
  SelectPlayerScene({required this.gameType});

  final GameType gameType;

  CharacterType? player1Character;
  CharacterType? player2Character;
  CharacterType? selectedCharacter;

  late SpriteAnimationComponent player1Preview;
  late SpriteAnimationComponent player2Preview;

  late final SelectionButton buttonComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load assets and initialize the select player screen
    await loadAllSprites();

    final background = SpriteComponent()
      ..sprite = Sprite(
        Flame.images.fromCache('Background/selection_background.png'),
      )
      ..size = size;

    add(background);

    // add players
    player1Preview = SpriteAnimationComponent(
      position: Vector2(20, size.y - 20),
      anchor: Anchor.bottomLeft,
      priority: 10,
      scale: Vector2(2, 2),
    );
    add(player1Preview);
    player2Preview = SpriteAnimationComponent(
      position: Vector2(size.x - 20, size.y - 20),
      anchor: Anchor.bottomLeft,
      priority: 10,
      scale: Vector2(2, 2),
    );
    player2Preview.flipHorizontally();
    add(player2Preview);

    // add a grid of all characters for selection
    final characterTypes = CharacterType.values;
    final gridColumns = 6;
    final gridSpacing = 20.0;
    final characterSize = Vector2(
      (size.x * 0.8) / gridColumns - gridSpacing,
      (size.x * 0.8) / gridColumns - gridSpacing,
    );
    final totalGridWidth =
        (characterSize.x * gridColumns) + (gridSpacing * (gridColumns - 1));
    final startX = (size.x - totalGridWidth) / 2;
    final startY = 30;

    for (int i = 0; i < characterTypes.length; i++) {
      final characterType = characterTypes[i];
      //
      final column = i % gridColumns;
      final row = (i / gridColumns).floor();
      final position = Vector2(
        startX + column * (characterSize.x + gridSpacing),
        startY + row * (characterSize.y + gridSpacing),
      );

      final playerComponent = PlayerSelectTile(
        characterType: characterType,
        position: position,
        size: characterSize,
      );
      add(playerComponent);
    }

    // add start button
    buttonComponent = SelectionButton(onPressed: choosePlayer);
    buttonComponent.position = Vector2(size.x / 2, size.y - 50);
    buttonComponent.text = "Select Player";
    buttonComponent.hide();
    add(buttonComponent);
  }

  void selectCharacter(CharacterType characterType) {
    selectedCharacter = characterType;
    final spriteSettings = PlayerSpriteSettings.fromCharacterType(
      characterType,
    );
    final idleSettiings = spriteSettings.getSettingsForState(
      CharacterState.idle,
    );

    buttonComponent.show();
    // preview selection
    if (player1Character == null) {
      player1Preview.animation = playerAnimationFromSpriteSheet(
        characterType: characterType,
        characterState: CharacterState.idle,
        stepTime: idleSettiings.time,
        loop: true,
      );
    } else if (player2Character == null) {
      player2Preview.animation = playerAnimationFromSpriteSheet(
        characterType: characterType,
        characterState: CharacterState.idle,
        stepTime: idleSettiings.time,
        loop: true,
      );
    }
  }

  void choosePlayer() {
    if (selectedCharacter != null) {
      if (player1Character == null) {
        player1Character = selectedCharacter;
        buttonComponent.hide();
      } else {
        player2Character = selectedCharacter;
        _startGame();
      }
      selectedCharacter = null;
    }
  }

  void _startGame() {
    Navigator.of(buildContext!).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BackgroundSelectionScene(
          player1Character: player1Character!,
          player2Character: player2Character!,
          gameType: gameType,
        ),
      ),
    );
  }
}
