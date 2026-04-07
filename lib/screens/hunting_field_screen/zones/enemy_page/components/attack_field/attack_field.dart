import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/enemy_hp_bar.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/weapon_field.dart';
import 'package:enchantment_game/services/combat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttackField extends StatefulWidget {
  const AttackField({
    super.key,
    required this.width,
    required this.enemy,
    required this.weapon,
    this.availableHeight,
  });

  final double width;
  final Enemy enemy;
  final Weapon weapon;

  /// Available height for the entire attack field section.
  final double? availableHeight;

  @override
  State<AttackField> createState() => _AttackFieldState();
}

class _AttackFieldState extends State<AttackField> {
  late int currentHP;
  late double widthOfOneHP;

  void onTapAttack() {
    final result = CombatService.calculateDamage(widget.weapon);
    currentHP -= result.damage;

    if (currentHP <= 0) {
      // Enemy killed — reset HP and generate loot
      currentHP = widget.enemy.hp;
      final loot = CombatService.generateLoot(widget.enemy);
      final inventoryBloc = context.read<InventoryBloc>();

      for (final item in loot.items) {
        if (!inventoryBloc.state.inventory.isFull) {
          inventoryBloc.add(InventoryEvent$AddItem(item: item));
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    currentHP = widget.enemy.hp;
    widthOfOneHP = (widget.width - 160) / widget.enemy.hp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use available height to determine HP bar proportions.
    final double? ah = widget.availableHeight;

    // HP bar gets ~25% of attack field height, weapon gets the rest.
    final double hpBarHeight = ah != null ? (ah * 0.25).clamp(40, 80) : 80;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: hpBarHeight,
          child: EnemyHpBar(
            width: widget.width,
            enemy: widget.enemy,
            widthOfOneHP: widthOfOneHP,
            currentHP: currentHP,
            heightFactor: hpBarHeight,
          ),
        ),
        Expanded(
          child: InkWell(
              onTap: onTapAttack, child: WeaponField(weapon: widget.weapon)),
        ),
      ],
    );
  }
}
