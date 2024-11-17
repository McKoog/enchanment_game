sealed class DraggableItemsState {}

class DraggableItemsState$Idle extends DraggableItemsState {}

class DraggableItemsState$Dragged extends DraggableItemsState {
  DraggableItemsState$Dragged(this.itemInventoryIndex);

  final int itemInventoryIndex;
}
