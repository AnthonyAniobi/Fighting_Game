import 'package:fighting_game/game/combat_game.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:flutter/material.dart';

class GameOverModal extends StatelessWidget {
  final FightingGame game;
  const GameOverModal({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    bool youWon = game.enemy.lives < game.player.lives;
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.black45.withAlpha(100))),
        Center(
          child: Material(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    youWon ? "Winner !" : "You Lost!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ),
                        (_) => false,
                      );
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
                      'Restart Game',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
