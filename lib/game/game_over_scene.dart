import 'package:fighting_game/components/charachter_sprite_animations.dart';
import 'package:fighting_game/components/selection_button.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/game_over_status.dart';
import 'package:fighting_game/game/select_player_scene.dart';
import 'package:fighting_game/models/player_sprite_settings.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart'
    show TextStyle, Colors, FontWeight, Navigator, MaterialPageRoute;

class GameOverScene extends FlameGame {
  final GameOverStatus status;
  final CharacterType winner;
  final CharacterType loser;

  GameOverScene({
    required this.status,
    required this.winner,
    required this.loser,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await loadAllSprites();
    // Load assets and initialize the game over screen
    final background = SpriteComponent()
      ..sprite = Sprite(
        Flame.images.fromCache('Background/selection_background.png'),
      )
      ..size = size;

    add(background);

    // players
    final winnerSpriteSettings = PlayerSpriteSettings.fromCharacterType(
      winner,
    ).getSettingsForState(CharacterState.idle);

    final winnerAnimation = playerAnimationComponentFromSpriteSheet(
      characterType: winner,
      characterState: CharacterState.idle,
      stepTime: winnerSpriteSettings.time,
      anchor: winnerSpriteSettings.anchor,
      loop: true,
    )..position = Vector2(size.x / 4, size.y - 150);
    winnerAnimation.scale = Vector2(2, 2);

    final looserSpriteSettings = PlayerSpriteSettings.fromCharacterType(
      loser,
    ).getSettingsForState(CharacterState.idle);
    final loserAnimation = playerAnimationComponentFromSpriteSheet(
      characterType: loser,
      characterState: CharacterState.dead,
      stepTime: looserSpriteSettings.time,
      anchor: looserSpriteSettings.anchor,
      loop: false,
    )..position = Vector2(size.x * 3 / 4, size.y - 150);
    loserAnimation.flipHorizontally();
    loserAnimation.scale = Vector2(2, 2);

    add(winnerAnimation);
    add(loserAnimation);

    // Add text components for "You Win", "You Lose", or "Draw"
    final text = switch (status) {
      GameOverStatus.win => 'You Win!',
      GameOverStatus.lose => 'You Lose!',
      GameOverStatus.draw => 'It\'s a Draw!',
    };
    final textComponent =
        TextComponent(
            text: text,
            textRenderer: TextPaint(
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          ..position = Vector2(size.x / 2, 40)
          ..anchor = Anchor.topCenter;
    add(textComponent);

    // Add a button to return to the main menu or restart the game
    // add start button
    final buttonComponent = SelectionButton(onPressed: restartGame);
    buttonComponent.position = Vector2(size.x / 2, size.y - 50);
    buttonComponent.text = "Play Again";
    add(buttonComponent);
  }

  void restartGame() {
    Navigator.of(
      buildContext!,
    ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
