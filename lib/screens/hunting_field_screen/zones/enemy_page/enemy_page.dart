import 'dart:async';
import 'dart:math';

import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/decorations/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/gold_item.dart';
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

class _EnemyPageState extends State<EnemyPage>
    with SingleTickerProviderStateMixin {
  bool _showDropList = false;
  late int _enemyCurrentHP;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Item> _dropHistory = [];

  final List<_DamageText> _enemyDamageTexts = [];
  final List<_DamageText> _playerDamageTexts = [];
  final Random _random = Random();

  bool _isWeaponSlotExpanded = false;
  bool _isCombatActive = false;
  bool _isWeaponDragging = false;
  bool _isWeaponOnEnemy = false;

  Timer? _enemyAttackTimer;
  Timer? _playerAttackTimer;
  Timer? _combatStartTimer;
  Timer? _bonusRegenTimer;

  double _attackCooldownProgress = 0.0;
  DateTime? _lastPlayerAttackTime;

  late AnimationController _pulseController;
  int _previousPlayerHealth = -1;

  @override
  void initState() {
    super.initState();
    _enemyCurrentHP = widget.enemy.hp;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bonusRegenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isWeaponSlotExpanded) {
        final characterBloc = context.read<CharacterBloc>();
        if (characterBloc.state is CharacterLoaded) {
          final char = (characterBloc.state as CharacterLoaded).character;
          if (char.currentHealth > 0 && char.currentHealth < char.baseHealth) {
            characterBloc.add(CharacterHeal(4));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _combatStartTimer?.cancel();
    _enemyAttackTimer?.cancel();
    _playerAttackTimer?.cancel();
    _bonusRegenTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _scheduleCombatStart() {
    _combatStartTimer?.cancel();
    _combatStartTimer = Timer(const Duration(milliseconds: 1300), () {
      if (_isWeaponSlotExpanded) {
        _startCombat();
      }
    });
  }

  void _startCombat() {
    if (_isCombatActive) return;
    _isCombatActive = true;
    final intervalMs = (widget.enemy.attackSpeed * 1000).toInt();
    _enemyAttackTimer =
        Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      _enemyAttack();
    });
  }

  void _stopCombat() {
    _combatStartTimer?.cancel();
    _isCombatActive = false;
    _enemyAttackTimer?.cancel();
    _enemyAttackTimer = null;
    _stopPlayerAttack();
  }

  void _enemyAttack() {
    final characterBloc = context.read<CharacterBloc>();
    if (characterBloc.state is! CharacterLoaded) return;

    final charState = characterBloc.state as CharacterLoaded;
    if (charState.character.currentHealth <= 0) return;

    // Calculate damage taking defense into account
    int damageTaken = widget.enemy.attackDamage - charState.character.defense;
    if (damageTaken < 0) damageTaken = 0;

    characterBloc.add(CharacterTakeDamage(widget.enemy.attackDamage));

    final id = UniqueKey().toString();
    setState(() {
      _playerDamageTexts.add(_DamageText(
        id: id,
        damage: damageTaken,
        randomX: 0,
        randomY: _random.nextDouble() * 40 - 20,
      ));
    });
  }

  void _startPlayerAttack() {
    _isWeaponOnEnemy = true;
    _tryPlayerAttack();
    _playerAttackTimer =
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_isWeaponOnEnemy) {
        timer.cancel();
        return;
      }

      final character = context.read<CharacterBloc>().state.character;
      final attackSpeedMs = (character.attackSpeed * 1000).toInt();

      if (_lastPlayerAttackTime == null) {
        _tryPlayerAttack();
      } else {
        final now = DateTime.now();
        final diff = now.difference(_lastPlayerAttackTime!).inMilliseconds;

        setState(() {
          _attackCooldownProgress = (diff / attackSpeedMs).clamp(0.0, 1.0);
        });

        if (diff >= attackSpeedMs) {
          _tryPlayerAttack();
        }
      }
    });
  }

  void _stopPlayerAttack() {
    _isWeaponOnEnemy = false;
    _playerAttackTimer?.cancel();
    _playerAttackTimer = null;
    setState(() {
      _attackCooldownProgress = 0.0;
    });
  }

  void _tryPlayerAttack() {
    _lastPlayerAttackTime = DateTime.now();
    setState(() {
      _attackCooldownProgress = 0.0;
    });
    _onAttack();
  }

  void _onAttack() {
    final result = CombatService.calculateDamage(widget.weapon);
    setState(() {
      _enemyCurrentHP -= result.damage;
      final id = UniqueKey().toString();
      _enemyDamageTexts.add(_DamageText(
        id: id,
        damage: result.damage,
        randomX: _random.nextDouble() * 100 - 50,
        randomY: _random.nextDouble() * 100 - 50,
      ));
    });

    if (_enemyCurrentHP <= 0) {
      _enemyCurrentHP = widget.enemy.hp;
      final loot = CombatService.generateLoot(widget.enemy);
      final inventoryBloc = context.read<InventoryBloc>();

      for (final item in loot.items) {
        if (item is GoldItem) {
          context.read<CharacterBloc>().add(CharacterAddGold(item.amount));
        } else if (!inventoryBloc.state.inventory.isFull) {
          inventoryBloc.add(InventoryEvent$AddItem(item: item));
        }
        _dropHistory.insert(0, item);
        _listKey.currentState
            ?.insertItem(0, duration: const Duration(milliseconds: 300));
      }
    }
  }

  String _getItemName(Item item) {
    if (item is GoldItem) return '${item.amount} Gold';
    if (item is Weapon) {
      return item.enchantLevel > 0
          ? "${item.name} +${item.enchantLevel}"
          : item.name;
    }
    if (item is Armor) {
      return item.enchantLevel > 0
          ? "${item.name} +${item.enchantLevel}"
          : item.name;
    }
    if (item is Scroll) return item.name;
    return 'Unknown Item';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CharacterBloc, CharacterState>(
      listenWhen: (previous, current) {
        if (previous is CharacterLoaded && current is CharacterLoaded) {
          return current.character.currentHealth !=
              previous.character.currentHealth;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CharacterLoaded) {
          final healAmount =
              state.character.currentHealth - _previousPlayerHealth;
          if (healAmount > 0 && _previousPlayerHealth != -1) {
            final id = UniqueKey().toString();
            setState(() {
              _playerDamageTexts.add(_DamageText(
                id: id,
                damage: healAmount,
                randomX: _isWeaponSlotExpanded
                    ? (_random.nextDouble() * 40 - 20)
                    : 0,
                randomY: _random.nextDouble() * 40 - 20,
                isHeal: true,
              ));
            });
          }
          _previousPlayerHealth = state.character.currentHealth;
        }
      },
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is! CharacterLoaded) return const SizedBox();
          final character = state.character;

          if (_previousPlayerHealth == -1) {
            _previousPlayerHealth = character.currentHealth;
          }

          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/background/forest_enemy_background.png'),
                    fit: BoxFit.cover)),
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
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              PlayerHpBar(
                                width: widget.width,
                                currentHP: character.currentHealth,
                                maxHP: character.baseHealth,
                                heightFactor: playerHpHeight,
                              ),
                              ..._playerDamageTexts.map((dt) {
                                return Positioned(
                                  key: ValueKey(dt.id),
                                  left:
                                      50, // 100 is the edge of the bar, so 50 is to the left of it
                                  child: Transform.translate(
                                    offset: Offset(dt.randomX, dt.randomY),
                                    child: DamageTextWidget(
                                      damage: dt.damage,
                                      flyUp: false,
                                      isHeal: dt.isHeal,
                                      onComplete: () {
                                        setState(() {
                                          _playerDamageTexts.removeWhere(
                                              (e) => e.id == dt.id);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Recent Loot:',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.yellow,
                              fontFamily: "PT Sans"),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                            child: AnimatedList(
                              key: _listKey,
                              initialItemCount: _dropHistory.length,
                              padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: 16,
                                  right: 100), // padding right for weapon slot
                              itemBuilder: (context, index, animation) {
                                return SlideTransition(
                                  position: animation.drive(Tween(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero)
                                      .chain(
                                          CurveTween(curve: Curves.easeOut))),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(_dropHistory[index].image,
                                            width: 40, height: 40),
                                        const SizedBox(width: 12),
                                        Text(
                                          _getItemName(_dropHistory[index]),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'PT Sans'),
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
                            widthOfOneHP:
                                (widget.width - 200) / widget.enemy.hp,
                            currentHP: _enemyCurrentHP,
                            heightFactor: enemyHpHeight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DragTarget<String>(
                          onWillAcceptWithDetails: (details) {
                            if (details.data == 'weapon') {
                              _startPlayerAttack();
                              return true;
                            }
                            return false;
                          },
                          onAcceptWithDetails: (details) {
                            _stopPlayerAttack();
                          },
                          onLeave: (data) {
                            _stopPlayerAttack();
                          },
                          builder: (context, candidateData, rejectedData) {
                            return SizedBox(
                              height: enemyFieldHeight,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  EnemyField(
                                    width: widget.width,
                                    assetImageLink: widget.enemy.image,
                                    availableHeight: enemyFieldHeight,
                                  ),
                                  ..._enemyDamageTexts.map((dt) {
                                    return Positioned(
                                      key: ValueKey(dt.id),
                                      child: Transform.translate(
                                        offset: Offset(dt.randomX, dt.randomY),
                                        child: DamageTextWidget(
                                          damage: dt.damage,
                                          flyUp: true,
                                          onComplete: () {
                                            setState(() {
                                              _enemyDamageTexts.removeWhere(
                                                  (e) => e.id == dt.id);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    // Weapon Slot
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      right: _isWeaponSlotExpanded ? 4 : -88,
                      top: headerHeight - 16,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragUpdate: (details) {
                          if (details.primaryDelta != null) {
                            if (details.primaryDelta! < -2 &&
                                !_isWeaponSlotExpanded) {
                              setState(() {
                                _isWeaponSlotExpanded = true;
                              });
                              _scheduleCombatStart();
                            } else if (details.primaryDelta! > 2 &&
                                _isWeaponSlotExpanded) {
                              setState(() {
                                _isWeaponSlotExpanded = false;
                              });
                              _stopCombat();
                            }
                          }
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                          child: Row(
                            children: [
                              // Animated Arrows
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                        _isWeaponSlotExpanded
                                            ? (_pulseController.value * 5)
                                            : (-_pulseController.value * 15),
                                        0),
                                    child: Column(
                                      children: [
                                        Text(
                                          _isWeaponSlotExpanded
                                              ? '>>>>>>'
                                              : '<<<<<<',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Text(
                                          _isWeaponSlotExpanded
                                              ? '>>>>>>'
                                              : '<<<<<<',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Text(
                                          _isWeaponSlotExpanded
                                              ? '>>>>>>'
                                              : '<<<<<<',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Silhouette when collapsed
                              if (!_isWeaponSlotExpanded)
                                ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                      Colors.red, BlendMode.srcIn),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'assets/icons/slot_slider_icon.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),

                              if (!_isWeaponSlotExpanded)
                                const SizedBox(width: 8),

                              // The actual slot
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Base slot background
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          52, 52, 52, 0.95),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),

                                  // Yellow cooldown fill
                                  if (_isWeaponDragging &&
                                      _attackCooldownProgress > 0)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 80 * _attackCooldownProgress,
                                        decoration: BoxDecoration(
                                          color: Colors.red
                                              .withValues(alpha: 0.75),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(14),
                                            bottomRight: Radius.circular(14),
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Draggable weapon when expanded
                                  if (_isWeaponSlotExpanded)
                                    Draggable<String>(
                                      data: 'weapon',
                                      onDragStarted: () {
                                        setState(() {
                                          _isWeaponDragging = true;
                                        });
                                      },
                                      onDragEnd: (details) {
                                        setState(() {
                                          _isWeaponDragging = false;
                                        });
                                        _stopPlayerAttack();
                                      },
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Glow effect
                                            if (widget.weapon.enchantLevel > 0)
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: widget.weapon
                                                                  .enchantLevel >
                                                              20
                                                          ? enchantedWeaponsGlowColors[
                                                              21]
                                                          : enchantedWeaponsGlowColors[
                                                              widget.weapon
                                                                  .enchantLevel],
                                                      blurRadius: 20,
                                                      spreadRadius: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: Image.asset(
                                                  widget.weapon.image,
                                                  fit: BoxFit.contain),
                                            ),
                                          ],
                                        ),
                                      ),
                                      childWhenDragging: const SizedBox(
                                          width: 80, height: 80), // Empty slot
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: WeaponField(
                                          weapon: widget.weapon,
                                          showBackground: false,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
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
                                final item = ItemRegistry.createItem(
                                    drop.itemType,
                                    weaponType: drop.weaponType,
                                    armorType: drop.armorType,
                                    scrollType: drop.scrollType);
                                String titleText = _getItemName(item);
                                if (item is GoldItem) {
                                  titleText = drop.minQuantity ==
                                          drop.maxQuantity
                                      ? '${drop.minQuantity} Gold'
                                      : '${drop.minQuantity}-${drop.maxQuantity} Gold';
                                }
                                return ListTile(
                                  leading: Image.asset(item.image,
                                      width: 40, height: 40),
                                  title: Text(titleText,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PT Sans')),
                                  trailing: Text('${drop.chance}%',
                                      style: const TextStyle(
                                          color: Colors.yellow,
                                          fontFamily: 'PT Sans')),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    // Death Overlay
                    if (character.currentHealth <= 0)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.85),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'YOU ARE DEAD',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 48,
                                    fontFamily: 'PT Sans',
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.redAccent,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<CharacterBloc>().add(
                                        CharacterHeal(character.baseHealth));
                                    context
                                        .read<HuntingFieldsBloc>()
                                        .add(HuntingFieldEvent$StopHunting());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: Colors.white24, width: 2),
                                    ),
                                  ),
                                  child: const Text(
                                    'REBORN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: 'PT Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DamageText {
  final String id;
  final int damage;
  final double randomX;
  final double randomY;
  final bool isHeal;

  _DamageText({
    required this.id,
    required this.damage,
    required this.randomX,
    required this.randomY,
    this.isHeal = false,
  });
}

class DamageTextWidget extends StatefulWidget {
  final int damage;
  final VoidCallback onComplete;
  final bool flyUp;
  final bool isHeal;

  const DamageTextWidget({
    super.key,
    required this.damage,
    required this.onComplete,
    this.flyUp = true,
    this.isHeal = false,
  });

  @override
  State<DamageTextWidget> createState() => _DamageTextWidgetState();
}

class _DamageTextWidgetState extends State<DamageTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.flyUp ? const Offset(0, -100) : const Offset(-100, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(
              widget.isHeal ? '+ ${widget.damage}' : '- ${widget.damage}',
              style: TextStyle(
                color: widget.isHeal ? Colors.green : Colors.red,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'PT Sans',
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
