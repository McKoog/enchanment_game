import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_event.dart';
import 'package:enchantment_game/blocs/particle_settings_bloc/particle_setting_bloc.dart';
import 'package:enchantment_game/blocs/particle_settings_bloc/particle_setting_event.dart';
import 'package:enchantment_game/blocs/particle_settings_bloc/particle_setting_state.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_button.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/scroll_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollField extends StatelessWidget {
  const ScrollField({super.key, required this.sideSize, required this.scroll});

  final double sideSize;
  final Scroll scroll;

  @override
  Widget build(BuildContext context) {
    final enchantBloc = context.read<EnchantBloc>();
    final inventoryBloc = context.read<InventoryBloc>();
    final itemInfoBloc = context.read<ItemInfoBloc>();

    return BlocListener<EnchantBloc, EnchantState>(
      listenWhen: (oldState, newState) {
        return oldState is EnchantState$EnchantmentInProgress &&
            newState is EnchantState$Result;
      },
      listener: (context, state) {
        if (state is EnchantState$Result) {
          if (state.isSuccess) {
            // inventoryBloc.add(InventoryEvent$RemoveItem(item: scroll));
            // inventoryBloc.add(InventoryEvent$RefreshInventory());
          } else {
            // inventoryBloc.add(InventoryEvent$RemoveItem(item: scroll));
            // inventoryBloc
            //     .add(InventoryEvent$RemoveItem(item: state.insertedWeapon!));
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
                  _ParticleSlider(),
                  _ScrollControls(
                    sideSize: sideSize,
                    enchantState: state,
                    onEnchant: () {
                      if (state.insertedWeapon != null) {
                        enchantBloc.add(EnchantEvent$StartEnchanting(
                            weapon: state.insertedWeapon!));
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

class _ParticleSlider extends StatefulWidget {
  const _ParticleSlider({super.key});

  @override
  State<_ParticleSlider> createState() => _ParticleSliderState();
}

class _ParticleSliderState extends State<_ParticleSlider> {
  late double _sliderValue;
  late bool _isOptimized;

  @override
  void didChangeDependencies() {
    _sliderValue =
        context.read<ParticleSettingBloc>().state.particlesCount.toDouble();
    _isOptimized = context.read<ParticleSettingBloc>().state.isOptimized;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
          Text(
            "Particles: ${_sliderValue.floor()}",
            style: scrollButtonsTextDecoration,
          ),
          Slider(
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              context
                  .read<ParticleSettingBloc>()
                  .add(ParticleSettingEvent$ChangeCount(count: value.floor()));
            },
            min: 250,
            max: 25000,
            activeColor: Colors.grey.shade200.withOpacity(0.3),
            inactiveColor: Colors.black.withOpacity(0.2),
            thumbColor: Colors.grey.shade600,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isOptimized = !_isOptimized;
                });
                context
                    .read<ParticleSettingBloc>()
                    .add(ParticleSettingEvent$ChangeOptimized(
                      isOptimized: _isOptimized,
                    ));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: _isOptimized,
                      checkColor: Colors.grey.shade200.withOpacity(0.6),
                      activeColor: Colors.grey.shade200.withOpacity(0.4),
                      fillColor: WidgetStateProperty.all(
                          Colors.grey.shade200.withOpacity(0.3)),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                      onChanged: (value) {
                        setState(() {
                          _isOptimized = value!;
                        });
                        context
                            .read<ParticleSettingBloc>()
                            .add(ParticleSettingEvent$ChangeOptimized(
                              isOptimized: value ?? false,
                            ));
                      }),
                  Text("Optimization", style: scrollButtonsTextDecoration),
                ],
              ),
            ),
          )
        ],
      ),
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
