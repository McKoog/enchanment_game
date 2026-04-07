import 'dart:async';

import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/game_stock_data/enchant_config.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/utils/game_random.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantBloc extends Bloc<EnchantEvent, EnchantState> {
  Timer? _timer;
  int _runToken = 0;

  EnchantBloc() : super(EnchantState$Idle()) {
    on<EnchantEvent>((event, emitter) => switch (event) {
          EnchantEvent$InsertWeapon() => _insertWeapon(event, emitter),
          EnchantEvent$StartEnchanting() => _startEnchanting(event, emitter),
          EnchantEvent$FinishEnchanting() => _finishEnchanting(event, emitter),
          EnchantEvent$CancelEnchanting() => _cancelEnchanting(event, emitter),
        });
  }

  void _insertWeapon(
      EnchantEvent$InsertWeapon event, Emitter<EnchantState> emitter) {
    emitter(EnchantState$Idle(insertedWeapon: event.weapon));
  }

  void _startEnchanting(
      EnchantEvent$StartEnchanting event, Emitter<EnchantState> emitter) {
    _runToken += 1;
    final localToken = _runToken;
    _timer?.cancel();

    emitter(EnchantState$EnchantmentInProgress(insertedWeapon: event.weapon));

    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (isClosed) return;
      if (localToken != _runToken) return;
      add(EnchantEvent$FinishEnchanting(
          weapon: event.weapon, runToken: localToken));
    });
  }

  void _finishEnchanting(
      EnchantEvent$FinishEnchanting event, Emitter<EnchantState> emitter) {
    if (event.runToken != _runToken) return;
    _timer?.cancel();
    _timer = null;

    final successChance =
        EnchantConfig.getSuccessChance(event.weapon.enchantLevel);
    if (GameRandom.chance(successChance)) {
      emitter(EnchantState$Result(
          insertedWeapon: _enchantWeapon(event.weapon), isSuccess: true));
    } else {
      emitter(
          EnchantState$Result(insertedWeapon: event.weapon, isSuccess: false));
    }
  }

  void _cancelEnchanting(
      EnchantEvent$CancelEnchanting event, Emitter<EnchantState> emitter) {
    _runToken += 1;
    _timer?.cancel();
    _timer = null;
    emitter(EnchantState$Idle(insertedWeapon: state.insertedWeapon));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    _runToken += 1;
    return super.close();
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
