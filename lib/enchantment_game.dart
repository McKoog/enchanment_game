import 'package:enchantment_game/responsive_layout.dart';
import 'package:enchantment_game/shared_blocs_provider.dart';
import 'package:enchantment_game/version_wrapper.dart';
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
          child: VersionWrapper(
            child: ColoredBox(
              color: const Color.fromRGBO(78, 78, 78, 1),
              child: const ResponsiveLayout(),
            ),
          ),
        ),
      ),
    );
  }
}
