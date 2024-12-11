import 'dart:async';
import 'dart:math';

import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/components/particles_painter.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/model/particle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlotParticles extends StatefulWidget {
  const SlotParticles(
      {super.key, required this.slotSideSize, required this.child});

  final Widget? child;

  final double slotSideSize;

  @override
  State<SlotParticles> createState() => _SlotParticlesState();
}

class _SlotParticlesState extends State<SlotParticles> {
  final Random _random = Random();
  late final List<Particle> _particles;
  late final Timer _animationTimer;

  bool? _isIdling;

  final slotBorderSize = 2;
  final shrinkParticlesDuration = const Duration(milliseconds: 1200);

  bool shouldResetParticles = false;

  @override
  void initState() {
    _particles = genParticles(5000);
    _animationTimer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ 60),
          (_) => updateParticles(isIdling: _isIdling),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  void updateParticles({bool? isIdling}) {
    switch (isIdling) {
      case null:
        if (shouldResetParticles) {
          setState(() {
            shouldResetParticles = false;
            for (var particle in _particles) {
              particle.orbit = particle.originalOrbit;
            }
          });
        }
        return;
      case true:
        setState(() {
          for (var particle in _particles) {
            particle.updateIdle();
          }
        });
      case false:
        setState(() {
          for (var particle in _particles) {
            particle.update(shrinkParticlesDuration);
          }
        });
    }
  }

  List<Particle> genParticles(int length) {
    return List<Particle>.generate(
        length,
            (index) =>
            Particle(
                orbit: widget.slotSideSize / 2 - slotBorderSize,
                random: _random));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnchantBloc, EnchantState>(
      bloc: context.read<EnchantBloc>(),
      listener: (BuildContext context, state) {
        switch (state) {
          case EnchantState$EnchantmentInProgress():
            _isIdling = false;
          case EnchantState$Idle idle:
            if (idle.insertedWeapon != null) {
              _isIdling = true;
            }
            break;
          case EnchantState$Result():
            _isIdling = null;
            shouldResetParticles = true;
        }
      },
      child: RepaintBoundary(
        child: CustomPaint(
          isComplex: true,
          willChange: true,
          painter: ParticlesPainter(particles: _particles),
          child: widget.child,
        ),
      ),
    );
  }
}
