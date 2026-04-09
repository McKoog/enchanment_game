import 'dart:math';

import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EnemyField extends StatefulWidget {
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
  State<EnemyField> createState() => EnemyFieldState();
}

class EnemyFieldState extends State<EnemyField> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.02), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.02, end: 0.02), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.02, end: 0.00), weight: 2),
    ]).animate(_shakeController);
  }

  @override
  void didUpdateWidget(EnemyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Optional: trigger shake when specific condition is met, handled externally for now.
  }

  /// Trigger a shake animation
  void shake() {
    if (_shakeController.isAnimating) {
      _shakeController.reset();
    }
    _shakeController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use available height if given, otherwise fall back to width-based sizing.
    final double sideSize;
    if (widget.availableHeight != null) {
      // Use the smaller of width-based and height-based sizing, minus margin.
      final double marginTotal = widget.availableHeight! * 0.1; // 5% margin each side
      sideSize = (widget.availableHeight! - marginTotal).clamp(40, widget.width - 100);
    } else {
      sideSize = widget.width - 200;
    }

    final double margin = widget.availableHeight != null ? (widget.availableHeight! * 0.05).clamp(4, 32) : 32.0;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shakeAnimation.value * pi,
          child: child,
        );
      },
      child: Container(
        height: sideSize,
        width: sideSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.overlayMedium, spreadRadius: 10, blurRadius: 100)],
        ),
        margin: EdgeInsets.all(margin),
        child: Image.asset(
          widget.assetImageLink,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
