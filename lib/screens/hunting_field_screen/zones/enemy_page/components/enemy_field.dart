import 'package:flutter/material.dart';

class EnemyField extends StatelessWidget {
  const EnemyField({
    super.key,
    required this.width,
    required this.assetImageLink,
    this.availableHeight,
  });

  final double width;
  final String assetImageLink;

  /// If provided, the enemy image scales to fit this height.
  final double? availableHeight;

  @override
  Widget build(BuildContext context) {
    // Use available height if given, otherwise fall back to width-based sizing.
    final double sideSize;
    if (availableHeight != null) {
      // Use the smaller of width-based and height-based sizing, minus margin.
      final double marginTotal = availableHeight! * 0.1; // 5% margin each side
      sideSize = (availableHeight! - marginTotal).clamp(40, width - 100);
    } else {
      sideSize = width - 200;
    }

    final double margin =
        availableHeight != null ? (availableHeight! * 0.05).clamp(4, 32) : 32.0;

    return Container(
      height: sideSize,
      width: sideSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.43),
              spreadRadius: 10,
              blurRadius: 100)
        ],
      ),
      margin: EdgeInsets.all(margin),
      child: Image.asset(assetImageLink, fit: BoxFit.contain),
    );
  }
}
