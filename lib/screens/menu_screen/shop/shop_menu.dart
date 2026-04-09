import 'dart:async';
import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';

import 'components/shop_inventory_list.dart';
import 'components/shop_tabs_header.dart';
import 'components/shop_trade_checkout.dart';

enum ShopTab { buy, sell }

class TradeItem {
  final Item item;
  int quantity;
  final int? inventoryIndex; // Only used for selling

  TradeItem({
    required this.item,
    required this.quantity,
    this.inventoryIndex,
  });
}

class ShopMenu extends StatefulWidget {
  const ShopMenu({super.key});

  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  ShopTab _currentTab = ShopTab.buy;
  final List<TradeItem> _tradeList = [];
  bool _showSuccess = false;
  OverlayEntry? _activeEntry;

  final List<Item> _buyItems = [
    ItemRegistry.createScroll(ScrollType.weapon),
    ItemRegistry.createScroll(ScrollType.armor),
  ];

  @override
  void dispose() {
    _activeEntry?.remove();
    _activeEntry = null;
    super.dispose();
  }

  void _onTabChanged(ShopTab tab) {
    setState(() {
      _currentTab = tab;
      _tradeList.clear();
    });
  }

  void _onRemoveTradeItem(int index) {
    setState(() {
      _tradeList.removeAt(index);
    });
  }

  String _getItemName(Item item) {
    if (item is Weapon) {
      return item.enchantLevel > 0
          ? "${item.name} +${item.enchantLevel}"
          : item.name;
    }
    if (item is Armor) {
      return item.enchantLevel > 0
          ? "${item.name} +${item.enchantLevel}"
          : item.name;
    }
    if (item is Scroll) return item.name;
    return 'Item';
  }

  void _onItemTap(
      Item item, int? invIndex, LayerLink layerLink, int playerGold) async {
    int maxQty = 1;
    if (_currentTab == ShopTab.buy) {
      if (item is Scroll) {
        maxQty = playerGold ~/ item.buyPrice;
        if (maxQty > Scroll.maxStackSize) maxQty = Scroll.maxStackSize;
      }
    } else {
      if (item is Scroll) {
        maxQty = item.quantity;
      }
    }

    if (maxQty <= 0 && _currentTab == ShopTab.buy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough gold')),
      );
      return;
    }

    int selectedQty = 1;
    if (item is Scroll && maxQty > 1) {
      final result = await _showQuantityPopover(context,
          maxQuantity: maxQty, layerLink: layerLink);
      if (result == null || result <= 0) return;
      selectedQty = result;
    }

