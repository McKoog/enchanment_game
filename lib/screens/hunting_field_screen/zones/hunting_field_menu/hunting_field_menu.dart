import 'dart:async';

import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldsMenu extends StatefulWidget {
  const HuntingFieldsMenu({super.key, required this.constraints, required this.width});

  final BoxConstraints constraints;
  final double width;

  @override
  State<HuntingFieldsMenu> createState() => _HuntingFieldsMenuState();
}

class _HuntingFieldsMenuState extends State<HuntingFieldsMenu> {
  Enemy? selectedEnemy;
  Timer? _timer;

  final List<Enemy> enemies = [
    greyWolf,
    bandit,
    goblin,
    dryad,
  ];

  final Map<Enemy, Alignment> enemyPositions = {
    greyWolf: const Alignment(-0.8, -0.6),
    bandit: const Alignment(0.8, -0.5),
    goblin: const Alignment(-0.8, 0.4),
    dryad: const Alignment(0.8, 0.5),
  };

  final Map<Enemy, LayerLink> _layerLinks = {};

  @override
  void initState() {
    super.initState();
    for (var enemy in enemies) {
      _layerLinks[enemy] = LayerLink();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final characterState = context.watch<CharacterBloc>().state;
    final deathTime = characterState.character.deathCooldownEndTime;
    final isDeathCooldownActive = deathTime != null && DateTime.now().isBefore(deathTime);
    final remainingDeathSeconds = isDeathCooldownActive ? deathTime.difference(DateTime.now()).inSeconds + 1 : 0;

    return Container(
      width: widget.width,
      height: widget.constraints.maxHeight,
      decoration: const BoxDecoration(
        color: AppColors.panelBackground,
        image: DecorationImage(
          opacity: 0.7,
          image: AssetImage('assets/background/forest_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (selectedEnemy != null) {
            setState(() {
              selectedEnemy = null;
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...enemies.map((enemy) {
              final alignment = enemyPositions[enemy] ?? Alignment.center;
              final isSelected = selectedEnemy == enemy;
              final circleSize = (widget.width * 0.3).clamp(80.0, 140.0); // Responsive circle size

              return Align(
                alignment: alignment,
                child: CompositedTransformTarget(
                  link: _layerLinks[enemy]!,
                  child: GestureDetector(
                    onTap: () {
                      if (isDeathCooldownActive) return;
                      setState(() {
                        selectedEnemy = isSelected ? null : enemy;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.accentYellow : AppColors.panelBorder,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.overlayMedium,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                enemy.image,
                                fit: BoxFit.contain,
                                gaplessPlayback: true,
                                color: isDeathCooldownActive ? AppColors.overlayMedium : null,
                                colorBlendMode: isDeathCooldownActive ? BlendMode.darken : null,
                              ),
                            ),
                          ),
                        ),
                        if (isDeathCooldownActive)
                          Text(
                            '$remainingDeathSeconds',
                            style: AppTypography.titleLargePrimary.copyWith(
                              color: AppColors.accentYellow,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(color: AppColors.black, blurRadius: 10),
                                Shadow(color: AppColors.error, blurRadius: 20),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (selectedEnemy != null && !isDeathCooldownActive)
              Builder(
                builder: (context) {
                  final alignment = enemyPositions[selectedEnemy] ?? Alignment.center;
                  final isTopHalf = alignment.y < 0;

                  return CompositedTransformFollower(
                    link: _layerLinks[selectedEnemy!]!,
                    targetAnchor: isTopHalf ? Alignment.bottomCenter : Alignment.topCenter,
                    followerAnchor: isTopHalf ? Alignment.topCenter : Alignment.bottomCenter,
                    offset: Offset(0, isTopHalf ? 10 : -10),
                    child: GestureDetector(
                      onTap: () {}, // Prevent closing when tapping the popup
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: (widget.width * 0.35).clamp(140.0, 250.0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.overlayLight,
                          border: Border.all(color: AppColors.accentYellow, width: 2),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.overlayMedium,
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedEnemy!.name,
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT Sans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'HP: ${selectedEnemy!.hp}\nATK: ${selectedEnemy!.attack}\nSPD: ${selectedEnemy!.attackSpeed}/s',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'PT Sans',
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade700,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                final bloc = context.read<HuntingFieldsBloc>();
                                bloc.add(HuntingFieldEvent$SelectEnemy(enemy: selectedEnemy!));
                                bloc.add(HuntingFieldEvent$StartHunting());
                              },
                              child: const Text(
                                'Hunt',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'PT Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
