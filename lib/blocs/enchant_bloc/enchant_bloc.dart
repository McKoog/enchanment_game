import 'dart:async';

import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/game_stock_data/enchant_config.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/utils/game_random.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantBloc extends Bloc<EnchantEvent, EnchantState> {
  EnchantBloc() : super(EnchantState$Idle()) {
    on<EnchantEvent>((event, emitter) => switch (event) {
          EnchantEvent$InsertWeapon() => _insertWeapon(event, emitter),
          EnchantEvent$StartEnchanting() => _startEnchanting(event, emitter),
        });
  }

  void _insertWeapon(
      EnchantEvent$InsertWeapon event, Emitter<EnchantState> emitter) {
    emitter(EnchantState$Idle(insertedWeapon: event.weapon));
  }

  void _startEnchanting(
      EnchantEvent$StartEnchanting event, Emitter<EnchantState> emitter) async {
    emitter(EnchantState$EnchantmentInProgress(insertedWeapon: event.weapon));
    await Future.delayed(Duration(milliseconds: 1200), () {
      final successChance =
          EnchantConfig.getSuccessChance(event.weapon.enchantLevel);
      if (GameRandom.chance(successChance)) {
        emitter(EnchantState$Result(
            insertedWeapon: _enchantWeapon(event.weapon), isSuccess: true));
      } else {
        emitter(EnchantState$Result(
            insertedWeapon: event.weapon, isSuccess: false));
      }
    });
  }

  Weapon _enchantWeapon(Weapon weapon) {
    final bonus = EnchantConfig.bonusByWeaponType[weapon.weaponType] ??
        const EnchantBonus();

    weapon.enchantLevel += 1;
    weapon.lowerDamage += bonus.lowerDamageBonus;
    weapon.higherDamage += bonus.higherDamageBonus;
    weapon.critRate += bonus.critRateBonus;
    weapon.critPower += bonus.critPowerBonus;
    return weapon;
  }
}
