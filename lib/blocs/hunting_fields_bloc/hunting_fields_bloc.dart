import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_state.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldsBloc extends Bloc<HuntingFieldEvent, HuntingFieldState> {
  HuntingFieldsBloc(
      {required final Weapon initialWeapon,
      required final Monster initialMonster})
      : super(HuntingFieldState$PickPhase(
            selectedMonster: initialMonster, selectedWeapon: initialWeapon)) {
    on<HuntingFieldEvent>((event, emitter) => switch (event) {
          HuntingFieldEvent$SelectMonster() => _selectMonster(event, emitter),
          HuntingFieldEvent$SelectWeapon() => _selectWeapon(event, emitter),
          HuntingFieldEvent$StartHunting() => _startHunting(event, emitter),
          HuntingFieldEvent$StopHunting() => _stopHunting(event, emitter),
        });
  }

  void _selectMonster(HuntingFieldEvent$SelectMonster event,
      Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$PickPhase(
        selectedWeapon: state.selectedWeapon, selectedMonster: event.monster));
  }

  void _selectWeapon(HuntingFieldEvent$SelectWeapon event,
      Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$PickPhase(
        selectedWeapon: event.weapon, selectedMonster: state.selectedMonster));
  }

  void _startHunting(HuntingFieldEvent$StartHunting event,
      Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$HuntingStarted(
        selectedWeapon: state.selectedWeapon,
        selectedMonster: state.selectedMonster));
  }

  void _stopHunting(
      HuntingFieldEvent$StopHunting event, Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$PickPhase(
        selectedWeapon: state.selectedWeapon,
        selectedMonster: state.selectedMonster));
  }
}