    setState(() {
      if (_currentTab == ShopTab.buy) {
        final existing = _tradeList
            .where((t) => _getItemName(t.item) == _getItemName(item))
            .firstOrNull;
        if (existing != null && existing.item is Scroll) {
          existing.quantity += selectedQty;
        } else {
          _tradeList.add(TradeItem(item: item, quantity: selectedQty));
        }
      } else {
        _tradeList.add(TradeItem(
            item: item, quantity: selectedQty, inventoryIndex: invIndex));
      }
    });
  }

  Future<int?> _showQuantityPopover(BuildContext context,
      {required int maxQuantity, required LayerLink layerLink}) async {
    final overlay = Overlay.of(context, rootOverlay: true);

    _activeEntry?.remove();
    _activeEntry = null;

    final completer = Completer<int?>();
    var selected = maxQuantity;

    late final OverlayEntry entry;
    void close([int? result]) {
      if (completer.isCompleted) return;
      entry.remove();
      if (_activeEntry == entry) {
        _activeEntry = null;
      }
      completer.complete(result);
    }

    entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => close(),
              ),
            ),
            CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              offset: const Offset(0, 6),
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {},
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
                      width: 166,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.overlayVeryDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.panelBorder,
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$selected/$maxQuantity',
                                style: AppTypography.attributeLabel.copyWith(
                                    color: AppColors.primaryText),
                              ),
                              SizedBox(
                                height: 22,
                                width: 120,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6),
                                    overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 10),
                                    activeTrackColor: AppColors.white,
                                    inactiveTrackColor:
                                        AppColors.slotBackground,
                                    thumbColor: AppColors.white,
                                  ),
                                  child: Slider(
                                    value: selected.toDouble(),
                                    min: 1,
                                    max: maxQuantity.toDouble(),
                                    divisions: maxQuantity > 1
                                        ? maxQuantity - 1
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value.round();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => close(selected),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.check,
                                  size: 24, color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
    return completer.future;
  }

  void _onConfirmTrade(CharacterBloc characterBloc, InventoryBloc inventoryBloc,
      int totalSum) async {
    if (_currentTab == ShopTab.buy) {
      characterBloc.add(CharacterAddGold(-totalSum));
      for (var trade in _tradeList) {
        if (trade.item is Scroll) {
          final scroll =
              ItemRegistry.createScroll((trade.item as Scroll).scrollType);
          scroll.quantity = trade.quantity;
          inventoryBloc.add(InventoryEvent$AddItem(item: scroll));
        } else {
          for (int i = 0; i < trade.quantity; i++) {
            inventoryBloc.add(InventoryEvent$AddItem(
                item: trade.item)); 
          }
        }
      }
    } else {
      characterBloc.add(CharacterAddGold(totalSum));
      for (var trade in _tradeList) {
        if (trade.item is Scroll &&
            trade.quantity < (trade.item as Scroll).quantity) {
          for (int i = 0; i < trade.quantity; i++) {
            inventoryBloc.add(
                InventoryEvent$ConsumeScroll(slotIndex: trade.inventoryIndex!));
          }
        } else {
          inventoryBloc.add(InventoryEvent$RemoveItem(item: trade.item));
        }
      }
    }

    setState(() {
      _tradeList.clear();
      _showSuccess = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _showSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterBloc = context.watch<CharacterBloc>();
    final inventoryBloc = context.watch<InventoryBloc>();
    final character = characterBloc.state.character;
    final inventory = inventoryBloc.state.inventory;

    int totalSum = 0;
    for (var trade in _tradeList) {
      if (_currentTab == ShopTab.buy) {
        totalSum += trade.item.buyPrice * trade.quantity;
      } else {
        totalSum += trade.item.sellPrice * trade.quantity;
      }
    }

    bool canConfirm = false;
    if (_tradeList.isNotEmpty) {
      if (_currentTab == ShopTab.buy) {
        if (totalSum <= character.gold) {
          int neededSlots = 0;
          for (var trade in _tradeList) {
            if (trade.item is Scroll) {
              neededSlots += (trade.quantity / Scroll.maxStackSize).ceil();
            } else {
              neededSlots += trade.quantity;
            }
          }
          if (inventory.emptySlots >= neededSlots) {
            canConfirm = true;
          }
        }
      } else {
        canConfirm = true;
      }
    }

    final sellableItems = <Map<String, dynamic>>[];
    if (_currentTab == ShopTab.sell) {
      for (int i = 0; i < inventory.items.length; i++) {
        final item = inventory.items[i];
        if (item != null) {
          bool inTradeList = _tradeList.any((t) => t.inventoryIndex == i);
          if (!inTradeList) {
            sellableItems.add({'item': item, 'index': i});
          }
        }
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            ShopTabsHeader(
              currentTab: _currentTab,
              onTabChanged: _onTabChanged,
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.borderHighlight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ShopInventoryList(
                  currentTab: _currentTab,
                  buyItems: _buyItems,
                  sellableItems: sellableItems,
                  getItemName: _getItemName,
                  onItemTap: (item, invIndex, layerLink) =>
                      _onItemTap(item, invIndex, layerLink, character.gold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: ShopTradeCheckout(
                tradeList: _tradeList,
                currentTab: _currentTab,
                totalSum: totalSum,
                canConfirm: canConfirm,
                getItemName: _getItemName,
                onRemoveItem: _onRemoveTradeItem,
                onConfirm: () => _onConfirmTrade(
                    characterBloc, inventoryBloc, totalSum),
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showSuccess ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.overlayVeryDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accentYellow, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 64),
                      const SizedBox(height: 16),
                      Text('Successfull Deal',
                          style: AppTypography.titleLargePrimary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
