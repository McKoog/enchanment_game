import 'equip_overlay_state.dart';

abstract class EquipOverlayEvent {}

class EquipOverlayEvent$Toggle extends EquipOverlayEvent {
  final OverlayType overlayType;

  EquipOverlayEvent$Toggle({required this.overlayType});
}

class EquipOverlayEvent$Hide extends EquipOverlayEvent {}
