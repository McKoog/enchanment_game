import 'dart:async';

import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/game_stock_data/enchant_config.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/services/sound_service.dart';
import 'package:enchantment_game/utils/game_random.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantBloc extends Bloc<EnchantEvent, EnchantState> {
  Timer? _timer;
  int _runToken = 0;

  EnchantBloc() : super(EnchantState$Idle()) {
    on<EnchantEvent>((event, emitter) => switch (event) {
          EnchantEvent$InsertItem() => _insertItem(event, emitter),
          EnchantEvent$StartEnchanting() => _startEnchanting(event, emitter),
          EnchantEvent$FinishEnchanting() => _finishEnchanting(event, emitter),
          EnchantEvent$CancelEnchanting() => _cancelEnchanting(event, emitter),
          EnchantEvent$ExtractItem() => _extractItem(event, emitter),
        });
  }

  void _insertItem(
      EnchantEvent$InsertItem event, Emitter<EnchantState> emitter) {
    emitter(EnchantState$Idle(insertedItem: event.item));
  }

  void _startEnchanting(
      EnchantEvent$StartEnchanting event, Emitter<EnchantState> emitter) {
    _runToken += 1;
    final localToken = _runToken;
    _timer?.cancel();

    emitter(EnchantState$EnchantmentInProgress(insertedItem: event.item));

    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (isClosed) return;
      if (localToken != _runToken) return;
      add(EnchantEvent$FinishEnchanting(
          item: event.item, runToken: localToken));
    });
  }

  void _finishEnchanting(
      EnchantEvent$FinishEnchanting event, Emitter<EnchantState> emitter) {
    if (event.runToken != _runToken) return;
    _timer?.cancel();
    _timer = null;

    final item = event.item;
    int enchantLevel = 0;
    if (item is Weapon) {
      enchantLevel = item.enchantLevel;
    } else if (item is Armor) {
      enchantLevel = item.enchantLevel;
    }

    final successChance = EnchantConfig.getSuccessChance(enchantLevel);
    if (GameRandom.chance(successChance)) {
      SoundService().playEnchantSuccessSound();
      emitter(EnchantState$Result(
          insertedItem: _enchantItem(item), isSuccess: true));
    } else {
      SoundService().playEnchantFailSound();
      emitter(EnchantState$Result(insertedItem: item, isSuccess: false));
    }
  }

  void _cancelEnchanting(
      EnchantEvent$CancelEnchanting event, Emitter<EnchantState> emitter) {
    _runToken += 1;
    _timer?.cancel();
    _timer = null;
    emitter(EnchantState$Idle(insertedItem: state.insertedItem));
  }

  void _extractItem(
      EnchantEvent$ExtractItem event, Emitter<EnchantState> emitter) {
    _runToken += 1;
    _timer?.cancel();
    _timer = null;
    emitter(EnchantState$Idle(insertedItem: null));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    _runToken += 1;
    return super.close();
  }

  Item _enchantItem(Item item) {
    if (item is Weapon) {
      final bonus = EnchantConfig.bonusByWeaponType[item.weaponType] ??
          const EnchantBonus();

      item.enchantLevel += 1;
      item.lowerDamage += bonus.lowerDamageBonus;
      item.higherDamage += bonus.higherDamageBonus;
      item.critRate += bonus.critRateBonus;
      item.critPower += bonus.critPowerBonus;
      return item;
    } else if (item is Armor) {
      final bonus = EnchantConfig.bonusByArmorType[item.armorType] ??
          const EnchantBonusArmor();

      item.enchantLevel += 1;
      item.defense += bonus.defenseBonus;
      return item;
    }
    return item;
  }
}
