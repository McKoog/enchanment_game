import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_bloc.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_event.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_state.dart';
import 'package:enchantment_game/services/save_service.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/shared/shared_blocs_provider.dart';
import 'package:enchantment_game/shared/game_header.dart';
import 'package:enchantment_game/shared/adaptive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.overlayVeryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PT Sans',
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildVisualGroup(context),
              const SizedBox(height: 24),
              _buildAudioGroup(context),
              const SizedBox(height: 24),
              _buildGameGroup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Visual', style: AppTypography.titleMediumPrimary),
        const SizedBox(height: 12),
        BlocBuilder<VisualSettingsBloc, VisualSettingsState>(
          builder: (context, state) {
            return Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingRow(
                    name: 'Show navigation arrows',
                    description: 'Displays navigation arrows on the screen',
                    trailing: Checkbox(
                      value: state.showNavigationArrows,
                      activeColor: AppColors.accentYellow,
                      onChanged: (val) {
                        context.read<VisualSettingsBloc>().add(
                            VisualSettingsEvent$ChangeShowNavigationArrows(
                                showNavigationArrows: val ?? true));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingRow(
                    name: 'Optimized particles',
                    description: 'Enables optimized rendering for particles',
                    trailing: Checkbox(
                      value: state.isOptimized,
                      activeColor: AppColors.accentYellow,
                      onChanged: (val) {
                        context.read<VisualSettingsBloc>().add(
                            VisualSettingsEvent$ChangeOptimized(
                                isOptimized: val ?? false));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingRow(
                    name: 'Number of particles',
                    description: 'Adjust the amount of particles displayed',
                    trailing: null,
                  ),
                  Slider(
                    value: state.particlesCount.toDouble(),
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    activeColor: AppColors.accentYellow,
                    inactiveColor: AppColors.panelBorder,
                    label: state.particlesCount.toString(),
                    onChanged: (val) {
                      context.read<VisualSettingsBloc>().add(
                          VisualSettingsEvent$ChangeCount(count: val.toInt()));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAudioGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Audio', style: AppTypography.titleMediumPrimary),
        const SizedBox(height: 12),
        BlocBuilder<VisualSettingsBloc, VisualSettingsState>(
          builder: (context, state) {
            return Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingRow(
                    name: 'Music Volume',
                    description: 'Adjust the volume of the background music',
                    trailing: null,
                  ),
                  Slider(
                    value: state.musicVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: AppColors.accentYellow,
                    inactiveColor: AppColors.panelBorder,
                    label: '${(state.musicVolume * 100).round()}%',
                    onChanged: (val) {
                      context.read<VisualSettingsBloc>().add(
                          VisualSettingsEvent$ChangeMusicVolume(volume: val));
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingRow(
                    name: 'Sound Volume',
                    description: 'Adjust the volume of the sound effects',
                    trailing: null,
                  ),
                  Slider(
                    value: state.soundVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: AppColors.accentYellow,
                    inactiveColor: AppColors.panelBorder,
                    label: '${(state.soundVolume * 100).round()}%',
                    onChanged: (val) {
                      context.read<VisualSettingsBloc>().add(
                          VisualSettingsEvent$ChangeSoundVolume(volume: val));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGameGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game', style: AppTypography.titleMediumPrimary),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showResetConfirmation(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Reset progress',
                style: AppTypography.bodyLargeHighlight.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String name,
    required String description,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.bodyLargeHighlight.copyWith(
                  color: AppColors.accentYellow,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTypography.bodyMediumPrimary.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing,
        ]
      ],
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.panelBackground,
          title: const Text('Reset Progress?',
              style: TextStyle(color: Colors.white)),
          content: const Text(
            'This will delete all your progress, items, and levels. Are you sure?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                await SaveService.clearSave();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: SharedBlocsProvider(
                          child: GameHeader(
                            child: ColoredBox(
                              color: AppColors.overlayLight,
                              child: const ResponsiveLayout(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (route) => false,
                  );
                }
              },
              child:
                  const Text('Reset', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }
}
