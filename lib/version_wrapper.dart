import 'package:enchantment_game/shared_variables.dart';
import 'package:flutter/material.dart';

class VersionWrapper extends StatelessWidget {
  const VersionWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
            top: 8,
            left: 8,
            child: Text(
              "v.$appVersion",
              style: const TextStyle(fontSize: 18, color: Colors.yellow),
            )),
      ],
    );
  }
}
