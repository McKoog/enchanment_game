sealed class VisualSettingsEvent {}

class VisualSettingsEvent$ChangeCount extends VisualSettingsEvent {
  VisualSettingsEvent$ChangeCount({required this.count});

  final int count;
}

class VisualSettingsEvent$ChangeOptimized extends VisualSettingsEvent {
  VisualSettingsEvent$ChangeOptimized({required this.isOptimized});

  final bool isOptimized;
}

class VisualSettingsEvent$ChangeShowNavigationArrows extends VisualSettingsEvent {
  VisualSettingsEvent$ChangeShowNavigationArrows({required this.showNavigationArrows});

  final bool showNavigationArrows;
}

class VisualSettingsEvent$ChangeMusicVolume extends VisualSettingsEvent {
  VisualSettingsEvent$ChangeMusicVolume({required this.volume});

  final double volume;
}

class VisualSettingsEvent$ChangeSoundVolume extends VisualSettingsEvent {
  VisualSettingsEvent$ChangeSoundVolume({required this.volume});

  final double volume;
}
