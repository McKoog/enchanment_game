import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_event.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VisualSettingsBloc
    extends Bloc<VisualSettingsEvent, VisualSettingsState> {
  VisualSettingsBloc()
      : super(VisualSettingsState(
            particlesCount: 5000,
            isOptimized: true,
            showNavigationArrows: true)) {
    on<VisualSettingsEvent>((event, emit) => switch (event) {
          VisualSettingsEvent$ChangeCount() => _changeCount(event, emit),
          VisualSettingsEvent$ChangeOptimized() =>
            _changeOptimized(event, emit),
          VisualSettingsEvent$ChangeShowNavigationArrows() =>
            _changeShowNavigationArrows(event, emit),
        });
  }

  void _changeCount(VisualSettingsEvent$ChangeCount event,
      Emitter<VisualSettingsState> emit) {
    emit(state.copyWith(particlesCount: event.count));
  }

  void _changeOptimized(VisualSettingsEvent$ChangeOptimized event,
      Emitter<VisualSettingsState> emit) {
    emit(state.copyWith(isOptimized: event.isOptimized));
  }

  void _changeShowNavigationArrows(
      VisualSettingsEvent$ChangeShowNavigationArrows event,
      Emitter<VisualSettingsState> emit) {
    emit(state.copyWith(showNavigationArrows: event.showNavigationArrows));
  }
}
