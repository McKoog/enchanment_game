import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:enchantment_game/theme/app_typography.dart';

class ShopListItem extends StatefulWidget {
  final Item item;
  final String title;
  final String subtitle;
  final void Function(LayerLink) onTap;

  const ShopListItem({
    super.key,
    required this.item,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<ShopListItem> createState() => _ShopListItemState();
}

class _ShopListItemState extends State<ShopListItem> {
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ListTile(
        leading: Image.asset(widget.item.image, width: 40, height: 40),
        title: Text(widget.title, style: AppTypography.bodyMediumPrimary),
        subtitle:
            Text(widget.subtitle, style: AppTypography.attributeLabel),
        onTap: () => widget.onTap(_layerLink),
      ),
    );
  }
}
