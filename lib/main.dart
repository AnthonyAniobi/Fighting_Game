import 'dart:io';

import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/game/combat_game.dart';
import 'package:fighting_game/widgets/game_over_modal.dart';
import 'package:fighting_game/widgets/pause_game_modal.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (Platform.isIOS || Platform.isAndroid) {
    Flame.device.fullScreen();
    Flame.device.setLandscape();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avatar Clash',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // home: const HomeScreen(),
      home: GameWidget(
        game: CombatGame(
          player1Character: CharacterType.skeletonArcher,
          player2Character: CharacterType.knight1,
          backgroundImage: 'Background/bg1.png',
          gameType: GameType.singlePlayer,
        ),
        // overlayBuilderMap: {
        //   'winnerDialog': (context, CombatGame game) =>
        //       GameOverModal(game: game),
        //   'pauseGame': (context, CombatGame game) => PauseGameModal(game: game),
        // },
      ),
    );
  }
}
