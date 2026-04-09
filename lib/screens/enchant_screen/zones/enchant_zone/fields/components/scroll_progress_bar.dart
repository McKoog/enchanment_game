import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EnchantProgressBar extends StatefulWidget {
  const EnchantProgressBar({super.key, required this.parentSize});

  final double parentSize;

  @override
  State<EnchantProgressBar> createState() => _EnchantProgressBarState();
}

class _EnchantProgressBarState extends State<EnchantProgressBar>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 1,
        duration: const Duration(milliseconds: 1200));
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
          width: widget.parentSize / 1.6,
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              return LinearProgressIndicator(
                minHeight: 20,
                color: AppColors.white,
                backgroundColor: AppColors.panelBorder,
                value: controller.value,
              );
            },
          )),
    );
  }
}
