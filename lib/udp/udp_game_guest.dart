import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:fighting_game/constants/game_constants.dart';

class UdpGameGuest {
  RawDatagramSocket? _udpSocket;

  Future<void> joinByCode(String code) async {
    _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 45678);

    await for (final event in _udpSocket!) {
      if (event == RawSocketEvent.read) {
        final dg = _udpSocket!.receive()!;
        final data = jsonDecode(utf8.decode(dg.data));

        if (data['code'] == code) {
          // Found the host! Connect via TCP
          final hostIP = dg.address.address;
          final hostPort = data['port'];
          _udpSocket!.close();

          final socket = await Socket.connect(hostIP, hostPort);
          print('Connected to host at $hostIP:$hostPort');
          // start sending game data via socket
          break;
        }
      }
    }
  }

  void sendTo(String text, InternetAddress address, int port) {
    final bytes = utf8.encode('$MESSAGE_PREFIX$text');
    _udpSocket?.send(bytes, address, port);
  }
}
