import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/screens/menu_screen/blacksmith/blacksmith_menu.dart';
import 'package:enchantment_game/screens/menu_screen/equip/equip_menu.dart';
import 'package:enchantment_game/screens/menu_screen/shop/shop_menu.dart';
import 'package:enchantment_game/screens/menu_screen/skills/skills_menu.dart';
import 'package:flutter/material.dart';

enum _MenuSection { home, equip, shop, blacksmith, skills }

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, this.width});

  final double? width;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  _MenuSection _section = _MenuSection.home;

  void _goHome() {
    setState(() {
      _section = _MenuSection.home;
    });
  }

  void _open(_MenuSection section) {
    setState(() {
      _section = section;
    });
  }

  String _titleForSection(_MenuSection section) {
    return switch (section) {
      _MenuSection.home => 'Menu',
      _MenuSection.equip => 'Equip',
      _MenuSection.shop => 'Shop',
      _MenuSection.blacksmith => 'Blacksmith',
      _MenuSection.skills => 'Skills',
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth = widget.width ?? constraints.maxWidth;

        const horizontalPadding = 16.0;
        const spacing = 12.0;
        const maxColumns = 4;
        const minTileSize = 72.0;

        final available = (effectiveWidth - horizontalPadding * 2).clamp(0.0, double.infinity);
        final possibleColumns = ((available + spacing) / (minTileSize + spacing)).floor().clamp(1, maxColumns);
        final tileSize = possibleColumns == 0 ? minTileSize : (available - spacing * (possibleColumns - 1)) / possibleColumns;

        return SizedBox(
          width: effectiveWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8,
              ),
              _MenuHeader(
                title: _titleForSection(_section),
                showBack: _section != _MenuSection.home,
                onBack: _goHome,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child: switch (_section) {
                    _MenuSection.home => _MenuGrid(
                        key: const ValueKey('menu_grid'),
                        tileSize: tileSize,
                        spacing: spacing,
                        horizontalPadding: horizontalPadding,
                        onEquipTap: () => _open(_MenuSection.equip),
                        onShopTap: () => _open(_MenuSection.shop),
                        onBlacksmithTap: () => _open(_MenuSection.blacksmith),
                        onSkillsTap: () => _open(_MenuSection.skills),
                      ),
                    _MenuSection.equip => const EquipMenu(key: ValueKey('equip_menu')),
                    _MenuSection.shop => const ShopMenu(key: ValueKey('shop_menu')),
                    _MenuSection.blacksmith => const BlacksmithMenu(key: ValueKey('blacksmith_menu')),
                    _MenuSection.skills => const SkillsMenu(key: ValueKey('skills_menu')),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({
    required this.title,
    required this.showBack,
    required this.onBack,
  });

  final String title;
  final bool showBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            height: 28,
            width: 48,
            child: showBack
                ? InkWell(
                    onTap: onBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.yellow,
                      size: 28,
                    ),
                  )
                : null,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: huntFieldNameTextDecoration,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({
    super.key,
    required this.tileSize,
    required this.spacing,
    required this.horizontalPadding,
    required this.onEquipTap,
    required this.onShopTap,
    required this.onBlacksmithTap,
    required this.onSkillsTap,
  });

  final double tileSize;
  final double spacing;
  final double horizontalPadding;
  final VoidCallback onEquipTap;
  final VoidCallback onShopTap;
  final VoidCallback onBlacksmithTap;
  final VoidCallback onSkillsTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: [
          _MenuTile(
            title: 'Equip',
            size: tileSize,
            backgroundAsset: 'assets/icons/menus/equip_icon.png',
            onTap: onEquipTap,
          ),
          _MenuTile(
            title: 'Shop',
            size: tileSize,
            backgroundAsset: 'assets/icons/menus/shop_icon.png',
            onTap: onShopTap,
          ),
          _MenuTile(
            title: 'Blacksmith',
            size: tileSize,
            backgroundAsset: 'assets/icons/menus/blacksmith_icon.png',
            onTap: onBlacksmithTap,
          ),
          _MenuTile(
            title: 'Skills',
            size: tileSize,
            backgroundAsset: 'assets/icons/menus/skills_icon.png',
            onTap: onSkillsTap,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.title,
    required this.size,
    required this.backgroundAsset,
    required this.onTap,
  });

  final String title;
  final double size;
  final String backgroundAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = huntFieldHeaderTextDecoration.copyWith(
      fontSize: 18,
      color: Colors.yellow,
    );

    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      backgroundAsset,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.25),
                      colorBlendMode: BlendMode.lighten,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color.fromRGBO(25, 25, 25, 1),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: const Border.fromBorderSide(BorderSide(color: Color.fromRGBO(160, 160, 160, 1), width: 2)),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: labelStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
