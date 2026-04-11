import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';

class SoundService with WidgetsBindingObserver {
  static final SoundService _instance = SoundService._internal();

  factory SoundService() {
    return _instance;
  }

  final Map<String, AudioPool> _pools = {};

  double _musicVolume = 1.0;
  double _soundVolume = 1.0;

  SoundService._internal() {
    WidgetsBinding.instance.addObserver(this);

    FlameAudio.audioCache.prefix = 'assets/';

    final bgmAudioContext = AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
        options: const {AVAudioSessionOptions.mixWithOthers},
      ),
    );

    final sfxAudioContext = AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
        options: const {AVAudioSessionOptions.mixWithOthers},
      ),
    );

    AudioPlayer.global.setAudioContext(sfxAudioContext);
    FlameAudio.bgm.audioPlayer.setAudioContext(bgmAudioContext);

    _initPool('sounds/lvl_up.mp3', 1, 2);
    _initPool('sounds/player_attack.mp3', 3, 6);
    _initPool('sounds/critical_hit.mp3', 2, 4);
    _initPool('sounds/blocked_damage.mp3', 2, 4);
    _initPool('sounds/enchant_fail.mp3', 1, 2);
    _initPool('sounds/enchant_success.mp3', 1, 2);
    _initPool('sounds/enemy_attack.mp3', 3, 6);
    _initPool('sounds/enemy_critical_hit.mp3', 2, 4);
  }

  Future<void> _initPool(
      String assetPath, int minPlayers, int maxPlayers) async {
    _pools[assetPath] = await AudioPool.create(
      source: AssetSource(assetPath),
      minPlayers: minPlayers,
      maxPlayers: maxPlayers,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      if (FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      FlameAudio.bgm.resume();
    }
  }

  Future<void> _playFromPool(String assetPath, double volumeMultiplier) async {
    final pool = _pools[assetPath];
    if (pool == null) return;

    await pool.start(volume: volumeMultiplier * _soundVolume);
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume;
    FlameAudio.bgm.audioPlayer.setVolume(_musicVolume);
  }

  void setSoundVolume(double volume) {
    _soundVolume = volume;
  }

  // BGM
  Future<bool> playMainTheme() async {
    try {
      if (FlameAudio.bgm.isPlaying) {
        return true;
      }
      await FlameAudio.bgm
          .play('sounds/themes/Lineage_Gludin.mp3', volume: _musicVolume);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> stopMainTheme() async {
    await FlameAudio.bgm.stop();
  }

  // Sound Effects
  Future<void> playLevelUpSound() async {
    await _playFromPool('sounds/lvl_up.mp3', 1.0);
  }

  Future<void> playPlayerAttackSound() async {
    await _playFromPool('sounds/player_attack.mp3', 0.8);
  }

  Future<void> playCriticalHitSound() async {
    await _playFromPool('sounds/critical_hit.mp3', 0.33);
  }

  Future<void> playBlockedDamageSound() async {
    await _playFromPool('sounds/blocked_damage.mp3', 0.25);
  }

  Future<void> playEnchantFailSound() async {
    await _playFromPool('sounds/enchant_fail.mp3', 1.0);
  }

  Future<void> playEnchantSuccessSound() async {
    await _playFromPool('sounds/enchant_success.mp3', 1.0);
  }

  Future<void> playHealSound() async {
    // await _playFromPool('sounds/heal.mp3', 0.15);
  }

  Future<void> playEnemyAttackSound() async {
    await _playFromPool('sounds/enemy_attack.mp3', 1.0);
  }

  Future<void> playEnemyCriticalHitSound() async {
    await _playFromPool('sounds/enemy_critical_hit.mp3', 0.35);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlameAudio.bgm.dispose();
    for (var pool in _pools.values) {
      pool.dispose();
    }
  }
}
