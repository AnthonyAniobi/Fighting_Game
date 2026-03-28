import 'package:fighting_game/enums/character_state.dart';

enum AttackType {
  none,
  one,
  two,
  three,
  special;

  CharacterState get toState => switch (this) {
    one => CharacterState.attack1,
    two => CharacterState.attack2,
    three => CharacterState.attack3,
    special => CharacterState.special,
    none => CharacterState.idle,
  };
}
