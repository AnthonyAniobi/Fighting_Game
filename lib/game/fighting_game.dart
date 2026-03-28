import 'package:fighting_game/components/actions_control_components.dart';
import 'package:fighting_game/components/bot_controller_component.dart';
import 'package:fighting_game/components/charachter_sprite_animations.dart';
import 'package:fighting_game/components/health_bar_ui.dart';
import 'package:fighting_game/components/movement_control_components.dart';
import 'package:fighting_game/components/player_character.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/enums/game_over_status.dart';
import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/game/game_over_scene.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class FightingGame extends FlameGame with HasCollisionDetection {
  FightingGame({
    required this.player1Character,
    required this.player2Character,
    required this.backgroundImage,
    required this.gameType,
  });

  final CharacterType player1Character;
  final CharacterType player2Character;
  final String backgroundImage;
  final GameType gameType;
  late final SpriteComponent background;
  late final PlayerCharacter player;
  late final PlayerCharacter enemy;
  late final HealthBarUi playerHealth;
  late final HealthBarUi enemyHealth;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await loadAllSprites();

    // init game constants
    // set ground level based on screen size
    GameConstants.groundLevel = size.y - 50;
    GameConstants.screenSize = size;

    background = SpriteComponent()
      ..sprite = Sprite(Flame.images.fromCache(backgroundImage))
      ..size = size;
    add(background);

    player = PlayerCharacter(playerType: player1Character)
      ..position = Vector2(250, GameConstants.groundLevel)
      ..scale = Vector2(1.5, 1.5);

    enemy =
        PlayerCharacter(playerType: player2Character, direction: Direction.left)
          ..position = Vector2(size.x - 250, GameConstants.groundLevel)
          ..scale = Vector2(1.5, 1.5);

    // playerHealth = HealthBarUi(
    //   player: player,
    //   maxWidth: size.x * 0.35,
    //   maxHeight: 35,
    //   direction: Direction.left,
    // )..position = Vector2(20, 30);
    // enemyHealth =
    //     HealthBarUi(player: enemy, maxWidth: size.x * 0.35, maxHeight: 35)
    //       ..position = Vector2(size.x - 20, 30)
    //       ..anchor = Anchor.topRight;

    // final pauseButton = pauseButtonComponent();

    // pauseButton.position = Vector2(size.x / 2, 30);
    // if (gameType == GameType.singlePlayer) {
    //   add(pauseButton);
    // }

    // add(playerHealth);
    // add(enemyHealth);

    add(player);
    add(enemy);
    // add buttons
    final button = ActionsControlComponents(player: player);
    button.position = Vector2(10, size.y - button.height - 10);

    final movementButton = MovementControlComponents(player: player);
    movementButton.position = Vector2(
      size.x - movementButton.width - 10,
      size.y - movementButton.height - 10,
    );
    add(button);
    add(movementButton);

    if (gameType == GameType.singlePlayer) {
      add(BotControllerComponent(player: player, bot: enemy));
    }
  }

  ButtonComponent pauseButtonComponent() {
    return ButtonComponent(
      onPressed: () {
        pauseGame();
      },
      size: Vector2(40, 40),
      button: RectangleComponent(
        size: Vector2(40, 40),
        paint: Paint()
          ..color = Colors.black87
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      ),
      children: [
        RectangleComponent(
          size: Vector2(40, 40),
          paint: Paint()..color = Colors.black87.withAlpha(150),
        ),
        SpriteComponent(
          position: Vector2(20, 20),
          size: Vector2(30, 30),
          anchor: Anchor.center,
          sprite: Sprite(Flame.images.fromCache('Buttons/pause.png')),
        ),
      ],
    );
  }

  void endGame() {
    pauseEngine();
    final CharacterType winner;
    final CharacterType loser;
    final GameOverStatus status;

    if (player.lives > enemy.lives) {
      winner = player.playerType;
      loser = enemy.playerType;
      status = GameOverStatus.win;
    } else if (enemy.lives > player.lives) {
      winner = enemy.playerType;
      loser = player.playerType;
      status = GameOverStatus.win;
    } else {
      // in case of a draw, just set player 1 as the winner for display purposes
      winner = player.playerType;
      loser = enemy.playerType;
      status = GameOverStatus.draw;
    }

    overlays.add('winnerDialog');

    // Navigator.of(buildContext!).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => GameWidget(
    //       game: GameOverScene(status: status, winner: winner, loser: loser),
    //     ),
    //   ),
    // );
  }

  void pauseGame() {
    pauseEngine();
    overlays.add('pauseGame');
  }

  void resumeGame() {
    resumeEngine();
    overlays.remove('pauseGame');
  }
}
