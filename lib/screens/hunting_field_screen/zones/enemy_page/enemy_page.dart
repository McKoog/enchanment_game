import 'dart:async';
import 'dart:math';

import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/gold_item.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/skills/skill_type.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/services/armor_set_service.dart';
import 'package:enchantment_game/services/combat_service.dart';
import 'package:enchantment_game/services/loot_service.dart';
import 'package:enchantment_game/services/sound_service.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/attack_field/components/enemy_hp_bar.dart';
import 'components/damage_text_widget.dart';
import 'components/draggable_weapon_slot.dart';
import 'components/enemy_field.dart';
import 'components/player_hp_bar.dart';
import 'components/recent_loot_list.dart';

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

class _EnemyPageState extends State<EnemyPage> with SingleTickerProviderStateMixin {
  bool _showDropList = false;
  bool _showRecentLoot = false;
  late double _enemyCurrentHP;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Item> _dropHistory = [];

  final GlobalKey<AnimatedListState> _notificationListKey = GlobalKey<AnimatedListState>();
  final List<Item> _notificationItems = [];

  final List<DamageTextData> _enemyDamageTexts = [];
  final List<DamageTextData> _playerDamageTexts = [];
  final Random _random = Random();
  final GlobalKey<EnemyFieldState> _enemyFieldKey = GlobalKey<EnemyFieldState>();

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
    _enemyCurrentHP = widget.enemy.hp.toDouble();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bonusRegenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final characterBloc = context.read<CharacterBloc>();
      if (characterBloc.state is CharacterLoaded) {
        final char = (characterBloc.state as CharacterLoaded).character;
        if (char.currentHealth > 0 && char.currentHealth < char.health) {
          int healAmount = 0;
          final restLevel = char.learnedSkills[SkillType.rest.name] ?? 0;

          if (!_isWeaponSlotExpanded) {
            // Weapon slot closed
            healAmount = 3 + (3 * restLevel);
          } else if (!_isWeaponDragging && !_isWeaponOnEnemy) {
            // Weapon slot opened but weapon is not taken
            healAmount = 1 * restLevel;
          }

          if (char.currentHealth > 0 && char.currentHealth < char.health) {
            SoundService().playHealSound();
          }

          if (healAmount > 0) {
            characterBloc.add(CharacterHeal(healAmount));
          }
        }
      }
      if (mounted) setState(() {});
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
    _enemyAttackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
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

    bool isDefensiveStance = _isCombatActive && !_isWeaponOnEnemy && !_isWeaponDragging;

    // Calculate base damage range and critical hit
    double minDamage = widget.enemy.minAttack;
    double maxDamage = widget.enemy.maxAttack;
    double incomingDamage = minDamage + _random.nextDouble() * (maxDamage - minDamage);

    bool isCrit = _random.nextDouble() < widget.enemy.critChance;
    if (isCrit) {
      incomingDamage *= widget.enemy.critPower;
    }

    if (isDefensiveStance) {
      incomingDamage *= 0.8; // 20% reduction
    }

    double maxDamageBlocked = incomingDamage * 0.8;
    double actualDamageBlocked = charState.character.defense.toDouble();

    if (actualDamageBlocked > maxDamageBlocked) {
      actualDamageBlocked = maxDamageBlocked;
    }

    double potentialDamageTaken = incomingDamage - actualDamageBlocked;
    if (potentialDamageTaken < 0) potentialDamageTaken = 0;

    bool isBlocked = _random.nextDouble() < charState.character.blockChance;

    if (!isBlocked && isDefensiveStance) {
      isBlocked = _random.nextDouble() < 0.10; // 10% chance to block
    }

