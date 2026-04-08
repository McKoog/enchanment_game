import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
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
      name: 'Fists',
      weaponType: WeaponType.fist,
      lowerDamage: 1,
      higherDamage: 1,
      critRate: 0,
      critPower: 0,
      attackSpeed: 1.0,
      enchantLevel: 0,
    ),
    WeaponType.sword: Weapon(
        id: 'template',
        type: ItemType.weapon,
        image: 'assets/icons/weapons/sword.png',
        name: 'Basic Sword',
        weaponType: WeaponType.sword,
        lowerDamage: 2,
        higherDamage: 3,
        critRate: 15,
        critPower: 50,
        attackSpeed: 0.8,
        enchantLevel: 0),
    WeaponType.bow: Weapon(
      id: 'template',
      type: ItemType.weapon,
      image: 'assets/icons/weapons/bow.png',
      name: 'Long Bow',
      weaponType: WeaponType.bow,
      lowerDamage: 1,
      higherDamage: 5,
      critRate: 10,
      critPower: 75,
      attackSpeed: 0.5,
      enchantLevel: 0,
    ),
    WeaponType.dagger: Weapon(
      id: 'template',
      type: ItemType.weapon,
      image: 'assets/icons/weapons/dagger.png',
      name: 'Dagger',
      weaponType: WeaponType.dagger,
      lowerDamage: 1,
      higherDamage: 2,
      critRate: 40,
      critPower: 100,
      attackSpeed: 1.2,
      enchantLevel: 0,
    ),
  };

  // ——— Scroll templates ———

  static final Map<ScrollType, Scroll> _scrollTemplates = {
    ScrollType.weapon: Scroll(
      id: 'template',
      type: ItemType.scroll,
      image: 'assets/icons/other_items/enchant_scroll_weapon.png',
      name: 'Weapon Enchant Scroll',
      description:
          "Increase power of the weapon, but be careful, it's not guaranteed",
      scrollType: ScrollType.weapon,
    ),
    ScrollType.armor: Scroll(
      id: 'template',
      type: ItemType.scroll,
      image: 'assets/icons/other_items/enchant_scroll_armor.png',
      name: 'Armor Enchant Scroll',
      description:
          "Increase defense of the armor, but be careful, it's not guaranteed",
      scrollType: ScrollType.armor,
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
      defense: 2,
      enchantLevel: 0,
    ),
    ArmorType.chestplate: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_breastplate.png',
      name: 'Leather Chestplate',
      armorType: ArmorType.chestplate,
      defense: 5,
      enchantLevel: 0,
    ),
    ArmorType.leggings: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_pants.png',
      name: 'Leather Leggings',
      armorType: ArmorType.leggings,
      defense: 3,
      enchantLevel: 0,
    ),
    ArmorType.boots: Armor(
      id: 'template',
      type: ItemType.armor,
      image: 'assets/icons/armors/skin_boots.png',
      name: 'Leather Boots',
      armorType: ArmorType.boots,
      defense: 1,
      enchantLevel: 0,
    ),
  };

  // ——— Public API ———

  /// The fist weapon singleton (always the same instance).
  static Weapon get fist => _weaponTemplates[WeaponType.fist]!;

  /// Create a new weapon instance with a unique id.
  static Weapon createWeapon(WeaponType weaponType) {
    final template = _weaponTemplates[weaponType];
    if (template == null) {
      throw ArgumentError('No weapon template for type: $weaponType');
    }
    final weapon = Weapon.copyWith(template);
    weapon.id = _uuid.v1();
    return weapon;
  }

  /// Create a new armor instance with a unique id.
  static Armor createArmor(ArmorType armorType) {
    final template = _armorTemplates[armorType];
    if (template == null) {
      throw ArgumentError('No armor template for type: $armorType');
    }
    final armor = Armor.copyWith(template);
    armor.id = _uuid.v1();
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
  static Item createItem(ItemType type,
      {WeaponType? weaponType, ArmorType? armorType, ScrollType? scrollType}) {
    if (type == ItemType.scroll) {
      return createScroll(scrollType ?? ScrollType.weapon);
    }
    if (type == ItemType.armor) {
      return createArmor(armorType ?? ArmorType.chestplate);
    }
    return createWeapon(weaponType ?? WeaponType.sword);
  }
}
