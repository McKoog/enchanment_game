import 'package:audioplayers/audioplayers.dart';
import 'package:enchantment_game/services/sound_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Runner {
  static Future<void> run(Widget child) => _prepareApp(child: child);

  static Future<void> _prepareApp({required Widget child}) async {
    WidgetsFlutterBinding.ensureInitialized();
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;

    // Set global audio context to prevent sounds from interrupting each other on Android
    await AudioPlayer.global.setAudioContext(AudioContext(
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
    ));

    SoundService().playMainTheme();
    runApp(child);
  }
}

late final String appVersion;
