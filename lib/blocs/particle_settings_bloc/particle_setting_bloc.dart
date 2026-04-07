import 'package:enchantment_game/blocs/particle_settings_bloc/particle_setting_event.dart';
import 'package:enchantment_game/blocs/particle_settings_bloc/particle_setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticleSettingBloc extends Bloc<ParticleSettingEvent, ParticleSettingsState> {
  ParticleSettingBloc() : super(ParticleSettingsState(particlesCount: 5000, isOptimized: true)) {
    on<ParticleSettingEvent>((event, emit) => switch (event) {
          ParticleSettingEvent$ChangeCount() => _changeCount(event, emit),
          ParticleSettingEvent$ChangeOptimized() => _changeOptimized(event, emit),
        });
  }

  void _changeCount(ParticleSettingEvent$ChangeCount event, Emitter<ParticleSettingsState> emit) {
    emit(ParticleSettingsState(particlesCount: event.count, isOptimized: state.isOptimized));
  }

  void _changeOptimized(ParticleSettingEvent$ChangeOptimized event, Emitter<ParticleSettingsState> emit) {
    emit(
      ParticleSettingsState(
        particlesCount: state.particlesCount,
        isOptimized: !state.isOptimized,
      ),
    );
  }
}
