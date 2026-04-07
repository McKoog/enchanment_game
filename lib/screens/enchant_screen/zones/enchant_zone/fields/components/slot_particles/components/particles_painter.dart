import 'dart:ui';

import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/model/particle.dart';
import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  ParticlesPainter({required this.particles, required this.isOptimized});

  final List<Particle> particles;

  final bool isOptimized;

  final Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 0.6
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (isOptimized) {
      if (enchantingColors.contains(particles.first.color)) {
        _paint.color = Colors.yellow;
      }

      final points =
          particles.map((p) => p.polarToCartesian(size.height / 2)).toList();

      if (points.length >= 5000) {
        for (int i = 0; i < points.length ~/ 5000; i++) {
          final pointGroup = points.getRange(i * 5000, (i + 1) * 5000).toList();
          canvas.drawPoints(PointMode.points, pointGroup, _paint);
        }
      } else {
        canvas.drawPoints(PointMode.points, points, _paint);
      }
    } else {
      for (var particle in particles) {
        _paint.color = Color(particle.color)
            .withValues(alpha: particle.opacity.clamp(0.0, 1.0));
        canvas.drawCircle(
            particle.polarToCartesian(size.height / 2), particle.size, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
