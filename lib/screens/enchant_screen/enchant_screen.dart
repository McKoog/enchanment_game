import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/main_zone.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/secondary_zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnchantScreen extends StatelessWidget {
  const EnchantScreen({Key? key,required this.width}) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;
    return Container(
        //color: const Color.fromRGBO(78, 78, 78, 1),
        child: SafeArea(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                      children: [
                        MainZone(height: constraints.maxHeight/2,width: width),
                        SecondaryZone(height: constraints.maxHeight/2,width: width)
                      ]);}
            )
        )
    );
  }
}