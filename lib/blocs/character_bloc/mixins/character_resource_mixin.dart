import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/services/leveling_service.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CharacterResourceMixin on Bloc<CharacterEvent, CharacterState> {
  void addExp(CharacterAddExp event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;

    int newExp = currentState.character.currentExp + event.amount;
    int newLevel = currentState.character.level;
    int newSkillPoints = currentState.character.skillPoints + event.spAmount;

    // Level up logic handled using the separated LevelingService
    while (newExp >= LevelingService.getMaxExpForLevel(newLevel)) {
      newExp -= LevelingService.getMaxExpForLevel(newLevel);
      newLevel++;
      newSkillPoints++; // Give 1 skill point per level up
    }

    final newCharacter = currentState.character.copyWith(
      currentExp: newExp,
      level: newLevel,
      skillPoints: newSkillPoints,
    );

    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }

  void addGold(CharacterAddGold event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      gold: currentState.character.gold + event.amount,
    );
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }

  void addSkillPoints(CharacterAddSkillPoints event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      skillPoints: currentState.character.skillPoints + event.amount,
    );
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }
}
