import 'dart:convert';

import 'package:fighting_game/enums/attack_type.dart';

class PlayerInput {
  final String playerId;
  final int seq; // monotonically increasing
  final int timestamp;
  final int moveX;
  final int moveY;
  final bool sprint;
  final AttackType attack; // only non-none on the frame it's pressed

  const PlayerInput({
    required this.playerId,
    required this.seq,
    required this.timestamp,
    required this.moveX,
    required this.moveY,
    required this.sprint,
    required this.attack,
  });

  Map<String, dynamic> toJson() => {
    'id': playerId,
    'seq': seq,
    'ts': timestamp,
    'mx': moveX,
    'my': moveY,
    'sp': sprint ? 1 : 0,
    'at': attack.index, // 0=none, 1-4=attack types
  };

  factory PlayerInput.fromJson(Map<String, dynamic> j) => PlayerInput(
    playerId: j['id'],
    seq: j['seq'],
    timestamp: j['ts'],
    moveX: j['mx'],
    moveY: j['my'],
    sprint: j['sp'] == 1,
    attack: AttackType.values[j['at']],
  );

  // Compact binary-ish encoding: JSON but minimal keys
  List<int> encode() => utf8.encode(jsonEncode(toJson()));

  static PlayerInput decode(List<int> bytes) =>
      PlayerInput.fromJson(jsonDecode(utf8.decode(bytes)));
}
