import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_event.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DraggableItemsBloc
    extends Bloc<DraggableItemsEvent, DraggableItemsState> {
  DraggableItemsBloc({final DraggableItemsState? initialState})
      : super(initialState ?? DraggableItemsState$Idle()) {
    on<DraggableItemsEvent>((event, emitter) => switch (event) {
          DraggableItemsEvent$StartDragging draggingEvent => emitter(DraggableItemsState$Dragged(draggingEvent.itemInventoryIndex)),
          DraggableItemsEvent$StopDragging() => emitter(DraggableItemsState$Idle()),
        });
  }
}
