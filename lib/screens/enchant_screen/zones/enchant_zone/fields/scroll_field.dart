import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/data_providers/animation_providers.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/game_stock_items/game_stock_items.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_button.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollField extends ConsumerWidget {
  const ScrollField({super.key, required this.sideSize, required this.scroll});

  final double sideSize;
  final Scroll scroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enchantBloc = context.read<EnchantBloc>();
    final inventoryBloc = context.read<InventoryBloc>();

    return BlocListener<EnchantBloc,EnchantState>(
      listenWhen: (oldState,newState){
        return oldState is EnchantState$EnchantmentInProgress && newState is EnchantState$Result;
      },
      listener: (context,state){
        if (state is EnchantState$Result) {
          if (state.isSuccess) {
            inventoryBloc.add(InventoryEvent$RemoveItem(item: scroll));
            inventoryBloc.add(InventoryEvent$RefreshInventory());
          } else {
            inventoryBloc.add(InventoryEvent$RemoveItem(item: scroll));
            inventoryBloc
                .add(InventoryEvent$RemoveItem(item: state.insertedWeapon));
          }
        }
      },
      child: BlocBuilder<EnchantBloc, EnchantState>(
          bloc: enchantBloc,
          builder: (context, state) {
            Weapon? insertedWeapon = state.insertedWeapon;

            if (state is EnchantState$Result && !state.isSuccess) {
                insertedWeapon = null;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ScrollHeader(
                      insertedWeapon: insertedWeapon,
                      isEnchantSucceed:
                          state is EnchantState$Result && state.isSuccess,
                      sideSize: sideSize,
                      scrollName: scroll.name),
                  Expanded(
                      child: _ScrollContent(
                    sideSize: sideSize,
                    enchantState: state,
                    insertedWeapon: insertedWeapon,
                    scrollDescription: scroll.description,
                  )),
                  _ScrollControls(
                    sideSize: sideSize,
                    enchantState: state,
                    onEnchant: () {
                      if (state.insertedWeapon != null) {
                        enchantBloc.add(EnchantEvent$StartEnchanting(
                            weapon: state.insertedWeapon!));
                      }
                    },
                    onCancel: () {
                      ref
                          .read(showWeaponInfoField.notifier)
                          .update((state) => false);
                      ref
                          .read(showScrollField.notifier)
                          .update((state) => !state);
                    },
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
      {required this.insertedWeapon,
      required this.isEnchantSucceed,
      required this.sideSize,
      required this.scrollName});

  final Weapon? insertedWeapon;
  final bool isEnchantSucceed;
  final double sideSize;
  final String scrollName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sideSize / 14,
      child: insertedWeapon != null
          ? AutoSizeText(
              insertedWeapon!.enchantLevel > 0
                  ? "${insertedWeapon!.name} +${insertedWeapon!.enchantLevel}"
                  : insertedWeapon!.name,
              style: weaponNameDecoration,
            )
          : isEnchantSucceed
              ? AutoSizeText(
                  scrollName,
                  style: scrollNameDecoration,
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
    required this.insertedWeapon,
    required this.enchantState,
    required this.scrollDescription,
  });

  final double sideSize;
  final EnchantState enchantState;
  final Weapon? insertedWeapon;
  final String scrollDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        insertedWeapon == null && enchantState is EnchantState$Idle
            ? SizedBox(
                height: sideSize / 10,
                child: AutoSizeText(
                  "Put your weapon in the slot",
                  style: scrollHintDecoration,
                  maxLines: 1,
                ))
            : SizedBox.shrink(),
        ScrollEnchantSlot(
          insertedWeapon: insertedWeapon,
          currentEnchantState: enchantState,
          sideSize: sideSize,
        ),
        insertedWeapon == null && enchantState is EnchantState$Idle
            ? SizedBox(
                height: sideSize / 10,
                child: AutoSizeText(
                  scrollDescription,
                  style: scrollInfoTextDecoration,
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
                      ? enchantSuccessTextDecoration
                      : enchantFailTextDecoration)
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
