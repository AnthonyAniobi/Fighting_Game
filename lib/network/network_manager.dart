import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fighting_game/enums/network_role.dart';
import 'package:fighting_game/models/network_data.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  NetworkManager._internal();
  factory NetworkManager() => _instance;
  //
  int port = 4040;
  Socket? _socket;
  ServerSocket? _serverSocket;
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;
  NetworkRole? role;
  //

  void Function(NetworkData)? onDataReceived;

  Future<String> hostServer() async {
    role = NetworkRole.host;
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);

    _serverSocket?.listen((client) {
      _socket = client;
      _connectionController.add(true);
      listenToSocket(_socket!);
    });

    final localIp = await _getLocalIpAddress();
    return localIp;
  }

  Future<void> connectToServer(String ipAddress) async {
    role = NetworkRole.client;
    _socket = await Socket.connect(ipAddress, port);
    _connectionController.add(true);
    listenToSocket(_socket!);
  }

  void sendData(NetworkData data) {
    // send data to the other player
    final jsonData = jsonEncode(data.toJson());
    _socket?.write(jsonData);
  }

  void listenToSocket(Socket socket) {
    socket.listen(
      (data) {
        final jsonData = utf8.decode(data);
        final Map<String, dynamic> decodedData = jsonDecode(jsonData);
        // handle the received data
        final networkData = NetworkData.fromJson(decodedData);
        if (onDataReceived != null) {
          onDataReceived!(networkData);
        }
      },
      onDone: () => _connectionController.add(false),
      onError: (error) => _connectionController.add(false),
    );
  }

  Future<String> _getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (!addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }

  void addDataReceivedListener(void Function(NetworkData) listener) {
    onDataReceived = listener;
  }

  void dispose() {
    _socket?.destroy();
    _serverSocket?.close();
    _connectionController.close();
    _connectionController.close();
  }
}
