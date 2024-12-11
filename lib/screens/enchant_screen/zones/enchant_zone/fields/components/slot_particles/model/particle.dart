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
  Particle({required this.orbit, required this.random}){
    originalOrbit = orbit - random.nextDouble() * 50;
    orbit -= random.nextDouble() * 50;
    theta = random.nextDouble() * 360 * pi / 180;
    opacity = random.nextDouble() * 0.9 + 0.1;
    color = idleColors[random.nextInt(5)];
    size = random.nextDouble() * 1.5 + 0.75;
  }

  final Random random;
  double orbit;

  late final double originalOrbit;
  late double theta;
  late double opacity;
  late Color color;
  late double size;

  bool _stopUpdating = false;
  bool _isExploding = true;

  Offset polarToCartesian(double centerCorrection) {
    return Offset(orbit * cos(theta) + centerCorrection, orbit * sin(theta) + centerCorrection);
  }

  void update(Duration duration, double deltaFps) {
    if (orbit <= 0) return;
    if (!enchantingColors.contains(color)) {
      color = enchantingColors[random.nextInt(5)];
    }
    theta += 0.0075 * deltaFps;
    orbit -= 1.0 * deltaFps;
  }

  void updateIdle(double deltaFps) {
    if (_stopUpdating || random.nextDouble() < 0.10 && orbit % 150 <= 40 && orbit ~/ 150 > 0) {
      _stopUpdating = true;
      theta += 0.0025 * deltaFps;
      if(random.nextDouble() > 0.5){
        orbit += 0.075;
      }else{
        orbit -= 0.075;
      }
      return;
    }
    if (_isExploding) {
      orbit += 1.75 * deltaFps;
      opacity -= (random.nextDouble() * 0.005 + 0.005) * deltaFps;
    } else {
      orbit += 0.75 * deltaFps;
      opacity -= (random.nextDouble() * 0.0025 + 0.0025) * deltaFps;
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
