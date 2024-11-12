import 'package:enchantment_game/screens/enchant_screen/enchant_screen.dart';
import 'package:enchantment_game/screens/hunting_field_screen/hunting_field_screen.dart';
import 'package:enchantment_game/screens/shop_screen/shop_screen.dart';
import 'package:enchantment_game/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnchantmentGame extends StatelessWidget {
  const EnchantmentGame({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnchantGame',
      theme: ThemeData.dark(useMaterial3: true),
      home: ProviderScope(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                color: const Color.fromRGBO(78, 78, 78, 1),
                child: Row(
                  children: [
                    ShopScreen(width: width / 3),
                    EnchantScreen(width: width / 3),
                    HuntingFieldScreen(
                      width: width / 3,
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    "v.$appVersion",
                    style: const TextStyle(fontSize: 18, color: Colors.yellow),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
