import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_event.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoBackground extends StatelessWidget {
  const InfoBackground({super.key, required this.sideSize, this.backgroundItem, required this.child});

  final double sideSize;
  final Widget child;
  final Item? backgroundItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //decoration: enchantFieldDecoration,
        height: sideSize - 24,
        width: sideSize - 24,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            if (backgroundItem != null)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Opacity(
                    opacity: 0.85, child: Image.asset(backgroundItem!.image)),
              ),
            child,
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<ItemInfoBloc>().add(ItemInfoEvent$CloseInfo());
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.yellow,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
