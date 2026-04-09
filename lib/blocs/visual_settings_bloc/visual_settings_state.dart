class VisualSettingsState {
  VisualSettingsState({
    required this.particlesCount,
    required this.isOptimized,
    required this.showNavigationArrows,
  });

  final int particlesCount;
  final bool isOptimized;
  final bool showNavigationArrows;

  VisualSettingsState copyWith({
    int? particlesCount,
    bool? isOptimized,
    bool? showNavigationArrows,
  }) {
    return VisualSettingsState(
      particlesCount: particlesCount ?? this.particlesCount,
      isOptimized: isOptimized ?? this.isOptimized,
      showNavigationArrows: showNavigationArrows ?? this.showNavigationArrows,
    );
  }
}
