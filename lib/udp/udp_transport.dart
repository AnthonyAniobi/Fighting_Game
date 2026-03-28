import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:fighting_game/enums/attack_type.dart';
import 'package:fighting_game/enums/move_direction.dart';
import 'package:fighting_game/models/player_command/player_input.dart';
import 'package:flame/game.dart';

class UdpTransport {
  static const int clientPort = 0;
  static const int serverPort = 7777;

  RawDatagramSocket? _socket;
  final String serverHost;
  InternetAddress? _serverAddress;

  // Stream that delivers incoming server state to the game loop
  final _stateController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onStateReceived => _stateController.stream;

  UdpTransport({required this.serverHost});

  Future<void> bind() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, clientPort);
    _serverAddress = (await InternetAddress.lookup(serverHost)).first;

    _socket!.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram == null) return;
        _handleIncoming(datagram.data);
      }
    });
  }

  void sendInput(PlayerInput input) {
    if (_socket == null || _serverAddress == null) return;
    final bytes = input.encode();
    _socket!.send(bytes, _serverAddress!, serverPort);
  }

  // Build and send input in one call — seq auto-increments
  void sendRawInput({
    required String playerId,
    required Vector2 move,
    required bool sprint,
    required bool jump,
    required int seq,
    required AttackType attack,
  }) {
    sendInput(
      PlayerInput(
        playerId: playerId,
        seq: seq,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        moveX: move.x.round(),
        moveY: move.y.round(),
        sprint: sprint,
        attack: attack,
      ),
    );
  }

  void _handleIncoming(Uint8List data) {
    try {
      final decoded = PlayerInput.decode(data);
      // Game state arrives as JSON from server — push to stream
      _stateController.add({'raw': decoded});
    } catch (_) {
      // Malformed packet — discard silently
    }
  }

  void dispose() {
    _socket?.close();
    _stateController.close();
  }
}
