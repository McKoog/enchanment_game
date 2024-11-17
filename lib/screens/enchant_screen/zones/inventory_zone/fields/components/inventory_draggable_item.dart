import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_event.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_event.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InventoryDraggableItem extends StatelessWidget {
  const InventoryDraggableItem(
      {super.key,
      required this.item,
      required this.inventoryIndex,
      this.isDraggable = true});

  final Item item;
  final int inventoryIndex;
  final bool isDraggable;

  @override
  Widget build(BuildContext context) {
    if (!isDraggable) {
      return item.isSvgAsset
          ? SvgPicture.asset(item.image)
          : Image.asset(item.image);
    }

    final draggableBloc = context.read<DraggableItemsBloc>();
    final itemInfoBloc = context.read<ItemInfoBloc>();

    return Draggable<Item>(
      data: item,
      feedback: item.isSvgAsset
          ? SvgPicture.asset(
              item.image,
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.height / 12,
            )
          : Image.asset(
              item.image,
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.height / 12,
            ),
      childWhenDragging: const SizedBox(),
      onDragStarted: () {
        draggableBloc.add(DraggableItemsEvent$StartDragging(
            itemInventoryIndex: inventoryIndex));
      },
      onDraggableCanceled: (Velocity vel, Offset offset) {
        draggableBloc.add(DraggableItemsEvent$StopDragging());
      },
      onDragEnd: (DraggableDetails details) {
        draggableBloc.add(DraggableItemsEvent$StopDragging());
      },
      child: InkWell(
          onTap: () {
            itemInfoBloc.add(ItemInfoEvent$ShowInfo(item: item));
          },
          child: item.isSvgAsset
              ? SvgPicture.asset(item.image)
              : Image.asset(item.image)),
    );
  }
}
