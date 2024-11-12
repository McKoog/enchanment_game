import 'package:enchantment_game/shared_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Runner{
  static Future<void> run(Widget child) => _prepareApp(child: child);

  static Future<void> _prepareApp({required Widget child}) async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    runApp(child);
  }
}