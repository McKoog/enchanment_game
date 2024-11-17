sealed class DraggableItemsEvent {}

class DraggableItemsEvent$StartDragging extends DraggableItemsEvent {
  DraggableItemsEvent$StartDragging({required this.itemInventoryIndex});

  final int itemInventoryIndex;
}

class DraggableItemsEvent$StopDragging extends DraggableItemsEvent {}
