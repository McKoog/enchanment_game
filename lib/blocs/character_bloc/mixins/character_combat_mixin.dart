import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/services/leveling_service.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CharacterCombatMixin on Bloc<CharacterEvent, CharacterState> {
  void takeDamage(CharacterTakeDamage event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    if (currentState.character.currentHealth <= 0) return;

    double maxDamageBlocked = event.damage * 0.8;
    double actualDamageBlocked = currentState.character.defense.toDouble();

    if (actualDamageBlocked > maxDamageBlocked) {
      actualDamageBlocked = maxDamageBlocked;
    }

    double damageTaken = event.damage - actualDamageBlocked;
    if (damageTaken < 0) {
      damageTaken = 0;
    }

    int newHealth = currentState.character.currentHealth - damageTaken.toInt();

    if (newHealth <= 0) {
      newHealth = 0;

      // Apply death penalties
      int newGold = (currentState.character.gold * 0.5).toInt();
      int newSp = currentState.character.skillPoints - 25;
      if (newSp < 0) newSp = 0;

      int totalExp = LevelingService.getTotalExp(currentState.character.level, currentState.character.currentExp);
      int newTotalExp = (totalExp * 0.75).toInt();

      int newLevel = 1;
      int remainingExp = newTotalExp;
      while (remainingExp >= LevelingService.getMaxExpForLevel(newLevel)) {
        remainingExp -= LevelingService.getMaxExpForLevel(newLevel);
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
      SaveService.saveCharacter(newCharacter);
    } else {
      final newCharacter = currentState.character.copyWith(
        currentHealth: newHealth,
      );
      emitter(CharacterLoaded(newCharacter));
      SaveService.saveCharacter(newCharacter);
    }
  }

  void healCharacter(CharacterHeal event, Emitter<CharacterState> emitter) {
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
    SaveService.saveCharacter(newCharacter);
  }

  void respawn(CharacterRespawn event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      currentHealth: currentState.character.baseHealth,
      deathCooldownEndTime: DateTime.now().add(const Duration(seconds: 15)),
    );
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }

  void startEscapeCooldown(CharacterStartEscapeCooldown event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      escapeCooldownEndTime: DateTime.now().add(const Duration(seconds: 5)),
    );
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }

  void clearEscapeCooldown(CharacterClearEscapeCooldown event, Emitter<CharacterState> emitter) {
    if (state is! CharacterLoaded) return;
    final currentState = state as CharacterLoaded;
    final newCharacter = currentState.character.copyWith(
      clearEscapeCooldown: true,
    );
    emitter(CharacterLoaded(newCharacter));
    SaveService.saveCharacter(newCharacter);
  }
}
