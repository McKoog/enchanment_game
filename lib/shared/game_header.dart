import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_bloc.dart';
import 'package:enchantment_game/runner.dart';
import 'package:enchantment_game/shared/settings_dialog.dart';
import 'package:enchantment_game/theme/app_theme.dart';
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
      color: AppColors.panelBackground,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.overlayDark, border: Border.symmetric(horizontal: BorderSide(color: AppColors.borderHighlight))),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      versionLabel,
                      style: AppTypography.attributeLabel.copyWith(color: AppColors.accentYellow),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 20,
                          color: AppColors.accentYellow,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$gold',
                          style: AppTypography.titleSmallPrimary.copyWith(
                            fontWeight: FontWeight.w700,
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
                      gradient: RadialGradient(
                        colors: [
                          AppColors.panelBorder,
                          AppColors.panelBorder.withValues(alpha: 0.7),
                          AppColors.panelBorder.withValues(alpha: 0.5),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                        center: const Alignment(-0.25, -0.25),
                        radius: 0.95,
                      ),
                      border: Border.all(
                        color: AppColors.accentYellow,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.overlayMedium,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$level',
                      style: AppTypography.attributeLabel.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentYellow,
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
                            backgroundColor: AppColors.accentYellow.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accentYellow,
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                percentLabel,
                                style: const TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkText,
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
                        style: AppTypography.bodyLargeHighlight.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$skillPoints',
                        style: AppTypography.bodyLargeHighlight.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  final visualSettingsBloc = context.read<VisualSettingsBloc>();
                  final characterBloc = context.read<CharacterBloc>();
                  final inventoryBloc = context.read<InventoryBloc>();

                  showDialog(
                    context: context,
                    useRootNavigator: true,
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: visualSettingsBloc),
                        BlocProvider.value(value: characterBloc),
                        BlocProvider.value(value: inventoryBloc),
                      ],
                      child: const SettingsDialog(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.settings, color: AppColors.accentYellow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
