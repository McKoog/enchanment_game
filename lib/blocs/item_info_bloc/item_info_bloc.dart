import 'package:enchantment_game/blocs/item_info_bloc/item_info_event.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemInfoBloc extends Bloc<ItemInfoEvent, ItemInfoState> {
  ItemInfoBloc() : super(ItemInfoState$Idle()) {
    on<ItemInfoEvent>((event, emitter) => switch (event) {
          ItemInfoEvent$ShowInfo() => _showInfo(event, emitter),
          ItemInfoEvent$CloseInfo() => _closeInfo(event, emitter),
        });
  }

  void _showInfo(ItemInfoEvent$ShowInfo event, Emitter<ItemInfoState> emitter) {
    if (state is ItemInfoState$Showed) {
      final showedState = state as ItemInfoState$Showed;
      if (showedState.inventoryIndex == event.inventoryIndex) {
        emitter(ItemInfoState$Idle());
        return;
      }
    }

    emitter(
      ItemInfoState$Showed(
        item: event.item,
        inventoryIndex: event.inventoryIndex,
      ),
    );
  }

  void _closeInfo(
      ItemInfoEvent$CloseInfo event, Emitter<ItemInfoState> emitter) {
    emitter(ItemInfoState$Idle());
  }
}
