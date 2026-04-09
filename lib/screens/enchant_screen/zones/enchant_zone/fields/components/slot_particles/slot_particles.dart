import 'dart:math';

import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_bloc.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_state.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/components/particles_painter.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/components/slot_particles/model/particle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlotParticles extends StatefulWidget {
  const SlotParticles(
      {super.key, required this.slotSideSize, required this.child});

  final Widget? child;

  final double slotSideSize;

  @override
  State<SlotParticles> createState() => _SlotParticlesState();
}

class _SlotParticlesState extends State<SlotParticles>
    with TickerProviderStateMixin {
  final Random _random = Random();
  late final List<Particle> _particles;

  bool? _isIdling;

  final slotBorderSize = 2;
  final shrinkParticlesDuration = const Duration(milliseconds: 1200);

  bool shouldResetParticles = false;

  late final Ticker _ticker;

  Duration _lastUpdateTime = Duration.zero;

  @override
  void initState() {
    _particles =
        genParticles(context.read<VisualSettingsBloc>().state.particlesCount);
    _ticker = createTicker((elapsed) {
      // 120 FPS = ~8.33 ms
      if (elapsed - _lastUpdateTime >= const Duration(microseconds: 8333)) {
        updateParticles(
            isIdling: _isIdling,
            deltaFps: (elapsed - _lastUpdateTime).inMicroseconds / 8333);

        _lastUpdateTime = elapsed;
      }
    });
    _ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  void updateParticles({bool? isIdling, required double deltaFps}) {
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
            particle.updateIdle(deltaFps);
          }
        });
      case false:
        setState(() {
          for (var particle in _particles) {
            particle.update(shrinkParticlesDuration, deltaFps);
          }
        });
    }
  }

  List<Particle> genParticles(int length) {
    return List<Particle>.generate(
        length,
        (index) => Particle(
            orbit: widget.slotSideSize / 2 - slotBorderSize, random: _random));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisualSettingsBloc, VisualSettingsState>(
        builder: (context, state) {
      if (state.particlesCount > _particles.length) {
        _particles
            .addAll(genParticles(state.particlesCount - _particles.length));
      } else if (state.particlesCount < _particles.length) {
        _particles.removeRange(state.particlesCount, _particles.length);
      }

      return BlocListener<EnchantBloc, EnchantState>(
        bloc: context.read<EnchantBloc>(),
        listener: (BuildContext context, state) {
          switch (state) {
            case EnchantState$EnchantmentInProgress():
              _isIdling = false;
            case EnchantState$Idle idle:
              if (idle.insertedItem != null) {
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
            painter: ParticlesPainter(
              particles: _particles,
              isOptimized: state.isOptimized,
            ),
            child: widget.child,
          ),
        ),
      );
    });
  }
}
