import 'dart:async';
import 'dart:convert';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/data_providers/shared_pref_provider.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartApp extends ConsumerStatefulWidget {
  const StartApp({Key? key,required this.child}) : super(key: key);

  final Widget child;

  @override
  ConsumerState<StartApp> createState() => _StartAppState();
}

class _StartAppState extends ConsumerState<StartApp> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _prefs.then((value) {
      ref.read(sharedPrefProvider.notifier).update((state) => value);
      //startSaveTimer();
      String? invJson = value.getString("inventory");
      if(invJson != null){
        var savedInventory = Inventory.fromJson(jsonDecode(invJson));
        ref.read(inventory.notifier).update((state) => savedInventory);
      }
    });
    super.initState();
  }

  // startSaveTimer(){
  //   Timer.periodic(Duration(minutes: 1), (timer) async {
  //     var inv = ref.read(inventory);
  //     String json = jsonEncode(inv.toJson());
  //     final pref = await SharedPreferences.getInstance();
  //     pref.setString("inventory", json);
  //     print("SAVE INVENTORY = $json");
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
