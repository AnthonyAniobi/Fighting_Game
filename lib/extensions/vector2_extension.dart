import 'package:flame/game.dart';

extension Vector2Extension on Vector2 {
  bool get isRight => x > 0;
  bool get isLeft => x < 0;
  bool get isJump => y > 0;
  bool get isHorizontalMove => x != 0;
}
