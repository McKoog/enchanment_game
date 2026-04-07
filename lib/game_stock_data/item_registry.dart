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
      isSvgAsset: false,
      image: 'assets/fist.png',
      name: 'Fists',
      weaponType: WeaponType.fist,
      lowerDamage: 1,
      higherDamage: 1,
      critRate: 0,
      critPower: 0,
      enchantLevel: 0,
    ),
    WeaponType.sword: Weapon(
      id: 'template',
      type: ItemType.weapon,
      image: 'assets/sword.svg',
      name: 'Basic Sword',
      weaponType: WeaponType.sword,
      lowerDamage: 2,
      higherDamage: 3,
      critRate: 15,
      critPower: 50,
      enchantLevel: 0,
    ),
    WeaponType.bow: Weapon(
      id: 'template',
      type: ItemType.weapon,
      isSvgAsset: false,
      image: 'assets/bow.png',
      name: 'Long Bow',
      weaponType: WeaponType.bow,
      lowerDamage: 1,
      higherDamage: 5,
      critRate: 10,
      critPower: 75,
      enchantLevel: 0,
    ),
    WeaponType.dagger: Weapon(
      id: 'template',
      type: ItemType.weapon,
      isSvgAsset: false,
      image: 'assets/dagger.png',
      name: 'Dagger',
      weaponType: WeaponType.dagger,
      lowerDamage: 1,
      higherDamage: 2,
      critRate: 40,
      critPower: 100,
      enchantLevel: 0,
    ),
  };

  // ——— Scroll template ———

  static final Scroll _scrollTemplate = Scroll(
    id: 'template',
    type: ItemType.scroll,
    image: 'assets/enchant_scroll.svg',
    name: 'Scroll of enchant',
    description:
        "Increase power of the weapon, but be careful, it's not guaranteed",
  );

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

  /// Create a new scroll instance with a unique id.
  static Scroll createScroll() {
    final scroll = Scroll.copyWith(_scrollTemplate);
    scroll.id = _uuid.v1();
    return scroll;
  }

  /// Convenience factory — creates an [Item] based on its type.
  ///
  /// Replaces the old `getNewStockItem` function.
  static Item createItem(ItemType type, [WeaponType? weaponType]) {
    if (type == ItemType.scroll) return createScroll();
    return createWeapon(weaponType ?? WeaponType.sword);
  }
}
