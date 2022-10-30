import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentScroll = StateProvider<Item?>((ref) => null);

final currentWeapon = StateProvider<Item?>((ref) => null);

final scrollEnchantSlotItem = StateProvider<Weapon?>((ref) => null);

final currentEnchantSuccess = StateProvider<bool?>((ref) => null);