import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseEnchantZoneField extends ConsumerWidget {
  const BaseEnchantZoneField({Key? key,required this.sideSize,this.backgroundItem,required this.child}) : super(key: key);
  final double sideSize;
  final Widget child;
  final Item? backgroundItem;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
        //decoration: enchantFieldDecoration,
        height:sideSize-24,
        width: sideSize-24,
        child:backgroundItem != null
                ?Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Opacity(opacity:0.2,child: backgroundItem!.isSvgAsset?SvgPicture.asset(backgroundItem!.image):Image.asset(backgroundItem!.image)),
                        ),
                        child
                    ],
                )
                :child
    );
  }
}