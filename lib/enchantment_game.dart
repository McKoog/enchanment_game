import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_state.dart';
import 'package:enchantment_game/screens/enchant_screen/enchant_screen.dart';
import 'package:enchantment_game/screens/hunting_field_screen/hunting_field_screen.dart';
import 'package:enchantment_game/screens/shop_screen/shop_screen.dart';
import 'package:enchantment_game/shared_blocs_provider.dart';
import 'package:enchantment_game/version_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          body: SharedBlocsProvider(
            child: VersionWrapper(
              child: ColoredBox(
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
            ),
          ),
        ),
      ),
    );
  }
}
