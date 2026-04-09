import 'dart:async';

import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/blocs/character_bloc/mixins/character_combat_mixin.dart';
import 'package:enchantment_game/blocs/character_bloc/mixins/character_equip_mixin.dart';
import 'package:enchantment_game/blocs/character_bloc/mixins/character_resource_mixin.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState>
    with CharacterEquipMixin, CharacterResourceMixin, CharacterCombatMixin {
  Timer? _regenTimer;

  CharacterBloc({Character? initialCharacter})
      : super(CharacterLoaded(initialCharacter ?? Character())) {
    on<CharacterEvent>((event, emitter) => switch (event) {
          CharacterEquipWeapon() => equipWeapon(event, emitter),
          CharacterUnequipWeapon() => unequipWeapon(event, emitter),
          CharacterEquipArmor() => equipArmor(event, emitter),
          CharacterUnequipArmor() => unequipArmor(event, emitter),
          CharacterAddExp() => addExp(event, emitter),
          CharacterAddGold() => addGold(event, emitter),
          CharacterAddSkillPoints() => addSkillPoints(event, emitter),
          CharacterTakeDamage() => takeDamage(event, emitter),
          CharacterHeal() => healCharacter(event, emitter),
          CharacterRespawn() => respawn(event, emitter),
          CharacterStartEscapeCooldown() => startEscapeCooldown(event, emitter),
          CharacterClearEscapeCooldown() => clearEscapeCooldown(event, emitter),
          CharacterLoad() => _loadSaved(event, emitter),
          CharacterReset() => _reset(event, emitter),
        });

    add(CharacterLoad());

    _regenTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is CharacterLoaded) {
        final currentState = state as CharacterLoaded;
        if (currentState.character.currentHealth > 0 &&
            currentState.character.currentHealth <
                currentState.character.health) {
          add(CharacterHeal(currentState.character.totalHpRegen));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _regenTimer?.cancel();
    return super.close();
  }

  void _loadSaved(CharacterLoad event, Emitter<CharacterState> emitter) async {
    final savedCharacter = await SaveService.loadCharacter();
    if (savedCharacter != null) {
      emitter(CharacterLoaded(savedCharacter));
    }
  }

  void _reset(CharacterReset event, Emitter<CharacterState> emitter) {
    final newChar = Character();
    emitter(CharacterLoaded(newChar));
    SaveService.saveCharacter(newChar);
  }
}
