import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:flutter/material.dart';

class ScrollFieldButton extends StatelessWidget {
  const ScrollFieldButton(
      {super.key,
      required this.parentSize,
      required this.caption,
      required this.onPressed});

  final double parentSize;
  final Function()? onPressed;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: parentSize / 10,
      width: parentSize / 3,
      child: ElevatedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            textStyle: scrollBottonsTextDecoration,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            ),
            backgroundColor: const Color.fromRGBO(130, 130, 130, 1)),
        child: AutoSizeText(
          caption,
          style: scrollBottonsTextDecoration,
        ),
      ),
    );
  }
}
