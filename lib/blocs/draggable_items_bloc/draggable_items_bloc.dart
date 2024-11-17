import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_event.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DraggableItemsBloc
    extends Bloc<DraggableItemsEvent, DraggableItemsState> {
  DraggableItemsBloc({final DraggableItemsState? initialState})
      : super(initialState ?? DraggableItemsState$Idle()) {
    on<DraggableItemsEvent>((event, emitter) => switch (event) {
          DraggableItemsEvent$StartDragging() => _startDragging(event, emitter),
          DraggableItemsEvent$StopDragging() => _stopDragging(event, emitter),
        });
  }

  void _startDragging(DraggableItemsEvent$StartDragging event,
      Emitter<DraggableItemsState> emitter) {
    emitter(DraggableItemsState$Dragged(event.itemInventoryIndex));
  }

  void _stopDragging(DraggableItemsEvent$StopDragging event,
      Emitter<DraggableItemsState> emitter) {
    emitter(DraggableItemsState$Idle());
  }
}
