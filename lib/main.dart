import 'dart:convert';

import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/screens/enchant_screen/enchant_screen.dart';
import 'package:enchantment_game/screens/hunting_field_screen/hunting_field_screen.dart';
import 'package:enchantment_game/screens/shop_screen/shop_screen.dart';
import 'package:enchantment_game/startapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';

bool isMobile = UniversalPlatform.isIOS || UniversalPlatform.isAndroid;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late String appVersion;

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  @override
  void initState() {
    appVersion = "Unknown";
    initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnchantGame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ProviderScope(
          child: StartApp(
            child: Stack(
              children: [

                Container(
                  color: const Color.fromRGBO(78, 78, 78, 1),
                  child: isMobile
                      ?PageView(
                    children: [
                      EnchantScreen(width: screenSize.width,),
                      HuntingFieldScreen(width: screenSize.width,)],
                  )
                      :Row(
                        children: [
                          ShopScreen(width: screenSize.width/3),
                          EnchantScreen(width:screenSize.width/3),
                          HuntingFieldScreen(width: screenSize.width/3,),
                        ],
                      ),
                ),
                Positioned(top:8,left:8,child: Text("v.$appVersion",style: const TextStyle(fontSize: 18,color: Colors.yellow),)),
              ],
            ),
          ),
            //child: EnchantScreen()
        ),
      ),
    );
  }
}