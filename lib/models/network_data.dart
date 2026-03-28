import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/direction.dart';
import 'package:flame/game.dart';

class NetworkData {
  final Vector2? playerPosition;
  final Vector2? opponentPosition;
  final PlayerInputData? playerInputData;

  NetworkData({
    this.playerPosition,
    this.opponentPosition,
    this.playerInputData,
  });

  factory NetworkData.fromJson(Map<String, dynamic> json) {
    return NetworkData(
      playerPosition: json['playerPosition'] != null
          ? Vector2(json['playerPosition']['x'], json['playerPosition']['y'])
          : null,
      opponentPosition: json['opponentPosition'] != null
          ? Vector2(
              json['opponentPosition']['x'],
              json['opponentPosition']['y'],
            )
          : null,
      playerInputData: json['playerInputData'] != null
          ? PlayerInputData.fromJson(json['playerInputData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerPosition': playerPosition != null
          ? {'x': playerPosition!.x, 'y': playerPosition!.y}
          : null,
      'opponentPosition': opponentPosition != null
          ? {'x': opponentPosition!.x, 'y': opponentPosition!.y}
          : null,
      'playerInputData': playerInputData?.toJson(),
    };
  }
}

class PlayerInputData {
  final CharacterState attackState;
  final bool isPowerup;
  final bool isMoving;
  final Direction direction;

  PlayerInputData({
    required this.attackState,
    required this.isPowerup,
    required this.isMoving,
    required this.direction,
  });

  factory PlayerInputData.fromJson(Map<String, dynamic> json) {
    return PlayerInputData(
      attackState: CharacterState.fromString(json['attackState']),
      isPowerup: json['isPowerup'],
      isMoving: json['isMoving'],
      direction: Direction.fromString(json['direction']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attackState': attackState.id,
      'isPowerup': isPowerup,
      'isMoving': isMoving,
      'direction': direction.id,
    };
  }
}
