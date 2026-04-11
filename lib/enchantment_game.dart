import 'package:enchantment_game/services/sound_service.dart';
import 'package:enchantment_game/shared/adaptive/responsive_layout.dart';
import 'package:enchantment_game/shared/game_header.dart';
import 'package:enchantment_game/shared/shared_blocs_provider.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EnchantmentGame extends StatefulWidget {
  const EnchantmentGame({super.key});

  @override
  State<EnchantmentGame> createState() => _EnchantmentGameState();
}

class _EnchantmentGameState extends State<EnchantmentGame> {
  bool _musicStarted = false;

  @override
  void initState() {
    super.initState();
    _tryStartMusic();
  }

  Future<void> _tryStartMusic() async {
    if (!_musicStarted) {
      bool success = await SoundService().playMainTheme();
      if (success) {
        _musicStarted = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnchantGame',
      theme: ThemeData.dark(useMaterial3: true),
      home: GestureDetector(
        onTapDown: (_) => _tryStartMusic(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
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
    );
  }
}
