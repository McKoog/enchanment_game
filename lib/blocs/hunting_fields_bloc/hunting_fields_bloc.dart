import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_state.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldsBloc extends Bloc<HuntingFieldEvent, HuntingFieldState> {
  HuntingFieldsBloc(
      {required final Weapon initialWeapon,
      required final Enemy initialEnemy})
      : super(HuntingFieldState$PickPhase(
            selectedEnemy: initialEnemy, selectedWeapon: initialWeapon)) {
    on<HuntingFieldEvent>((event, emitter) => switch (event) {
          HuntingFieldEvent$SelectEnemy() => _selectEnemy(event, emitter),
          HuntingFieldEvent$SelectWeapon() => _selectWeapon(event, emitter),
          HuntingFieldEvent$StartHunting() => _startHunting(event, emitter),
          HuntingFieldEvent$StopHunting() => _stopHunting(event, emitter),
        });
  }

  void _selectEnemy(HuntingFieldEvent$SelectEnemy event,
      Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$PickPhase(
        selectedWeapon: state.selectedWeapon, selectedEnemy: event.enemy));
  }

  void _selectWeapon(HuntingFieldEvent$SelectWeapon event,
      Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$PickPhase(
        selectedWeapon: event.weapon, selectedEnemy: state.selectedEnemy));
  }

  void _startHunting(HuntingFieldEvent$StartHunting event,
      Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$HuntingStarted(
        selectedWeapon: state.selectedWeapon,
        selectedEnemy: state.selectedEnemy));
  }

  void _stopHunting(
      HuntingFieldEvent$StopHunting event, Emitter<HuntingFieldState> emitter) {
    emitter(HuntingFieldState$PickPhase(
        selectedWeapon: state.selectedWeapon,
        selectedEnemy: state.selectedEnemy));
  }
}
