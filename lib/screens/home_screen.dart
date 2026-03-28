import 'package:fighting_game/change_notifiers/upgrade_notifier.dart';
import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/game/select_player_scene.dart';
import 'package:fighting_game/screens/app_credits_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    UpgradeNotifier().checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UpgradeNotifier.instance,
      builder: (context, _) {
        showUpdateModal();
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Background/selection_background.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                const Row(),
                Text(
                  'Avatar Clash',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                selectionButton(
                  text: "Multiple Player",
                  onPressed: () => startGame(GameType.multiplayer),
                ),
                const SizedBox(height: 20),
                selectionButton(
                  text: "Play with Bot",
                  onPressed: () => startGame(GameType.singlePlayer),
                ),
                const SizedBox(height: 40),
                const Spacer(),
                TextButton(
                  onPressed: appCredits,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('App Credits'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  ElevatedButton selectionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void startGame(GameType gameType) {
    if (gameType == GameType.singlePlayer) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              GameWidget(game: SelectPlayerScene(gameType: gameType)),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Multiplayer Mode'),
            content: Text(
              'Multiplayer mode is not implemented yet. \nWe are working tirelessly to get this ready as soon as possible',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // Navigator.of(
      //   context,
      // ).push(MaterialPageRoute(builder: (context) => ConnectPlayerScreen()));
    }
  }

  void appCredits() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => AppCreditsScreen()));
  }

  void showUpdateModal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UpgradeNotifier().shouldShowModal) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Update Available'),
              content: Text(
                'A new update is available please upgrade the app to enjoy our added features',
              ),
              actions: [
                if (!UpgradeNotifier().hasMajorUpdate)
                  TextButton(
                    onPressed: () {
                      UpgradeNotifier().markUpdateModalShown();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),

                ElevatedButton(
                  onPressed: () {
                    UpgradeNotifier().launchStore();
                    UpgradeNotifier().markUpdateModalShown();
                    Navigator.of(context).pop();
                  },
                  child: Text("Upgrade"),
                ),
              ],
            );
          },
        );
      }
    });
  }
}
