import 'package:enchantment_game/models/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentScroll = StateProvider<Item?>((ref) => null);

final scrollEnchantSlotItem = StateProvider<Item?>((ref) => null);