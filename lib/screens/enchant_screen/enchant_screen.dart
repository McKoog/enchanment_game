import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_bloc.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_state.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_event.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/equipped_items_overlay.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/enchant_zone.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/inventory_zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantScreen extends StatelessWidget {
  const EnchantScreen({super.key, this.width});

  /// If provided, uses this fixed width. Otherwise, fills available space.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemInfoBloc(),
        ),
        BlocProvider(
          create: (context) => EquipOverlayBloc(),
        ),
        BlocProvider(
          create: (context) => EnchantBloc(),
        ),
      ],
      child: SafeArea(child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final effectiveWidth = width ?? constraints.maxWidth;
        return Container(
          width: effectiveWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.3,
              image: AssetImage('assets/background/town_center_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(children: [
                SizedBox(
                  height: constraints.maxHeight / 2,
                  width: effectiveWidth,
                  child: EnchantZone(
                      height: constraints.maxHeight / 2,
                      width: effectiveWidth,
                      maxHeight: constraints.maxHeight),
                ),
                Container(
                  height: constraints.maxHeight / 2,
                  width: effectiveWidth,
                  clipBehavior: Clip.none,
                  child: InventoryZone(
                      height: constraints.maxHeight / 2, width: effectiveWidth),
                )
              ]),
              BlocBuilder<EquipOverlayBloc, EquipOverlayState>(
                builder: (context, overlayState) {
                  if (overlayState is EquipOverlayState$Visible) {
                    final overlayType = overlayState.overlayType;

                    final sideSize = (constraints.maxHeight / 2) - 20;
                    final slotSize = (sideSize - 40) / 5;
                    final overlayHeight = slotSize + 14;

                    return Positioned(
                      top: (constraints.maxHeight / 2) + 15 - overlayHeight,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: EquippedItemsOverlay(
                          overlayType: overlayType,
                          slotSize: slotSize,
                          onItemInserted: () {
                            context
                                .read<EquipOverlayBloc>()
                                .add(EquipOverlayEvent$Hide());
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      })),
    );
  }
}
