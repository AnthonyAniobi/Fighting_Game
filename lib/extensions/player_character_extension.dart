import 'package:fighting_game/components/player_character.dart';
import 'package:fighting_game/constants/game_constants.dart';

extension PlayerCharacterExtension on PlayerCharacter {
  bool get isAtBoundary {
    if (position.x <= spriteAnimation.size.x ||
        (position.x + spriteAnimation.size.x) >= GameConstants.screenSize.x) {
      return true;
    }
    return false;
  }
}
