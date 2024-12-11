import 'dart:math';

import 'package:flutter/material.dart';

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

class Particle {
  Particle({required this.orbit, required this.random}) {
    originalOrbit = orbit - random.nextDouble() * 50;
    orbit -= random.nextDouble() * 50;
    theta = random.nextDouble() * 360 * pi / 180;
    opacity = random.nextDouble() * 0.9 + 0.1;
    color = idleColors[random.nextInt(5)];
    size = random.nextDouble() * 1.5 + 0.75;
  }

  double orbit;
  late final double originalOrbit;
  double theta = 0;
  late double opacity;
  late Color color;
  late double size;

  bool _isExploding = true;

  double? _shrinkingDelta;

  bool stopUpdating = false;

  late final Random random;

  Offset polarToCartesian(double centerCorrection) {
    final dx = orbit * cos(theta);
    final dy = orbit * sin(theta);
    return Offset(dx + centerCorrection, dy + centerCorrection);
  }

  void update(Duration duration) {
    if (orbit <= 0) return;
    if (!enchantingColors.contains(color)) {
      color = enchantingColors[random.nextInt(5)];
    }
    _shrinkingDelta ??=
        (orbit - originalOrbit) / duration.inMilliseconds * 1.25 * (1000 ~/ 60);
    theta += 0.015;
    orbit -= _shrinkingDelta!;
  }

  void updateIdle() {
    if ((orbit >= 150 && orbit <= 175 && random.nextDouble() < 0.2) ||
        stopUpdating) {
      stopUpdating = true;
      theta += 0.01;
      if (random.nextDouble() > 0.5) {
        orbit += 0.2;
      } else {
        orbit -= 0.2;
      }
      return;
    }
    if (_isExploding) {
      orbit += 3.5;
      opacity -= random.nextDouble() * 0.01 + 0.01;
    } else {
      orbit += 1.5;
      opacity -= random.nextDouble() * 0.005 + 0.005;
    }

    if (opacity <= 0.3) {
      _isExploding = false;
      orbit = originalOrbit;
      opacity = random.nextDouble() * 0.9 + 0.1;
      color = idleColors[random.nextInt(5)];
      size = random.nextDouble() * 1 + 0.75;
    }
  }
}
