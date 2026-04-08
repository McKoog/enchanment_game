import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(builder: (context, state) {
      final character = state.character;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PersistentHeader(
            versionLabel: 'v.$appVersion',
            gold: character.gold,
            level: character.level,
            experienceProgress: character.maxExp > 0 ? character.currentExp / character.maxExp : 0,
            skillPoints: character.skillPoints,
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: child,
            ),
          ),
        ],
      );
    });
  }
}

class _PersistentHeader extends StatelessWidget {
  const _PersistentHeader({
    required this.versionLabel,
    required this.gold,
    required this.level,
    required this.experienceProgress,
    required this.skillPoints,
  });

  final String versionLabel;
  final int gold;
  final int level;
  final double experienceProgress;
  final int skillPoints;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = experienceProgress.clamp(0.0, 1.0);
    final percentLabel = '${(clampedProgress * 100).round()}%';

    return Material(
      color: const Color.fromRGBO(52, 52, 52, 1),
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      versionLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.yellow,
                        fontFamily: 'PT Sans',
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$gold',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.yellow.shade700,
                            fontFamily: 'PT Sans',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color.fromRGBO(110, 110, 110, 1),
                          Color.fromRGBO(62, 62, 62, 1),
                          Color.fromRGBO(38, 38, 38, 1),
                        ],
                        stops: [0.0, 0.55, 1.0],
                        center: Alignment(-0.25, -0.25),
                        radius: 0.95,
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(230, 200, 80, 1),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$level',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.yellow,
                        fontFamily: 'PT Sans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    height: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          LinearProgressIndicator(
                            value: clampedProgress,
                            minHeight: 8,
                            backgroundColor: const Color.fromRGBO(230, 200, 80, 1).withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(230, 200, 80, 1),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                percentLabel,
                                style: const TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(10, 10, 10, 1),
                                  fontFamily: 'PT Sans',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.yellow.shade700,
                          fontFamily: 'PT Sans',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$skillPoints',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.yellow,
                          fontFamily: 'PT Sans',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
