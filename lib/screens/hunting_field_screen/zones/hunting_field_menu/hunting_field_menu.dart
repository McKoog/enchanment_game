import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/models/enemy.dart';
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

  final List<Enemy> enemies = [
    greyWolf,
    bandit,
    goblin,
    dryad,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.constraints.maxHeight,
      decoration: const BoxDecoration(
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
        child: GridView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            crossAxisSpacing: 24,
            mainAxisSpacing: 0,
          ),
          itemCount: enemies.length,
          itemBuilder: (context, index) {
            final enemy = enemies[index];
            final isTopRow = index < 2;
            final isSelected = selectedEnemy == enemy;

            return LayoutBuilder(builder: (context, constraints) {
              final circleSize = constraints.maxWidth * 0.65;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: isTopRow ? 10 : null,
                    bottom: isTopRow ? null : 200,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedEnemy = isSelected ? null : enemy;
                        });
                      },
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: isSelected ? Colors.yellow : const Color.fromRGBO(130, 130, 130, 1),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: isTopRow ? circleSize + 20 : null,
                      bottom: isTopRow ? null : circleSize + 210,
                      child: GestureDetector(
                        onTap: () {}, // Prevent closing when tapping the popup
                        child: Container(
                          width: constraints.maxWidth,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            border: Border.all(color: Colors.yellow, width: 2),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                enemy.name,
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PT Sans',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'HP: ${enemy.hp}\nATK: ${enemy.attack}\nSPD: ${enemy.attackSpeed}/s',
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
                                  bloc.add(HuntingFieldEvent$SelectEnemy(enemy: enemy));
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
                    ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
