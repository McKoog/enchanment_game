import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc({Character? initialCharacter})
      : super(CharacterLoaded(initialCharacter ?? Character())) {
    on<CharacterEvent>((event, emitter) => switch (event) {
          CharacterEquipWeapon() => _equipWeapon(event, emitter),
          CharacterUnequipWeapon() => _unequipWeapon(event, emitter),
          CharacterEquipArmor() => _equipArmor(event, emitter),
          CharacterUnequipArmor() => _unequipArmor(event, emitter),
          CharacterAddExp() => _addExp(event, emitter),
          CharacterAddGold() => _addGold(event, emitter),
          CharacterAddSkillPoints() => _addSkillPoints(event, emitter),
          CharacterLoad() => _loadSaved(event, emitter),
        });

    add(CharacterLoad());
  }

  void _equipWeapon(
      CharacterEquipWeapon event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter =
        currentState.character.copyWith(equippedWeapon: event.weapon);
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _unequipWeapon(
      CharacterUnequipWeapon event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(clearWeapon: true);
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _equipArmor(CharacterEquipArmor event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    Character newCharacter = currentState.character;

    switch (event.armor.armorType) {
      case ArmorType.helmet:
        newCharacter = newCharacter.copyWith(equippedHelmet: event.armor);
        break;
      case ArmorType.chestplate:
        newCharacter = newCharacter.copyWith(equippedChestplate: event.armor);
        break;
      case ArmorType.leggings:
        newCharacter = newCharacter.copyWith(equippedLeggings: event.armor);
        break;
      case ArmorType.boots:
        newCharacter = newCharacter.copyWith(equippedBoots: event.armor);
        break;
    }

    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _unequipArmor(
      CharacterUnequipArmor event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    Character newCharacter = currentState.character;

    switch (event.armorType) {
      case ArmorType.helmet:
        newCharacter = newCharacter.copyWith(clearHelmet: true);
        break;
      case ArmorType.chestplate:
        newCharacter = newCharacter.copyWith(clearChestplate: true);
        break;
      case ArmorType.leggings:
        newCharacter = newCharacter.copyWith(clearLeggings: true);
        break;
      case ArmorType.boots:
        newCharacter = newCharacter.copyWith(clearBoots: true);
        break;
    }

    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _addExp(CharacterAddExp event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;

    int newExp = currentState.character.currentExp + event.amount;
    int newLevel = currentState.character.level;
    int newSkillPoints = currentState.character.skillPoints;

    // Level up logic
    while (newExp >= (newLevel * 100)) {
      newExp -= (newLevel * 100);
      newLevel++;
      newSkillPoints++; // Give 1 skill point per level up
    }

    final newCharacter = currentState.character.copyWith(
      currentExp: newExp,
      level: newLevel,
      skillPoints: newSkillPoints,
    );

    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _addGold(CharacterAddGold event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      gold: currentState.character.gold + event.amount,
    );
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _addSkillPoints(
      CharacterAddSkillPoints event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      skillPoints: currentState.character.skillPoints + event.amount,
    );
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  Future<void> _loadSaved(
      CharacterLoad event, Emitter<CharacterState> emitter) async {
    final savedCharacter = await SaveService.loadCharacter();
    if (savedCharacter != null) {
      emitter(CharacterLoaded(savedCharacter));
    }
  }

  void _autoSave(Character character) {
    SaveService.saveCharacter(character);
  }
}
