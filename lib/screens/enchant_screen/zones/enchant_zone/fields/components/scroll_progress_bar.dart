import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnchantProgressBar extends ConsumerStatefulWidget {
  const EnchantProgressBar({super.key, required this.parentSize});

  final double parentSize;

  @override
  ConsumerState<EnchantProgressBar> createState() => _EnchantProgressBarState();
}

class _EnchantProgressBarState extends ConsumerState<EnchantProgressBar>
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
    return SizedBox(
        width: widget.parentSize / 1.6,
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            return LinearProgressIndicator(
              minHeight: 20,
              color: Colors.white,
              backgroundColor: const Color.fromRGBO(130, 130, 130, 1),
              value: controller.value,
            );
          },
        ));
  }
}