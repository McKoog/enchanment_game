import 'dart:ui';

import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/model/particle.dart';
import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  ParticlesPainter({required this.particles});

  final List<Particle> particles;

  final Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 0.9
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // if(enchantingColors.contains(particles.first.color))_paint.color = Colors.yellow;
    //
    // final points = particles.map((p)=>p.polarToCartesian(size.height / 2)).toList();
    //
    // canvas.drawPoints(PointMode.points, points, _paint);

    for (var particle in particles) {
      _paint.color = particle.color.withOpacity(particle.opacity);
      canvas.drawCircle(
          particle.polarToCartesian(size.height / 2), particle.size, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
