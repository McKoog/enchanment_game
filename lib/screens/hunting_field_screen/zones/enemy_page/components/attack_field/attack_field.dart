import 'dart:math';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/game_stock_data/stock_items.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/enemy_hp_bar.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/weapon_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttackField extends StatefulWidget {
  const AttackField(
      {super.key,
      required this.width,
      required this.enemy,
      required this.weapon});

  final double width;
  final Enemy enemy;
  final Weapon weapon;

  @override
  State<AttackField> createState() => _AttackFieldState();
}

class _AttackFieldState extends State<AttackField> {
  late int currentHP;
  late double widthOfOneHP;

  void onTapAttack() {
    if (currentHP > widget.weapon.lowerDamage) {
      int randDamage = Random().nextInt(widget.weapon.higherDamage + 1);
      if (randDamage < widget.weapon.lowerDamage) {
        randDamage = widget.weapon.lowerDamage;
      }
      int randCrit = Random().nextInt(101);
      bool isCrit = randCrit <= widget.weapon.critRate;
      if (isCrit) {
        double additionalCritDamageAmount =
            randDamage * (widget.weapon.critPower / 100);
        randDamage += additionalCritDamageAmount.toInt();
      }
      currentHP = currentHP - randDamage;
      if (currentHP > 0) {
        setState(() {});
      } else {
        currentHP = widget.enemy.hp;
        for (var element in widget.enemy.dropList) {
          int rand = Random().nextInt(101);
          if (rand <= element.chance) {
            Item? item;
            bool isWeapon = element.item.type == ItemType.weapon;
            if (isWeapon) {
              Weapon elementWeapon = element.item as Weapon;
              item = getNewStockItem(ItemType.weapon, elementWeapon.weaponType);
            } else {
              item = getNewStockItem(ItemType.scroll);
            }
            if (item != null) {
              if (context
                  .read<InventoryBloc>()
                  .state
                  .inventory
                  .isLastFiveSlots()) {
                if (item.type == ItemType.scroll) {
                  context
                      .read<InventoryBloc>()
                      .add(InventoryEvent$AddItem(item: item));
                }
              } else {
                context
                    .read<InventoryBloc>()
                    .add(InventoryEvent$AddItem(item: item));
              }
            }
          }
        }
        setState(() {});
      }
    } else {
      currentHP = widget.enemy.hp;
      for (var element in widget.enemy.dropList) {
        int rand = Random().nextInt(101);
        if (rand <= element.chance) {
          Item? item = element.item.type == ItemType.weapon
              ? getNewStockItem(ItemType.weapon)
              : getNewStockItem(ItemType.scroll);
          if (item != null) {
            if (context
                .read<InventoryBloc>()
                .state
                .inventory
                .isLastFiveSlots()) {
              if (item.type == ItemType.scroll) {
                context
                    .read<InventoryBloc>()
                    .add(InventoryEvent$AddItem(item: item));
              }
            } else {
              context
                  .read<InventoryBloc>()
                  .add(InventoryEvent$AddItem(item: item));
            }
          }
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    currentHP = widget.enemy.hp;
    widthOfOneHP = (widget.width - 160) / widget.enemy.hp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        EnemyHpBar(
          width: widget.width,
          enemy: widget.enemy,
          widthOfOneHP: widthOfOneHP,
          currentHP: currentHP,
        ),
        Expanded(
          child: InkWell(
              onTap: onTapAttack, child: WeaponField(weapon: widget.weapon)),
        ),
      ],
    );
  }
}
