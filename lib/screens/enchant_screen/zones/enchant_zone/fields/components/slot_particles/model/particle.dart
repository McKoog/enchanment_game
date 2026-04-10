import 'dart:math';

import 'package:flutter/material.dart';

const List<int> enchantingColors = [
  0xFFFFFF00,
  0xFFFFFACD,
  0xFFFFD700,
  0xFFFFDAB9,
  0xFFFFA500,
];

const List<int> idleColors = [
  0xFFFFFFFF,
  0xFFBEBEBE,
  0xFFD3D3D3,
  0xFF808080,
  0xFFB0B0B0,
];

class Particle {
  Particle({required this.orbit, required this.random}) {
    orbit -= random.nextDouble() * 50;
    originalOrbit = orbit;
    theta = random.nextDouble() * _fullCircleRadians;
    opacity = random.nextDouble() * 0.9 + 0.1;
    color = idleColors[random.nextInt(idleColors.length)];
    size = random.nextDouble() * 0.6 + 0.4;
    orbitThetaSpeed = random.nextDouble() * 0.0035 + 0.001;
  }

  final Random random;
  double orbit;

  late final double originalOrbit;
  late double theta;
  late double opacity;
  late int color;
  late double size;
  late final double orbitThetaSpeed;

  bool _stopUpdating = false;
  bool _isExploding = true;

  static const double _fullCircleRadians = 2 * pi;

  Offset polarToCartesian(double centerCorrection) {
    final double x = orbit * cos(theta);
    final double y = orbit * sin(theta);
    return Offset(x + centerCorrection, y + centerCorrection);
  }

  void update(Duration duration, double deltaFps) {
    if (orbit <= 0) return;

    if (!enchantingColors.contains(color)) {
      color = enchantingColors[random.nextInt(enchantingColors.length)];
    }

    final double decrement = 2.5 * random.nextDouble() * deltaFps;
    theta += orbitThetaSpeed * deltaFps;
    orbit -= decrement;
  }

  void updateIdle(double deltaFps) {
    final double randomDouble = random.nextDouble();
    final double opacityDelta =
        (_isExploding ? 0.0065 : 0.0033) * deltaFps * (randomDouble + 1);

    if (_stopUpdating ||
        (randomDouble < (_isExploding ? 0.1 : 0.0075) &&
            orbit % 150 <= 60 &&
            orbit ~/ 150 > 0)) {
      if (!_stopUpdating) opacity += 0.2;
      _stopUpdating = true;
      theta += orbitThetaSpeed * deltaFps;
      return;
    }

    final double orbitIncrement = _isExploding ? 2.0 : 0.75;
    orbit += orbitIncrement * deltaFps;
    opacity -= opacityDelta;
    theta += orbitThetaSpeed * deltaFps;

    if (opacity <= 0) {
      _resetIdleState(randomDouble);
    }
  }

  void _resetIdleState(double randomDouble) {
    _isExploding = false;
    orbit = originalOrbit;
    opacity = randomDouble * 0.9 + 0.1;
    color = idleColors[random.nextInt(idleColors.length)];
    size = randomDouble * 0.6 + 0.4;
  }

  void resetToInitialState() {
    _isExploding = true;
    _stopUpdating = false;
    orbit = originalOrbit;
    theta = random.nextDouble() * _fullCircleRadians;
    opacity = random.nextDouble() * 0.9 + 0.1;
    color = idleColors[random.nextInt(idleColors.length)];
    size = random.nextDouble() * 0.6 + 0.4;
  }
}
