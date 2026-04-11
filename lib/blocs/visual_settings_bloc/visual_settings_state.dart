class VisualSettingsState {
  VisualSettingsState({
    required this.particlesCount,
    required this.isOptimized,
    required this.showNavigationArrows,
    required this.musicVolume,
    required this.soundVolume,
  });

  final int particlesCount;
  final bool isOptimized;
  final bool showNavigationArrows;
  final double musicVolume;
  final double soundVolume;

  VisualSettingsState copyWith({
    int? particlesCount,
    bool? isOptimized,
    bool? showNavigationArrows,
    double? musicVolume,
    double? soundVolume,
  }) {
    return VisualSettingsState(
      particlesCount: particlesCount ?? this.particlesCount,
      isOptimized: isOptimized ?? this.isOptimized,
      showNavigationArrows: showNavigationArrows ?? this.showNavigationArrows,
      musicVolume: musicVolume ?? this.musicVolume,
      soundVolume: soundVolume ?? this.soundVolume,
    );
  }
}
