import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:fighting_game/constants/game_constants.dart';
import 'package:flutter/material.dart';

class UdpGameHost extends ChangeNotifier {
  RawDatagramSocket? _udpSocket;
  ServerSocket? _server;
  final String roomCode;
  bool hasJoined = false;

  UdpGameHost(this.roomCode);

  Future<void> start() async {
    // 1. Start TCP server for actual game data
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, 4567);
    _server!.listen((client) {
      print('Guest connected: ${client.remoteAddress}');
      // handle game communication here
    });

    // 2. Broadcast UDP beacon so guests can find us
    _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _udpSocket!.broadcastEnabled = true;

    Timer.periodic(Duration(seconds: 1), (_) {
      final payload = jsonEncode({'code': roomCode, 'port': 4567});
      _udpSocket!.send(
        utf8.encode(payload),
        InternetAddress('255.255.255.255'), // LAN broadcast
        45678, // discovery port guests listen on
      );
    });
  }

  void stop() {
    _udpSocket?.close();
    _server?.close();
  }

  void sendTo(String text, InternetAddress address, int port) {
    final bytes = utf8.encode('$MESSAGE_PREFIX$text');
    _udpSocket?.send(bytes, address, port);
  }
}
