import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/enemy_hp_bar.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/weapon_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/enemy_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/enemy_header.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/player_hp_bar.dart';
import 'package:enchantment_game/services/combat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnemyPage extends StatefulWidget {
  const EnemyPage({
    super.key,
    required this.width,
    required this.enemy,
    required this.weapon,
  });

  final double width;
  final Enemy enemy;
  final Weapon weapon;

  @override
  State<EnemyPage> createState() => _EnemyPageState();
}

class _EnemyPageState extends State<EnemyPage> {
  bool _showDropList = false;
  late int _enemyCurrentHP;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Item> _dropHistory = [];

  @override
  void initState() {
    super.initState();
    _enemyCurrentHP = widget.enemy.hp;
  }

  void _onAttack() {
    final result = CombatService.calculateDamage(widget.weapon);
    setState(() {
      _enemyCurrentHP -= result.damage;
    });

    if (_enemyCurrentHP <= 0) {
      _enemyCurrentHP = widget.enemy.hp;
      final loot = CombatService.generateLoot(widget.enemy);
      final inventoryBloc = context.read<InventoryBloc>();

      for (final item in loot.items) {
        if (!inventoryBloc.state.inventory.isFull) {
          inventoryBloc.add(InventoryEvent$AddItem(item: item));
        }
        _dropHistory.insert(0, item);
        _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));
      }
    }
  }

  String _getItemName(Item item) {
    if (item is Weapon) return item.name;
    if (item is Armor) return item.name;
    if (item is Scroll) return item.name;
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterBloc>().state.character;

    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/background/forest_enemy_background.png'), fit: BoxFit.cover)),
      width: widget.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;

          final headerHeight = availableHeight * 0.10;
          final playerHpHeight = availableHeight * 0.05;
          final enemyHpHeight = availableHeight * 0.05;
          final enemyFieldHeight = availableHeight * 0.4;

          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: EnemyHeader(
                      width: widget.width,
                      enemy: widget.enemy,
                      heightFactor: headerHeight,
                      onTitleTap: () {
                        setState(() {
                          _showDropList = !_showDropList;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: playerHpHeight,
                    child: PlayerHpBar(
                      width: widget.width,
                      currentHP: character.health,
                      maxHP: character.health,
                      heightFactor: playerHpHeight,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Recent Loot:',
                    style: const TextStyle(fontSize: 14, color: Colors.yellow, fontFamily: "PT Sans"),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: _dropHistory.length,
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 100), // padding right for weapon slot
                        itemBuilder: (context, index, animation) {
                          return SlideTransition(
                            position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(_dropHistory[index].image, width: 40, height: 40),
                                  const SizedBox(width: 12),
                                  Text(
                                    _getItemName(_dropHistory[index]),
                                    style: const TextStyle(color: Colors.white, fontFamily: 'PT Sans'),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: enemyHpHeight,
                    child: EnemyHpBar(
                      width: widget.width,
                      enemy: widget.enemy,
                      widthOfOneHP: (widget.width - 200) / widget.enemy.hp,
                      currentHP: _enemyCurrentHP,
                      heightFactor: enemyHpHeight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      if (details.data == 'weapon') {
                        _onAttack();
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return SizedBox(
                        height: enemyFieldHeight,
                        child: EnemyField(
                          width: widget.width,
                          assetImageLink: widget.enemy.image,
                          availableHeight: enemyFieldHeight,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              // Weapon Slot
              Positioned(
                right: 16,
                top: headerHeight - 8,
                child: Draggable<String>(
                  data: 'weapon',
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: WeaponField(weapon: widget.weapon),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: WeaponField(weapon: widget.weapon),
                    ),
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: WeaponField(weapon: widget.weapon),
                  ),
                ),
              ),
              // Drop List Overlay
              if (_showDropList)
                Positioned(
                  top: headerHeight,
                  left: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(52, 52, 52, 0.95),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.enemy.dropList.map((drop) {
                          final item =
                              ItemRegistry.createItem(drop.itemType, weaponType: drop.weaponType, armorType: drop.armorType, scrollType: drop.scrollType);
                          return ListTile(
                            leading: Image.asset(item.image, width: 40, height: 40),
                            title: Text(_getItemName(item), style: const TextStyle(color: Colors.white, fontFamily: 'PT Sans')),
                            trailing: Text('${drop.chance}%', style: const TextStyle(color: Colors.yellow, fontFamily: 'PT Sans')),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
