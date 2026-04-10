import 'package:flutter_bloc/flutter_bloc.dart';
import 'equip_overlay_event.dart';
import 'equip_overlay_state.dart';

class EquipOverlayBloc extends Bloc<EquipOverlayEvent, EquipOverlayState> {
  EquipOverlayBloc() : super(EquipOverlayState$Hidden()) {
    on<EquipOverlayEvent$Toggle>((event, emit) {
      if (state is EquipOverlayState$Visible &&
          (state as EquipOverlayState$Visible).overlayType == event.overlayType) {
        emit(EquipOverlayState$Hidden());
      } else {
        emit(EquipOverlayState$Visible(overlayType: event.overlayType));
      }
    });

    on<EquipOverlayEvent$Hide>((event, emit) {
      emit(EquipOverlayState$Hidden());
    });
  }
}
