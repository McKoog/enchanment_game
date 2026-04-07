import 'package:enchantment_game/blocs/item_info_bloc/item_info_event.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_state.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemInfoBloc extends Bloc<ItemInfoEvent, ItemInfoState> {
  int _viewToken = 0;

  ItemInfoBloc() : super(ItemInfoState$Idle()) {
    on<ItemInfoEvent>((event, emitter) => switch (event) {
          ItemInfoEvent$ShowInfo() => _showInfo(event, emitter),
          ItemInfoEvent$CloseInfo() => _closeInfo(event, emitter),
          ItemInfoEvent$MarkScrollEnchantFinished() =>
            _markScrollEnchantFinished(event, emitter),
        });
  }

  int _nextToken() {
    _viewToken += 1;
    return _viewToken;
  }

  void _showInfo(ItemInfoEvent$ShowInfo event, Emitter<ItemInfoState> emitter) {
    if (state is ItemInfoState$Showed) {
      final showedState = state as ItemInfoState$Showed;
      if (showedState.inventoryIndex == event.inventoryIndex) {
        if (showedState.item is Scroll && showedState.scrollEnchantFinished) {
          emitter(
            ItemInfoState$Showed(
              item: event.item,
              inventoryIndex: event.inventoryIndex,
              viewToken: _nextToken(),
              scrollEnchantFinished: false,
            ),
          );
          return;
        } else {
          emitter(ItemInfoState$Idle());
          return;
        }
      }
    }

    emitter(
      ItemInfoState$Showed(
        item: event.item,
        inventoryIndex: event.inventoryIndex,
        viewToken: _nextToken(),
        scrollEnchantFinished: false,
      ),
    );
  }

  void _markScrollEnchantFinished(ItemInfoEvent$MarkScrollEnchantFinished event,
      Emitter<ItemInfoState> emitter) {
    if (state is! ItemInfoState$Showed) return;
    final showedState = state as ItemInfoState$Showed;
    if (showedState.inventoryIndex != event.inventoryIndex) return;
    if (showedState.item is! Scroll) return;

    emitter(
      ItemInfoState$Showed(
        item: showedState.item,
        inventoryIndex: showedState.inventoryIndex,
        viewToken: showedState.viewToken,
        scrollEnchantFinished: true,
      ),
    );
  }

  void _closeInfo(
      ItemInfoEvent$CloseInfo event, Emitter<ItemInfoState> emitter) {
    emitter(ItemInfoState$Idle());
  }
}
