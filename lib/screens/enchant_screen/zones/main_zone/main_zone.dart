import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/scroll_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainZone extends ConsumerWidget {
  const MainZone({Key? key, required this.height,required this.width}) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SizedBox(
      height: height,
      width: width,
      child: Align(
        alignment: Alignment.center,
        child: ref.watch(showEnchantmentScreen)
            ?ScrollField(sideSize: height)
            :const SizedBox(),),
    );
  }
}