    if (!isBlocked) {
      characterBloc.add(CharacterTakeDamage(incomingDamage));

      if (isCrit) {
        SoundService().playEnemyCriticalHitSound();
      } else {
        SoundService().playEnemyAttackSound();
      }

      final id = UniqueKey().toString();
      setState(() {
        _playerDamageTexts.add(DamageTextData(
          id: id,
          damage: potentialDamageTaken,
          randomX: 0,
          randomY: _random.nextDouble() * 40 - 20,
          isBlock: false,
          isCrit: isCrit,
          isDefensiveStance: isDefensiveStance,
        ));
      });
    } else {
      // Blocked
      double healAmount = 0;
      if (isDefensiveStance && _random.nextDouble() < 0.5) {
        healAmount = potentialDamageTaken * 0.33;
        if (healAmount.toInt() > 0) {
          characterBloc.add(CharacterHeal(healAmount.toInt()));
        }
      }

      if (healAmount.toInt() == 0) {
        SoundService().playBlockedDamageSound();
      }

      final id = UniqueKey().toString();
      setState(() {
        _playerDamageTexts.add(DamageTextData(
          id: id,
          damage: potentialDamageTaken, // Show blocked damage amount
          randomX: 0,
          randomY: _random.nextDouble() * 40 - 20,
          isBlock: true,
        ));
      });

      if (healAmount > 0) {
        final healId = UniqueKey().toString();
        final hpBarWidth = widget.width - 168;
        setState(() {
          _playerDamageTexts.add(DamageTextData(
            id: healId,
            damage: healAmount,
            randomX: (_random.nextDouble() - 0.5) * hpBarWidth,
            randomY: _random.nextDouble() * 40 - 20,
            isHeal: true,
            isBlockHeal: true,
          ));
        });
      }
    }
  }

  void _startPlayerAttack() {
    _isWeaponOnEnemy = true;
  }

  void _stopPlayerAttack() {
    _isWeaponOnEnemy = false;
  }

  void _tryPlayerAttack() {
    _lastPlayerAttackTime = DateTime.now();
    setState(() {
      _attackCooldownProgress = 0.0;
    });
    _onAttack();
  }

  void _onAttack() {
    final characterBloc = context.read<CharacterBloc>();
    if (characterBloc.state is! CharacterLoaded) return;
    final character = (characterBloc.state as CharacterLoaded).character;

    _performSingleAttack();

    final setEffect = ArmorSetService.getEffect(character.activeSetType);
    if (setEffect != null && setEffect.hasDoubleAttackChance(widget.weapon.weaponType)) {
      final chance = setEffect.getDoubleAttackChance(widget.weapon.weaponType);
      if (_random.nextDouble() < chance) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted && _isCombatActive) {
            _performSingleAttack();
          }
        });
      }
    }
  }

  void _performSingleAttack() {
    final characterBloc = context.read<CharacterBloc>();
    if (characterBloc.state is! CharacterLoaded) return;
    final character = (characterBloc.state as CharacterLoaded).character;

    final result = CombatService.calculateDamage(character);

    if (result.isCrit) {
      SoundService().playCriticalHitSound();
    } else {
      SoundService().playPlayerAttackSound();
    }

    // Trigger shake animation on attack
    _enemyFieldKey.currentState?.shake();

    setState(() {
      _enemyCurrentHP -= result.damage;
      final id = UniqueKey().toString();
      _enemyDamageTexts.add(DamageTextData(
        id: id,
        damage: result.damage,
        randomX: _random.nextDouble() * 100 - 50,
        randomY: _random.nextDouble() * 100 - 50,
        isCrit: result.isCrit,
      ));
    });

    if (character.lifesteal > 0 && result.damage > 0) {
      double lsAmount = result.damage * character.lifesteal;
      int heal = lsAmount.toInt();
      if (heal > 0) {
        characterBloc.add(CharacterHeal(heal));

        final healId = UniqueKey().toString();
        final hpBarWidth = widget.width - 168;
        setState(() {
          _playerDamageTexts.add(DamageTextData(
            id: healId,
            damage: heal.toDouble(),
            // Calculate random offset to cover the entire width of the HP bar
            // from -hpBarWidth/2 to hpBarWidth/2
            randomX: (_random.nextDouble() - 0.5) * hpBarWidth,
            randomY: 0,
            isHeal: true,
          ));
        });
      }
    }

    if (_enemyCurrentHP <= 0) {
      _enemyCurrentHP = widget.enemy.hp.toDouble();

      if (widget.enemy.expReward > 0 || widget.enemy.spReward > 0) {
        characterBloc.add(CharacterAddExp(widget.enemy.expReward, spAmount: widget.enemy.spReward));
      }

      final loot = LootService.generateLoot(widget.enemy, dropChanceBonus: character.dropChanceBonus);
      final inventoryBloc = context.read<InventoryBloc>();

      for (final item in loot.items) {
        final clonedItem = _cloneItem(item);
        if (item is GoldItem) {
          characterBloc.add(CharacterAddGold(item.amount));
        } else if (!inventoryBloc.state.inventory.isFull) {
          inventoryBloc.add(InventoryEvent$AddItem(item: item));
        }
        _dropHistory.insert(0, clonedItem);
        _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));

        if (!_showRecentLoot) {
          _addDropNotification(clonedItem);
        }
      }
    }
  }

  void _addDropNotification(Item item) {
    if (_notificationItems.length >= 5) {
      final removedItem = _notificationItems.removeLast();
      _notificationListKey.currentState?.removeItem(
        _notificationItems.length,
        (context, animation) => _buildNotificationItem(removedItem, animation, true),
        duration: const Duration(milliseconds: 300),
      );
    }

    _notificationItems.insert(0, item);
    _notificationListKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _notificationItems.contains(item)) {
        final index = _notificationItems.indexOf(item);
        final removedItem = _notificationItems.removeAt(index);
        _notificationListKey.currentState?.removeItem(
          index,
          (context, animation) => _buildNotificationItem(removedItem, animation, true),
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  Widget _buildNotificationItem(Item item, Animation<double> animation, bool isRemoving) {
    final slideInTween = Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero);
    final slideOutTween = Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero);

    return SlideTransition(
      position: animation.drive(
        (isRemoving ? slideOutTween : slideInTween).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.overlayDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentYellow.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  item.image,
                  width: 32,
                  height: 32,
                  gaplessPlayback: true,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _getItemName(item),
                    style: AppTypography.bodySmallPrimary,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Item _cloneItem(Item item) {
    if (item is Weapon) return Weapon.copyWith(item);
    if (item is Armor) return Armor.copyWith(item);
    if (item is Scroll) return Scroll.copyWith(item);
    return item;
  }

  String _getItemName(Item item) {
    if (item is GoldItem) return '${item.amount} Gold';
    if (item is Weapon) {
      return item.enchantLevel > 0 ? "${item.displayName} +${item.enchantLevel}" : item.displayName;
    }
    if (item is Armor) {
      return item.enchantLevel > 0 ? "${item.displayName} +${item.enchantLevel}" : item.displayName;
    }
    if (item is Scroll) return item.name;
    return 'Unknown Item';
  }

  void _onShowDropListToggle() {
    setState(() {
      _showDropList = !_showDropList;
    });
  }

  void _onShowRecentLootToggle() {
    setState(() {
      _showRecentLoot = !_showRecentLoot;
    });
  }

  void _onWeaponSlotExpanded() {
    setState(() {
      _isWeaponSlotExpanded = true;
    });
    _scheduleCombatStart();
    _playerAttackTimer?.cancel();
    _playerAttackTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !_isWeaponSlotExpanded) {
        timer.cancel();
        return;
      }

      final character = context.read<CharacterBloc>().state.character;
      final attackSpeedMs = (character.attackSpeed * 1000).toInt();

      if (_lastPlayerAttackTime == null) {
        if (_isWeaponOnEnemy) {
          _tryPlayerAttack();
        } else if (_attackCooldownProgress != 1.0) {
          setState(() {
            _attackCooldownProgress = 1.0;
          });
        }
      } else {
        final now = DateTime.now();
        final diff = now.difference(_lastPlayerAttackTime!).inMilliseconds;
        final newProgress = (diff / attackSpeedMs).clamp(0.0, 1.0);

        if (_attackCooldownProgress != newProgress) {
          setState(() {
            _attackCooldownProgress = newProgress;
          });
        }

        if (diff >= attackSpeedMs && _isWeaponOnEnemy) {
          _tryPlayerAttack();
        }
      }
    });
  }

  void _onWeaponSlotCollapsed() {
    final escapeTime = context.read<CharacterBloc>().state.character.escapeCooldownEndTime;
    if (escapeTime == null || DateTime.now().isAfter(escapeTime)) {
      setState(() {
        _isWeaponSlotExpanded = false;
        _attackCooldownProgress = 0.0;
        _lastPlayerAttackTime = null;
      });
      _playerAttackTimer?.cancel();
      _playerAttackTimer = null;
      _stopCombat();
    }
  }

  void _onWeaponDragStarted() {
    setState(() {
      _isWeaponDragging = true;
    });
    context.read<CharacterBloc>().add(CharacterClearEscapeCooldown());
  }

  void _onWeaponDragEnded() {
    setState(() {
      _isWeaponDragging = false;
    });
    _stopPlayerAttack();
    if (_isCombatActive && _isWeaponSlotExpanded) {
      context.read<CharacterBloc>().add(CharacterStartEscapeCooldown());
    }
  }

  void _onWeaponDragAccept() {
    _stopPlayerAttack();
  }

  void _onPlayerDamageTextComplete(String id) {
    setState(() {
      _playerDamageTexts.removeWhere((e) => e.id == id);
    });
  }

  void _onEnemyDamageTextComplete(String id) {
    setState(() {
      _enemyDamageTexts.removeWhere((e) => e.id == id);
    });
  }

  void _onRebornPressed() {
    context.read<CharacterBloc>().add(CharacterRespawn());
    context.read<HuntingFieldsBloc>().add(HuntingFieldEvent$StopHunting());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CharacterBloc, CharacterState>(
      listenWhen: (previous, current) {
        if (previous is CharacterLoaded && current is CharacterLoaded) {
          return current.character.currentHealth != previous.character.currentHealth;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CharacterLoaded) {
          final healAmount = state.character.currentHealth - _previousPlayerHealth;
          if (healAmount > 0 && _previousPlayerHealth != -1) {
            final id = UniqueKey().toString();
            final hpBarWidth = widget.width - 168;
            setState(() {
              _playerDamageTexts.add(DamageTextData(
                id: id,
                damage: healAmount.toDouble(),
                // Calculate random offset to cover the entire width of the HP bar
                // from -hpBarWidth/2 to hpBarWidth/2
                randomX: (_random.nextDouble() - 0.5) * hpBarWidth,
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

          final escapeTime = character.escapeCooldownEndTime;
          final canEscape = escapeTime == null || DateTime.now().isAfter(escapeTime);

          if (_previousPlayerHealth == -1) {
            _previousPlayerHealth = character.currentHealth;
          }

          return Container(
            decoration: const BoxDecoration(
              color: AppColors.panelBackground,
              image: DecorationImage(image: AssetImage('assets/background/forest_enemy_background.png'), fit: BoxFit.cover),
            ),
            width: widget.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight;

                final playerHpHeight = availableHeight * 0.05;
                final enemyHpHeight = availableHeight * 0.05;
                final enemyFieldHeight = availableHeight * 0.4;

                return Stack(
                  children: [
                    SizedBox(
                      width: widget.width,
                      child: Column(
                        children: [
                          const Expanded(
                            child: SizedBox(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: enemyHpHeight,
                            child: EnemyHpBar(
                              width: widget.width - 168,
                              enemy: widget.enemy,
                              widthOfOneHP: (widget.width - 168) / widget.enemy.hp,
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
                            onAcceptWithDetails: (_) => _onWeaponDragAccept(),
                            onLeave: (_) => _stopPlayerAttack(),
                            builder: (context, candidateData, rejectedData) {
                              return SizedBox(
                                height: enemyFieldHeight,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    EnemyField(
                                      key: _enemyFieldKey,
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
                                            isCrit: dt.isCrit,
                                            onComplete: () => _onEnemyDamageTextComplete(dt.id),
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
                          SizedBox(
                            height: playerHpHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                PlayerHpBar(
                                  width: widget.width - 168,
                                  currentHP: character.currentHealth,
                                  maxHP: character.health,
                                  heightFactor: playerHpHeight,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // Weapon Animated Area
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      right: 4,
                      width: 80,
                      bottom: _isWeaponSlotExpanded ? 4 : -88,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: 80,
                        height: _isWeaponSlotExpanded ? 234.0 : 80.0, // 80(slot) + 24(arrows) + 12(spacing) + 64(icon) = 180
                        decoration: BoxDecoration(
                          color: AppColors.overlayMedium,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: AnimatedOpacity(
                          opacity: _isWeaponSlotExpanded ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 160, // Just above the arrows (80 slot + 24 arrows)
                                left: 0,
                                right: 0,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Image.asset(
                                    _isWeaponDragging ? 'assets/icons/swords.png' : 'assets/icons/shield_icon.png',
                                    key: ValueKey(_isWeaponDragging),
                                    width: 64,
                                    height: 64,
                                    color: _isWeaponDragging ? AppColors.error.withValues(alpha: 0.5) : AppColors.accentYellow.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Weapon Slot
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      right: 4,
                      width: 80,
                      bottom: _isWeaponSlotExpanded ? 4 : -88,
                      child: DraggableWeaponSlot(
                        isExpanded: _isWeaponSlotExpanded,
                        isDragging: _isWeaponDragging,
                        attackCooldownProgress: _attackCooldownProgress,
                        weapon: widget.weapon,
                        pulseController: _pulseController,
                        onExpand: _onWeaponSlotExpanded,
                        onCollapse: _onWeaponSlotCollapsed,
                        onDragStarted: _onWeaponDragStarted,
                        onDragEnded: _onWeaponDragEnded,
                      ),
                    ),

                    // Player Damage/Heal Texts
                    ..._playerDamageTexts.map((dt) {
                      final isHeal = dt.isHeal;

                      if (isHeal) {
                        // Heal: Starts above player HP bar, random horizontal position across the bar
                        // Calculate offset only once per text id to prevent random jumping on rebuilds
                        final randomXOffset = dt.randomX;

                        return Positioned(
                          key: ValueKey(dt.id),
                          left: widget.width / 2 + randomXOffset - 40, // 40 is half of widget width
                          bottom: 16.0 + playerHpHeight, // right above HP bar without extra offset
                          width: 80,
                          child: DamageTextWidget(
                            damage: dt.damage,
                            flyUp: true,
                            flyDistance: 80.0, // exactly half of the previous 160
                            isHeal: true,
                            isBlockHeal: dt.isBlockHeal,
                            onComplete: () => _onPlayerDamageTextComplete(dt.id),
                          ),
                        );
                      } else {
                        // Damage: Starts left of player HP bar (left bottom corner)
                        return Positioned(
                          key: ValueKey(dt.id),
                          left: 4,
                          bottom: 0,
                          width: 80,
                          child: DamageTextWidget(
                            damage: dt.damage,
                            flyUp: true,
                            flyDistance: enemyFieldHeight + 16 + playerHpHeight, // Fly up to enemy HP bar height
                            isHeal: false,
                            isBlock: dt.isBlock,
                            isDefensiveStance: dt.isDefensiveStance,
                            isBlockHeal: dt.isBlockHeal,
                            isCrit: dt.isCrit,
                            duration: const Duration(seconds: 6), // 6 seconds (was 3, so increased by 2x)
                            onComplete: () => _onPlayerDamageTextComplete(dt.id),
                          ),
                        );
                      }
                    }),

                    // Floating Buttons
                    Positioned(
                      top: 16,
                      right: _dropHistory.isNotEmpty ? 76 : 16, // to the left of recent loot button if it's visible
                      child: InkWell(
                        onTap: _onShowDropListToggle,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.panelBackground,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentYellow),
                          ),
                          child: const Icon(Icons.format_list_bulleted, color: AppColors.accentYellow, size: 28),
                        ),
                      ),
                    ),
                    if (canEscape)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: InkWell(
                          onTap: () {
                            context.read<HuntingFieldsBloc>().add(HuntingFieldEvent$StopHunting());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.panelBackground,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accentYellow),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 28,
                              color: AppColors.accentYellow,
                            ),
                          ),
                        ),
                      ),
                    if (_dropHistory.isNotEmpty)
                      Positioned(
                        top: 16, // moved to top right
                        right: 16,
                        child: InkWell(
                          onTap: _onShowRecentLootToggle,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.panelBackground,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accentYellow),
                            ),
                            child: const Icon(Icons.inventory_2_outlined, color: AppColors.accentYellow, size: 28),
                          ),
                        ),
                      ),

                    // Recent Loot Slide-in Overlay
                    Positioned(
                      top: 76,
                      left: 16,
                      right: 0,
                      bottom: enemyFieldHeight + enemyHpHeight + playerHpHeight + 48, // Above enemy HP
                      child: AnimatedSlide(
                        offset: _showRecentLoot ? Offset.zero : const Offset(1, 0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: RecentLootList(
                          listKey: _listKey,
                          dropHistory: _dropHistory,
                        ),
                      ),
                    ),

                    // Notification Overlay
                    if (!_showRecentLoot)
                      Positioned(
                        top: 72,
                        left: 16,
                        right: 0,
                        bottom: enemyHpHeight + enemyFieldHeight + playerHpHeight + 48, // Above enemy HP bar
                        child: AnimatedList(
                          key: _notificationListKey,
                          initialItemCount: _notificationItems.length,
                          itemBuilder: (context, index, animation) {
                            return _buildNotificationItem(_notificationItems[index], animation, false);
                          },
                        ),
                      ),

                    // Drop List Overlay
                    if (_showDropList)
                      Positioned(
                        top: 76, // below the top buttons
                        left: 16,
                        right: 16,
                        child: Material(
                          color: AppColors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.overlayVeryDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.accentYellow),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.enemy.dropList.map((drop) {
                                final item = ItemRegistry.createItem(
                                  drop.itemType,
                                  weaponType: drop.weaponType,
                                  armorType: drop.armorType,
                                  scrollType: drop.scrollType,
                                  generateRarity: false,
                                );
                                String titleText = _getItemName(item);
                                if (item is GoldItem) {
                                  titleText =
                                      drop.minQuantity == drop.maxQuantity ? '${drop.minQuantity} Gold' : '${drop.minQuantity}-${drop.maxQuantity} Gold';
                                }
                                return ListTile(
                                  leading: Image.asset(item.image, width: 40, height: 40, gaplessPlayback: true),
                                  title: Text(titleText, style: AppTypography.bodyMediumPrimary),
                                  trailing: Text('${drop.chance}%', style: AppTypography.bodyLargeHighlight),
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
                          color: AppColors.overlayVeryDark,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'YOU ARE DEAD',
                                  style: AppTypography.titleLargePrimary.copyWith(
                                    color: AppColors.error,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: AppColors.enemyHp,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'You lost:\n-25% exp\n-50% gold\n-25 SP\n\nHunting is now unavailable for 15 seconds.',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.titleMediumPrimary.copyWith(
                                    color: AppColors.enemyHp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: _onRebornPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: AppColors.primaryText.withValues(alpha: 0.24), width: 2),
                                    ),
                                  ),
                                  child: Text(
                                    'REBORN',
                                    style: AppTypography.titleLargePrimary.copyWith(
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
