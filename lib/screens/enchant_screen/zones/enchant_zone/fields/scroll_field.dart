import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_event.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_button.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollField extends StatefulWidget {
  const ScrollField(
      {super.key,
      required this.sideSize,
      required this.scroll,
      required this.inventoryIndex});

  final double sideSize;
  final Scroll scroll;
  final int inventoryIndex;

  @override
  State<ScrollField> createState() => _ScrollFieldState();
}

class _ScrollFieldState extends State<ScrollField> {
  late final EnchantBloc _enchantBloc;

  @override
  void initState() {
    super.initState();
    _enchantBloc = context.read<EnchantBloc>();
  }

  @override
  void dispose() {
    if (_enchantBloc.state is EnchantState$EnchantmentInProgress) {
      _enchantBloc.add(EnchantEvent$CancelEnchanting());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = context.read<InventoryBloc>();
    final itemInfoBloc = context.read<ItemInfoBloc>();

    return BlocListener<EnchantBloc, EnchantState>(
      listenWhen: (oldState, newState) {
        return oldState is EnchantState$EnchantmentInProgress &&
            newState is EnchantState$Result;
      },
      listener: (context, state) {
        if (state is EnchantState$Result) {
          inventoryBloc.add(
              InventoryEvent$ConsumeScroll(slotIndex: widget.inventoryIndex));
          if (!state.isSuccess && state.insertedItem != null) {
            inventoryBloc
                .add(InventoryEvent$RemoveItem(item: state.insertedItem!));
          } else if (state.isSuccess) {
            inventoryBloc.add(InventoryEvent$RefreshInventory());
          }
          itemInfoBloc.add(ItemInfoEvent$MarkScrollEnchantFinished(
              inventoryIndex: widget.inventoryIndex));
        }
      },
      child: BlocBuilder<EnchantBloc, EnchantState>(
          bloc: _enchantBloc,
          builder: (context, state) {
            Item? insertedItem = state.insertedItem;

            if (state is EnchantState$Result && !state.isSuccess) {
              insertedItem = null;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ScrollHeader(
                      insertedItem: insertedItem,
                      isEnchantSucceed:
                          state is EnchantState$Result && state.isSuccess,
                      sideSize: widget.sideSize,
                      scrollName: widget.scroll.name),
                  Expanded(
                      child: _ScrollContent(
                    sideSize: widget.sideSize,
                    enchantState: state,
                    insertedItem: insertedItem,
                    scrollType: widget.scroll.scrollType,
                    scrollDescription: widget.scroll.description,
                  )),
                  _ScrollControls(
                    sideSize: widget.sideSize,
                    enchantState: state,
                    onEnchant: () {
                      if (state.insertedItem != null) {
                        _enchantBloc.add(EnchantEvent$StartEnchanting(
                            item: state.insertedItem!));
                      }
                    },
                    onCancel: () => itemInfoBloc.add(ItemInfoEvent$CloseInfo()),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _ScrollHeader extends StatelessWidget {
  const _ScrollHeader(
      {required this.insertedItem,
      required this.isEnchantSucceed,
      required this.sideSize,
      required this.scrollName});

  final Item? insertedItem;
  final bool isEnchantSucceed;
  final double sideSize;
  final String scrollName;

  @override
  Widget build(BuildContext context) {
    String itemName = '';
    int enchantLevel = 0;
    if (insertedItem is Weapon) {
      itemName = (insertedItem as Weapon).displayName;
      enchantLevel = (insertedItem as Weapon).enchantLevel;
    } else if (insertedItem is Armor) {
      itemName = (insertedItem as Armor).displayName;
      enchantLevel = (insertedItem as Armor).enchantLevel;
    }

    return SizedBox(
      height: sideSize / 14,
      child: insertedItem != null
          ? AutoSizeText(
              enchantLevel > 0 ? "$itemName +$enchantLevel" : itemName,
              style: AppTypography.titleLargeHighlight,
            )
          : isEnchantSucceed
              ? AutoSizeText(
                  scrollName,
                  style: AppTypography.titleMediumPrimary,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                )
              : null,
    );
  }
}

class _ScrollContent extends StatelessWidget {
  const _ScrollContent({
    required this.sideSize,
    required this.insertedItem,
    required this.enchantState,
    required this.scrollType,
    required this.scrollDescription,
  });

  final double sideSize;
  final EnchantState enchantState;
  final Item? insertedItem;
  final ScrollType scrollType;
  final String scrollDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        insertedItem == null && enchantState is EnchantState$Idle
            ? SizedBox(
                height: sideSize / 10,
                child: AutoSizeText(
                  "Put your item in the slot",
                  style: AppTypography.bodyLargeHighlight,
                  maxLines: 1,
                ))
            : SizedBox.shrink(),
        ScrollEnchantSlot(
          insertedItem: insertedItem,
          scrollType: scrollType,
          currentEnchantState: enchantState,
          sideSize: sideSize,
        ),
        insertedItem == null && enchantState is EnchantState$Idle
            ? SizedBox(
                height: sideSize / 10,
                child: AutoSizeText(
                  scrollDescription,
                  style: AppTypography.bodyLargePrimary,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class _ScrollControls extends StatelessWidget {
  const _ScrollControls(
      {required this.sideSize,
      required this.enchantState,
      required this.onCancel,
      required this.onEnchant});

  final double sideSize;
  final EnchantState enchantState;
  final Function() onCancel;
  final Function() onEnchant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sideSize / 10,
      child: enchantState is EnchantState$EnchantmentInProgress
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: EnchantProgressBar(
                parentSize: sideSize,
              ),
            )
          : enchantState is EnchantState$Result
              ? Text(
                  (enchantState as EnchantState$Result).isSuccess
                      ? "Success"
                      : "Failed",
                  style: (enchantState as EnchantState$Result).isSuccess
                      ? AppTypography.titleLargeHighlight
                      : AppTypography.titleLargeDark)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ScrollFieldButton(
                      parentSize: sideSize,
                      caption: "Cancel",
                      onPressed: onCancel,
                    ),
                    ScrollFieldButton(
                      parentSize: sideSize,
                      caption: "Enchant",
                      onPressed: onEnchant,
                    ),
                  ],
                ),
    );
  }
}
