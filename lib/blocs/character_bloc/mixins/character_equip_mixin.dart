import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CharacterEquipMixin on Bloc<CharacterEvent, CharacterState> {
  void equipWeapon(CharacterEquipWeapon event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(equippedWeapon: event.weapon);
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }

  void unequipWeapon(CharacterUnequipWeapon event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(clearWeapon: true);
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }

  void equipArmor(CharacterEquipArmor event, Emitter<CharacterState> emitter) {
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
    SaveService.saveCharacter(newCharacter);
  }

  void unequipArmor(CharacterUnequipArmor event, Emitter<CharacterState> emitter) {
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
    SaveService.saveCharacter(newCharacter);
  }
}
