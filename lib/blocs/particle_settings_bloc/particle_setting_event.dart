sealed class ParticleSettingEvent {}

class ParticleSettingEvent$ChangeCount extends ParticleSettingEvent {
  ParticleSettingEvent$ChangeCount({required this.count});

  final int count;
}

class ParticleSettingEvent$ChangeOptimized extends ParticleSettingEvent {
  ParticleSettingEvent$ChangeOptimized({required this.isOptimized});

  final bool isOptimized;
}
