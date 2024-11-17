import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ScrollEnchantSlot extends StatelessWidget {
  const ScrollEnchantSlot(
      {super.key,
      required this.sideSize,
      this.insertedWeapon,
      required this.currentEnchantState});

  final double sideSize;
  final Weapon? insertedWeapon;
  final EnchantState currentEnchantState;

  @override
  Widget build(BuildContext context) {
    final enchantBloc = context.read<EnchantBloc>();

    final currentSideSize = insertedWeapon == null
        ? (sideSize - 50) / 4
        : currentEnchantState is EnchantState$EnchantmentInProgress
            ? (sideSize - 50) / 4
            : (sideSize - 50) / 1.6;

    return DragTarget<Item>(
      onAcceptWithDetails: (details) {
        if (details.data.type == ItemType.weapon && insertedWeapon == null) {
          enchantBloc
              .add(EnchantEvent$InsertWeapon(weapon: details.data as Weapon));
        }
      },
      builder: (BuildContext context, List<Item?> candidateData,
          List<dynamic> rejectedData) {
        return AnimatedContainer(
            decoration: switch (currentEnchantState) {
              EnchantState$Result result => result.isSuccess
                  ? scrollEnchantSlotSuccessDecoration
                  : scrollEnchantSlotFailedDecoration,
              _ => scrollEnchantSlotDecoration
            },
            height: currentSideSize,
            width: currentSideSize,
            duration: Duration(
              milliseconds: switch (currentEnchantState) {
                EnchantState$Idle() => 200,
                EnchantState$EnchantmentInProgress() => 1200,
                EnchantState$Result() => 500,
              },
            ),
            child: insertedWeapon != null
                ? insertedWeapon!.isSvgAsset
                    ? SvgPicture.asset(insertedWeapon!.image)
                    : Image.asset(insertedWeapon!.image)
                : null);
      },
    );
  }
}
