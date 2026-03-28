import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/game/combat_game.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/widgets/game_over_modal.dart';
import 'package:fighting_game/widgets/pause_game_modal.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BackgroundSelectionScene extends StatefulWidget {
  final CharacterType player1Character;
  final CharacterType player2Character;
  final GameType gameType;

  const BackgroundSelectionScene({
    required this.player1Character,
    required this.player2Character,
    required this.gameType,
    super.key,
  });

  @override
  State<BackgroundSelectionScene> createState() =>
      _BackgroundSelectionSceneState();
}

class _BackgroundSelectionSceneState extends State<BackgroundSelectionScene> {
  List<String> backgroundOptions = [
    'assets/images/Background/bg1.png',
    'assets/images/Background/bg2.png',
    'assets/images/Background/bg3.png',
    'assets/images/Background/bg4.png',
    'assets/images/Background/bg5.png',
    'assets/images/Background/bg6.png',
    'assets/images/Background/bg7.png',
  ];

  late final PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/Background/selection_background.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: backgroundOptions.length,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.symmetric(
                      horizontal: pageIndex == index ? 20 : 50,
                      vertical: pageIndex == index ? 20 : 50,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 10,
                          offset: const Offset(10, 15),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(backgroundOptions[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectBackground(backgroundOptions[index]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Select Background ${index + 1}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectBackground(String backgroundPath) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameWidget(
          game: FightingGame(
            player1Character: widget.player1Character,
            player2Character: widget.player2Character,
            backgroundImage: backgroundPath.replaceAll('assets/images/', ''),
            gameType: widget.gameType,
          ),
          overlayBuilderMap: {
            'winnerDialog': (context, FightingGame game) =>
                GameOverModal(game: game),
            'pauseGame': (context, FightingGame game) =>
                PauseGameModal(game: game),
          },
        ),
      ),
    );
  }
}
