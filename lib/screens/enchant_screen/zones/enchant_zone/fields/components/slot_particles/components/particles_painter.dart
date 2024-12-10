import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/model/particle.dart';
import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  ParticlesPainter({required this.particles});

  final List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      paint.color = particle.color.withOpacity(particle.opacity);
      final offset = particle.polarToCartesian(size.height / 2);

      if (offset.dx >= size.height + 2 ||
          offset.dy >= size.width + 2 ||
          offset.dx <= -2 ||
          offset.dy - 2 <= -2) {
        canvas.drawCircle(offset, particle.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
