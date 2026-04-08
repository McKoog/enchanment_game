import 'package:enchantment_game/models/character.dart';

sealed class CharacterState {
  const CharacterState(this.character);
  final Character character;
}

class CharacterLoading extends CharacterState {
  CharacterLoading() : super(Character());
}

class CharacterLoaded extends CharacterState {
  const CharacterLoaded(super.character);
}
