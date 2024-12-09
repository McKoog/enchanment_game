import 'dart:math';

import 'package:flutter/material.dart';

class Particle {
  Particle({required this.orbit, required this.random}) {
    originalOrbit = orbit - random.nextDouble() * 50;
    orbit -= random.nextDouble() * 50;
    theta = random.nextDouble() * 360 * pi / 180;
    opacity = random.nextDouble() * 0.9 + 0.1;
    color = idleColors[random.nextInt(5)];
    size = random.nextDouble() * 1.5 + 0.75;
  }

  final List<Color> enchantingColors = [
    Colors.yellow,
    Colors.yellow.shade200,
    Colors.yellow.shade800,
    Colors.orangeAccent.shade200,
    Colors.orange.shade800,
  ];

  final List<Color> idleColors = [
    Colors.white,
    Colors.grey.shade400,
    Colors.grey.shade200,
    Colors.grey.shade500,
    Colors.grey.shade300
  ];

  double orbit;
  late final double originalOrbit;
  late final double theta;
  late double opacity;
  late Color color;
  late double size;

  bool _isExploding = true;

  double? _shrinkingDelta;

  late final Random random;

  Offset polarToCartesian(double centerCorrection) {
    final dx = orbit * cos(theta);
    final dy = orbit * sin(theta);
    return Offset(dx + centerCorrection, dy + centerCorrection);
  }

  void update(Duration duration) {
    if (orbit <= 0) return;
    if(!enchantingColors.contains(color)) {
      color = enchantingColors[random.nextInt(5)];
    }
    _shrinkingDelta ??=
        (orbit - originalOrbit) / duration.inMilliseconds * (1000 ~/ 60);
    orbit -= _shrinkingDelta!;
  }

  void updateIdle() {
    if (_isExploding) {
      orbit += 3.5;
      opacity -= random.nextDouble() * 0.01 + 0.01;
    } else {
      orbit += 1.5;
      opacity -= random.nextDouble() * 0.005 + 0.005;
    }

    if (opacity <= 0) {
      _isExploding = false;
      orbit = originalOrbit;
      opacity = random.nextDouble() * 0.9 + 0.1;
      color = idleColors[random.nextInt(5)];
      size = random.nextDouble() * 1 + 0.75;
    }
  }
}
