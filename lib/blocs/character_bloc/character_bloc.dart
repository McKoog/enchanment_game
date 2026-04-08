import 'dart:async';

import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  Timer? _regenTimer;

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
          CharacterTakeDamage() => _takeDamage(event, emitter),
          CharacterHeal() => _heal(event, emitter),
          CharacterRespawn() => _respawn(event, emitter),
          CharacterStartEscapeCooldown() =>
            _startEscapeCooldown(event, emitter),
          CharacterClearEscapeCooldown() =>
            _clearEscapeCooldown(event, emitter),
          CharacterLoad() => _loadSaved(event, emitter),
        });

    add(CharacterLoad());

    _regenTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is CharacterLoaded) {
        final currentState = state as CharacterLoaded;
        if (currentState.character.currentHealth > 0 &&
            currentState.character.currentHealth <
                currentState.character.baseHealth) {
          add(CharacterHeal(currentState.character.hpRegen));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _regenTimer?.cancel();
    return super.close();
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
    int newSkillPoints = currentState.character.skillPoints + event.spAmount;

    // Helper to get max exp for a given level
    int getMaxExp(int lvl) {
      double exp = 100;
      for (int i = 1; i < lvl; i++) {
        exp *= 1.25;
      }
      return exp.toInt();
    }

    // Level up logic
    while (newExp >= getMaxExp(newLevel)) {
      newExp -= getMaxExp(newLevel);
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

  void _takeDamage(CharacterTakeDamage event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    if (currentState.character.currentHealth <= 0) return;

    int maxDamageBlocked = (event.damage * 0.7).toInt();
    int actualDamageBlocked = currentState.character.defense;

    if (actualDamageBlocked > maxDamageBlocked) {
      actualDamageBlocked = maxDamageBlocked;
    }

    int damageTaken = event.damage - actualDamageBlocked;
    if (damageTaken < 0) {
      damageTaken = 0;
    }

    int newHealth = currentState.character.currentHealth - damageTaken;

    if (newHealth <= 0) {
      newHealth = 0;

      // Apply death penalties
      int newGold = (currentState.character.gold * 0.5).toInt();
      int newSp = currentState.character.skillPoints - 25;
      if (newSp < 0) newSp = 0;

      int totalExp = _getTotalExp(
          currentState.character.level, currentState.character.currentExp);
      int newTotalExp = (totalExp * 0.75).toInt();

      int newLevel = 1;
      int remainingExp = newTotalExp;
      while (remainingExp >= _getMaxExpForLevel(newLevel)) {
        remainingExp -= _getMaxExpForLevel(newLevel);
        newLevel++;
      }

      final newCharacter = currentState.character.copyWith(
        currentHealth: newHealth,
        gold: newGold,
        skillPoints: newSp,
        level: newLevel,
        currentExp: remainingExp,
      );
      emitter(CharacterLoaded(newCharacter));
      _autoSave(newCharacter);
    } else {
      final newCharacter = currentState.character.copyWith(
        currentHealth: newHealth,
      );
      emitter(CharacterLoaded(newCharacter));
      _autoSave(newCharacter);
    }
  }

  int _getMaxExpForLevel(int lvl) {
    double exp = 100;
    for (int i = 1; i < lvl; i++) {
      exp *= 1.25;
    }
    return exp.toInt();
  }

  int _getTotalExp(int level, int currentExp) {
    int total = currentExp;
    for (int l = 1; l < level; l++) {
      total += _getMaxExpForLevel(l);
    }
    return total;
  }

  void _heal(CharacterHeal event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    int newHealth = currentState.character.currentHealth + event.amount;
    if (newHealth > currentState.character.baseHealth) {
      newHealth = currentState.character.baseHealth;
    }

    final newCharacter = currentState.character.copyWith(
      currentHealth: newHealth,
    );
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _respawn(CharacterRespawn event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      currentHealth: currentState.character.baseHealth,
      deathCooldownEndTime: DateTime.now().add(const Duration(seconds: 15)),
    );
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _startEscapeCooldown(
      CharacterStartEscapeCooldown event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      escapeCooldownEndTime: DateTime.now().add(const Duration(seconds: 5)),
    );
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _clearEscapeCooldown(
      CharacterClearEscapeCooldown event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      clearEscapeCooldown: true,
    );
    emitter(CharacterLoaded(newCharacter));
    _autoSave(newCharacter);
  }

  void _loadSaved(CharacterLoad event, Emitter<CharacterState> emitter) async {
    final savedCharacter = await SaveService.loadCharacter();
    if (savedCharacter != null) {
      emitter(CharacterLoaded(savedCharacter));
    }
  }

  void _autoSave(Character character) {
    SaveService.saveCharacter(character);
  }
}
