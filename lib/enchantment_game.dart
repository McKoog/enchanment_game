import 'package:enchantment_game/game_header.dart';
import 'package:enchantment_game/responsive_layout.dart';
import 'package:enchantment_game/shared_blocs_provider.dart';
import 'package:flutter/material.dart';

class EnchantmentGame extends StatelessWidget {
  const EnchantmentGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnchantGame',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: SharedBlocsProvider(
          child: GameHeader(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.3),
              child: const ResponsiveLayout(),
            ),
          ),
        ),
      ),
    );
  }
}
