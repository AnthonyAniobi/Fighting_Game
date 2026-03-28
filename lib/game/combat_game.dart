import 'dart:math';

import 'package:fighting_game/components/custom_hitbox_components.dart';
import 'package:fighting_game/components/fighter_component.dart';
import 'package:fighting_game/components/platform_component.dart';
import 'package:fighting_game/components/health_bar_ui.dart';
import 'package:fighting_game/components/hud_controls.dart';
import 'package:fighting_game/components/projectile_component.dart';
import 'package:fighting_game/constants/game_constants.dart';
import 'package:fighting_game/controllers/fighting_game_controller.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:fighting_game/enums/fighter_id.dart';
import 'package:fighting_game/enums/game_over_status.dart';
import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/models/box_position.dart';
import 'package:fighting_game/udp/udp_transport.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class CombatGame extends FlameGame with HasCollisionDetection {
  CombatGame({
    required this.player1Character,
    required this.player2Character,
    required this.backgroundImage,
    required this.gameType,
  });

  final CharacterType player1Character;
  final CharacterType player2Character;
  final String backgroundImage;
  final GameType gameType;
  late FighterComponent _fighter1;
  late FighterComponent _fighter2;
  late FightingGameController _controller;
  late UdpTransport _transport;
  late final SpriteComponent background;
  late final HealthBarUi fighter1Health;
  late final HealthBarUi fighter2Health;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAllImages();

    // init game constants
    // set ground level based on screen size
    GameConstants.groundLevel = size.y - 50;
    GameConstants.screenSize = size;

    background = SpriteComponent()
      ..sprite = Sprite(Flame.images.fromCache(backgroundImage))
      ..size = size;
    add(background);

    GameConstants.scaleFactor = size.y / (1.7 * 128);
    // GameConstants.scaleFactor = 3;
    final double healthbarHeight = size.y / 10;

    _fighter1 =
        FighterComponent(
            player1Character,
            fighterId: FighterId.player1,
            direction: Direction.right,
          )
          ..position = Vector2(100, 0)
          ..scale = Vector2.all(GameConstants.scaleFactor);

    _fighter2 =
        FighterComponent(
            player2Character,
            fighterId: FighterId.player2,
            direction: Direction.left,
          )
          ..position = Vector2(size.x - 450, GameConstants.groundLevel)
          ..scale = Vector2.all(GameConstants.scaleFactor);

    _transport = UdpTransport(serverHost: '192.168.1.100');
    await _transport.bind();

    _controller = FightingGameController(
      player1: _fighter1,
      player2: _fighter2,
      transport: _transport,
      localPlayerId: 'player1',
    );

    final _controls = HudControls(
      localFighterId: FighterId.player1,
      localCharacterType: player1Character,
      onCommand: _controller.dispatch,
    );
    fighter1Health = HealthBarUi(
      player: _fighter1,
      maxWidth: size.x * 0.35,
      maxHeight: min(35, healthbarHeight),
      direction: Direction.left,
    )..position = Vector2(20, 30);
    fighter2Health =
        HealthBarUi(
            player: _fighter2,
            maxWidth: size.x * 0.35,
            maxHeight: min(35, healthbarHeight),
          )
          ..position = Vector2(size.x - 20, 30)
          ..anchor = Anchor.topRight;

    final ground = PlatformComponent(
      position: Vector2(0, GameConstants.groundLevel),
      size: Vector2(GameConstants.screenSize.x, 20),
    );

    final wall1 = PlatformComponent(
      position: Vector2(0, 0),
      size: Vector2(5, GameConstants.groundLevel),
    );

    final wall2 = PlatformComponent(
      position: Vector2(size.x - 5, 0),
      size: Vector2(5, GameConstants.groundLevel),
    );

    // final pauseButton = pauseButtonComponent();

    // pauseButton.position = Vector2(size.x / 2, 30);
    // if (gameType == GameType.singlePlayer) {
    //   add(pauseButton);
    // }

    // add(playerHealth);
    // add(enemyHealth);
    addAll([
      _fighter1,
      // _fighter2,
      _controller,
      _controls,
      fighter1Health,
      fighter2Health,
      ground,
      wall1,
      wall2,
    ]);

    // add buttons
    // final button = ActionsControlComponents(player: player);
    // button.position = Vector2(10, size.y - button.height - 10);

    // final movementButton = MovementControlComponents(player: player);
    // movementButton.position = Vector2(
    //   size.x - movementButton.width - 10,
    //   size.y - movementButton.height - 10,
    // );
    // add(button);
    // add(movementButton);

    if (gameType == GameType.singlePlayer) {
      // add(BotControllerComponent(player: player, bot: enemy));
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

    // if (player.lives > enemy.lives) {
    //   winner = player.playerType;
    //   loser = enemy.playerType;
    //   status = GameOverStatus.win;
    // } else if (enemy.lives > player.lives) {
    //   winner = enemy.playerType;
    //   loser = player.playerType;
    //   status = GameOverStatus.win;
    // } else {
    //   // in case of a draw, just set player 1 as the winner for display purposes
    //   winner = player.playerType;
    //   loser = enemy.playerType;
    //   status = GameOverStatus.draw;
    // }

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
