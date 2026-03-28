import 'package:fighting_game/enums/game_type.dart';
import 'package:fighting_game/enums/network_role.dart';
import 'package:fighting_game/game/select_player_scene.dart';
import 'package:fighting_game/network/network_manager.dart';
import 'package:fighting_game/widgets/app_button.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ConnectPlayerScreen extends StatefulWidget {
  const ConnectPlayerScreen({super.key});

  @override
  State<ConnectPlayerScreen> createState() => _ConnectPlayerScreenState();
}

class _ConnectPlayerScreenState extends State<ConnectPlayerScreen> {
  NetworkRole? role;
  String? hostIp;
  TextEditingController ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NetworkManager().connectionStream.listen((data) {
      if (data) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return GameWidget(
                game: SelectPlayerScene(gameType: GameType.multiplayer),
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/Background/selection_background.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          width: size.width * 0.8,
          height: size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(150),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Builder(
            builder: (context) {
              if (role == null) {
                return gameRoomOptions();
              } else if (role == NetworkRole.host) {
                return hostGameOptions();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Go Back'),
                        ),
                      ],
                    ),
                    Text(
                      'Enter IP address of the host to join the game room:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: ipController,
                        onSubmitted: (value) => joinRoomWithCode(value.trim()),
                        decoration: InputDecoration(
                          hintText: 'Host IP Address',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    AppButton(
                      text: 'Join Game Room',
                      onPressed: () =>
                          joinRoomWithCode(ipController.text.trim()),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Column hostGameOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Go Back'),
            ),
          ],
        ),

        Text(
          'Game room created!\nShare this IP with your friend to join:\n$hostIp',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        SizedBox(height: 20),
        CircularProgressIndicator(color: Colors.orange),
        SizedBox(height: 20),
        AppButton(text: 'Cancel', onPressed: cancelHosting),
        SizedBox(height: 20),
      ],
    );
  }

  Column gameRoomOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Go Back'),
            ),
          ],
        ),

        Text(
          'Create or join a game room to play with your friend!',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 20),
        AppButton(text: 'Create Game Room', onPressed: createRoom),
        const SizedBox(height: 20),
        AppButton(text: 'Join Game Room', onPressed: joinRoom),
      ],
    );
  }

  Future<void> createRoom() async {
    hostIp = await NetworkManager().hostServer();
    setState(() {
      role = NetworkRole.host;
    });
  }

  Future<void> joinRoom() async {
    setState(() {
      role = NetworkRole.client;
    });
  }

  Future<void> joinRoomWithCode(String code) async {
    NetworkManager().connectToServer(code);
  }

  void cancelHosting() {
    NetworkManager().dispose();
    setState(() {
      role = null;
      hostIp = null;
    });
  }
}
