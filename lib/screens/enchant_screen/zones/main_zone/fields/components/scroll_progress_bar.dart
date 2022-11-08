import 'package:enchantment_game/data_providers/animation_providers.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnchantProgressBar extends ConsumerStatefulWidget {
  const EnchantProgressBar({Key? key,required this.parentSize}) : super(key: key);
  final double parentSize;

  @override
  ConsumerState<EnchantProgressBar> createState() => _EnchantProgressBarState();
}

class _EnchantProgressBarState extends ConsumerState<EnchantProgressBar> with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    controller = AnimationController(vsync: this, lowerBound: 0, upperBound: 1,duration: const Duration(milliseconds: 1200));
    controller.addListener(() {
      if(controller.value == 1){
        ref.read(finishedProgressBarAnimation.notifier).update((state) => true);
        ref.read(showScrollProgressBar.notifier).update((state) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool animStarted = ref.watch(startProgressBarAnimation);
    if(animStarted){controller.forward();}
    return SizedBox(
        height:ref.watch(scrollEnchantSlotItem) != null
            ?null
            :0,
        width:widget.parentSize/1.6,
        child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              return LinearProgressIndicator(minHeight: 20,color: Colors.white,backgroundColor: const Color.fromRGBO(130, 130, 130, 1),value: controller.value,);
            },
    ));
  }
}
