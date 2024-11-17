import 'dart:async';
import 'dart:math';

import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantBloc extends Bloc<EnchantEvent,EnchantState>{
  EnchantBloc() : super(EnchantState$Idle()){
    on<EnchantEvent>((event, emitter) => switch(event){
      EnchantEvent$InsertWeapon() => _insertWeapon(event,emitter),
      EnchantEvent$StartEnchanting() => _startEnchanting(event, emitter),
    });
  }

  void _insertWeapon(EnchantEvent$InsertWeapon event, Emitter<EnchantState> emitter){
    emitter(EnchantState$Idle(insertedWeapon: event.weapon));
  }

  void _startEnchanting(EnchantEvent$StartEnchanting event, Emitter<EnchantState> emitter) async {
    emitter(EnchantState$EnchantmentInProgress(insertedWeapon: event.weapon));
    await Future.delayed(Duration(milliseconds: 1200),(){
      int rand = Random().nextInt(101);
      if (rand <= 75) {

        emitter(EnchantState$Result(insertedWeapon: _enchantWeapon(event.weapon),isSuccess: true));
      } else {
        emitter(EnchantState$Result(insertedWeapon: event.weapon,isSuccess: false));
      }
    });
  }

  Weapon _enchantWeapon(Weapon weapon) {
    weapon.enchantLevel += 1;
    if (weapon.weaponType == WeaponType.sword) {
      weapon.lowerDamage += 1;
      weapon.higherDamage += 2;
    } else if (weapon.weaponType == WeaponType.bow) {
      weapon.higherDamage += 3;
    } else if (weapon.weaponType == WeaponType.dagger) {
      weapon.lowerDamage += 1;
      weapon.higherDamage += 1;
    }
    return weapon;
  }
}