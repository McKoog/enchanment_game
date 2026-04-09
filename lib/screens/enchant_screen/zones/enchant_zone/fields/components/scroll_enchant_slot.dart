import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/theme/app_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/slot_particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollEnchantSlot extends StatelessWidget {
  const ScrollEnchantSlot(
      {super.key,
      required this.sideSize,
      this.insertedItem,
      required this.scrollType,
      required this.currentEnchantState});

  final double sideSize;
  final Item? insertedItem;
  final ScrollType scrollType;
  final EnchantState currentEnchantState;

  @override
  Widget build(BuildContext context) {
    final enchantBloc = context.read<EnchantBloc>();
    final currentSideSize = (sideSize - 50) / 4;

    return DragTarget<Item>(
      onAcceptWithDetails: (details) {
        if (insertedItem == null && currentEnchantState is EnchantState$Idle) {
          if (scrollType == ScrollType.weapon &&
              details.data.type == ItemType.weapon) {
            enchantBloc.add(EnchantEvent$InsertItem(item: details.data));
          } else if (scrollType == ScrollType.armor &&
              details.data.type == ItemType.armor) {
            enchantBloc.add(EnchantEvent$InsertItem(item: details.data));
          }
        }
      },
      builder: (BuildContext context, List<Item?> candidateData,
          List<dynamic> rejectedData) {
        return SlotParticles(
          slotSideSize: currentSideSize,
          child: AnimatedContainer(
            decoration: switch (currentEnchantState) {
              EnchantState$Result result => result.isSuccess
                  ? AppDecorations.enchantSlotSuccess
                  : AppDecorations.enchantSlotFailed,
              EnchantState$Idle idle => idle.insertedItem == null
                  ? AppDecorations.enchantSlotDefault
                  : AppDecorations.enchantSlotInserted,
              EnchantState$EnchantmentInProgress() =>
                AppDecorations.enchantSlotProgress,
            },
            height: currentSideSize,
            width: currentSideSize,
            duration: Duration(
              milliseconds: switch (currentEnchantState) {
                EnchantState$Idle() => 300,
                EnchantState$EnchantmentInProgress() => 900,
                EnchantState$Result() => 300,
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: insertedItem != null
                  ? Image.asset(insertedItem!.image)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
