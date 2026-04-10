enum OverlayType { weapon, armor, all }

abstract class EquipOverlayState {}

class EquipOverlayState$Hidden extends EquipOverlayState {}

class EquipOverlayState$Visible extends EquipOverlayState {
  final OverlayType overlayType;

  EquipOverlayState$Visible({required this.overlayType});
}
