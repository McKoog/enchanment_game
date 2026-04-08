import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/attack_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/enemy_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/enemy_header.dart';
import 'package:flutter/material.dart';

class EnemyPage extends StatelessWidget {
  const EnemyPage({super.key, required this.width, required this.enemy, required this.weapon});

  final double width;
  final Enemy enemy;
  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/background/forest_enemy_background.png'), fit: BoxFit.cover)),
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;

          // Proportional distribution of height:
          // Header: ~12%, EnemyImage: ~45%, AttackField: ~43%
          final headerHeight = availableHeight * 0.12;
          final enemyFieldHeight = availableHeight * 0.45;
          final attackFieldHeight = availableHeight * 0.43;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: headerHeight,
                child: EnemyHeader(width: width, enemy: enemy, heightFactor: headerHeight),
              ),
              SizedBox(
                height: enemyFieldHeight,
                child: EnemyField(
                  width: width,
                  assetImageLink: enemy.image,
                  availableHeight: enemyFieldHeight,
                ),
              ),
              SizedBox(
                height: attackFieldHeight,
                child: AttackField(width: width, enemy: enemy, weapon: weapon, availableHeight: attackFieldHeight),
              ),
            ],
          );
        },
      ),
    );
  }
}
