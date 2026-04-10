import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/gold_item.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/services/rarity_service.dart';
import 'package:uuid/uuid.dart';

/// Single source of truth for all item templates.
///
/// To add a new weapon:
///   1. Add a [WeaponType] enum value.
///   2. Add a template entry in [_weaponTemplates].
///   3. Add an [EnchantBonus] entry in [EnchantConfig.bonusByWeaponType].
class ItemRegistry {
  ItemRegistry._();
  static const _uuid = Uuid();

  // ——— Weapon templates ———

  static final Map<WeaponType, Weapon> _weaponTemplates = {
    WeaponType.fist: Weapon(
      id: 'fist',
      type: ItemType.weapon,
      image: 'assets/icons/weapons/fist.png',
      name: 'Fist',
      weaponType: WeaponType.fist,
      lowerDamage: 1.0,
      higherDamage: 2.0,
      critRate: 5,
      critPower: 110,
      attackSpeed: 0.25,
      enchantLevel: 0,
      sellPrice: 0,
    ),
    WeaponType.sword: Weapon(
      id: 'template',
      type: ItemType.weapon,
      image: 'assets/icons/weapons/sword.png',
      name: 'Sword',
      weaponType: WeaponType.sword,
      lowerDamage: 2.0,
      higherDamage: 5.0,
      critRate: 10,
      critPower: 150,
      attackSpeed: 1.0,
      enchantLevel: 0,
      sellPrice: 50,
    ),
    WeaponType.bow: Weapon(
      id: 'template',
      type: ItemType.weapon,
      image: 'assets/icons/weapons/bow.png',
      name: 'Long Bow',
      weaponType: WeaponType.bow,
      lowerDamage: 1.0,
      higherDamage: 10.0,
      critRate: 15,
      critPower: 120,
      attackSpeed: 1.25,
      enchantLevel: 0,
      sellPrice: 60,
    ),
    WeaponType.dagger: Weapon(
      id: 'template',
      type: ItemType.weapon,
      image: 'assets/icons/weapons/dagger.png',
      name: 'Dagger',
      weaponType: WeaponType.dagger,
      lowerDamage: 1.0,
      higherDamage: 3.0,
      critRate: 25,
      critPower: 200,
      attackSpeed: 0.5,
      enchantLevel: 0,
      sellPrice: 60,
    ),
  };

  // ——— Scroll templates ———

  static final Map<ScrollType, Scroll> _scrollTemplates = {
    ScrollType.weapon: Scroll(
      id: 'template',
      type: ItemType.scroll,
      image: 'assets/icons/other_items/enchant_scroll_weapon.png',
      name: 'Weapon Enchant Scroll',
      description: "Increase power of the weapon, but be careful, it's not guaranteed",
      scrollType: ScrollType.weapon,
      sellPrice: 25,
      buyPrice: 100,
    ),
    ScrollType.armor: Scroll(
      id: 'template',
      type: ItemType.scroll,
      image: 'assets/icons/other_items/enchant_scroll_armor.png',
      name: 'Armor Enchant Scroll',
      description: "Increase defense of the armor, but be careful, it's not guaranteed",
      scrollType: ScrollType.armor,
      sellPrice: 10,
      buyPrice: 50,
    ),
  };

  // ——— Armor templates ———

  static final Map<ArmorType, Armor> _armorTemplates = {
    ArmorType.helmet: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_helmet.png',
      name: 'Leather Helmet',
      armorType: ArmorType.helmet,
      defense: 1,
      enchantLevel: 0,
      sellPrice: 18,
      setType: ArmorSetType.leather,
    ),
    ArmorType.chestplate: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_breastplate.png',
      name: 'Leather Chestplate',
      armorType: ArmorType.chestplate,
      defense: 1,
      enchantLevel: 0,
      sellPrice: 20,
      setType: ArmorSetType.leather,
    ),
    ArmorType.leggings: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_pants.png',
      name: 'Leather Leggings',
      armorType: ArmorType.leggings,
      defense: 1,
      enchantLevel: 0,
      sellPrice: 18,
      setType: ArmorSetType.leather,
    ),
    ArmorType.boots: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_boots.png',
      name: 'Leather Boots',
      armorType: ArmorType.boots,
      defense: 1,
      enchantLevel: 0,
      sellPrice: 18,
      setType: ArmorSetType.leather,
    ),
  };

  // ——— Public API ———

  static List<String> get allImages {
    final images = <String>[];
    images.addAll(_weaponTemplates.values.map((e) => e.image));
    images.addAll(_armorTemplates.values.map((e) => e.image));
    images.addAll(_scrollTemplates.values.map((e) => e.image));
    images.add('assets/icons/other_items/coin.png');
    return images.toSet().toList();
  }

  /// The fist weapon singleton (always the same instance).
  static Weapon get fist => _weaponTemplates[WeaponType.fist]!;

  /// Create a new weapon instance with a unique id.
  static Weapon createWeapon(WeaponType weaponType, {bool generateRarity = true}) {
    final template = _weaponTemplates[weaponType];
    if (template == null) {
      throw ArgumentError('No weapon template for type: $weaponType');
    }
    final weapon = Weapon.copyWith(template);
    weapon.id = _uuid.v1();
    if (generateRarity) {
      RarityService.generateRarityForWeapon(weapon);
    }
    return weapon;
  }

  /// Create a new armor instance with a unique id.
  static Armor createArmor(ArmorType armorType, {bool generateRarity = true}) {
    final template = _armorTemplates[armorType];
    if (template == null) {
      throw ArgumentError('No armor template for type: $armorType');
    }
    final armor = Armor.copyWith(template);
    armor.id = _uuid.v1();
    if (generateRarity) {
      RarityService.generateRarityForArmor(armor);
    }
    return armor;
  }

  /// Create a new scroll instance with a unique id.
  static Scroll createScroll(ScrollType scrollType) {
    final template = _scrollTemplates[scrollType];
    if (template == null) {
      throw ArgumentError('No scroll template for type: $scrollType');
    }
    final scroll = Scroll.copyWith(template);
    scroll.id = _uuid.v1();
    return scroll;
  }

  /// Convenience factory — creates an [Item] based on its type.
  ///
  /// Replaces the old `getNewStockItem` function.
  static Item createItem(ItemType type, {WeaponType? weaponType, ArmorType? armorType, ScrollType? scrollType, bool generateRarity = true}) {
    if (type == ItemType.scroll) {
      return createScroll(scrollType ?? ScrollType.weapon);
    }
    if (type == ItemType.armor) {
      return createArmor(armorType ?? ArmorType.chestplate, generateRarity: generateRarity);
    }
    if (type == ItemType.gold) {
      return createGold(1);
    }
    return createWeapon(weaponType ?? WeaponType.sword, generateRarity: generateRarity);
  }

  static GoldItem createGold(int amount) {
    return GoldItem(
      id: _uuid.v1(),
      type: ItemType.gold,
      image: 'assets/icons/other_items/coin.png',
      amount: amount,
    );
  }
}
