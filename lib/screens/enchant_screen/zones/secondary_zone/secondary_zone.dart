import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/inventory_field.dart';
import 'package:flutter/cupertino.dart';

class SecondaryZone extends StatelessWidget {
  const SecondaryZone({Key? key,required this.height,required this.width}) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: Center(
            child: InventoryField(sideSize: height-20,capacity: 25,)
        )
    );
  }
}