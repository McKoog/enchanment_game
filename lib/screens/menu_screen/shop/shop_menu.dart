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
          // Simple slot check: count how many slots we need
          // Actually, scrolls stack, but let's do a rough check or exact check.
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
        canConfirm = true; // Always can sell
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            // Top Section Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildTab(ShopTab.buy, 'Buy')),
                Expanded(child: _buildTab(ShopTab.sell, 'Sell')),
              ],
            ),
            const SizedBox(height: 8),
            // Top Section List
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.yellow.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildTopList(character.gold, inventory.items),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Trade List',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.yellow)),
            const SizedBox(height: 8),
            // Bottom Section (Trade List)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.yellow.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _tradeList.length,
                  itemBuilder: (context, index) {
                    final trade = _tradeList[index];
                    final price = _currentTab == ShopTab.buy
                        ? trade.item.buyPrice
                        : trade.item.sellPrice;
                    return ListTile(
                      leading:
                          Image.asset(trade.item.image, width: 40, height: 40),
                      title: Text(_getItemName(trade.item)),
                      subtitle: Text(
                          'Quantity: ${trade.quantity} | Total: ${price * trade.quantity} G'),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _tradeList.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Total & Confirm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Total: $totalSum Gold',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withValues(alpha: 0.2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: Colors.yellow.withValues(alpha: 0.5),
                          width: 1),
                    ),
                  ),
                  onPressed: canConfirm
                      ? () =>
                          _confirmTrade(characterBloc, inventoryBloc, totalSum)
                      : null,
                  child: const Text(
                    'Confirm Deal',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ],
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
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.yellow, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 64),
                      SizedBox(height: 16),
                      Text('Successfull Deal',
                          style: TextStyle(color: Colors.white, fontSize: 24)),
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

  Widget _buildTab(ShopTab tab, String label) {
    final isSelected = _currentTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTab = tab;
          _tradeList.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.yellow.withValues(alpha: 0.4)
              : Colors.grey.shade700.withValues(alpha: 0.75),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopList(int playerGold, List<Item?> inventoryItems) {
    if (_currentTab == ShopTab.buy) {
      return ListView.builder(
        itemCount: _buyItems.length,
        itemBuilder: (context, index) {
          final item = _buyItems[index];
          return _ShopListItem(
            item: item,
            title: _getItemName(item),
            subtitle: '${item.buyPrice} Gold',
            onTap: (layerLink) =>
                _handleItemTap(item, playerGold, null, layerLink),
          );
        },
      );
    } else {
      final sellableItems = <Map<String, dynamic>>[];
      for (int i = 0; i < inventoryItems.length; i++) {
        final item = inventoryItems[i];
        if (item != null) {
          // Check if already in trade list
          bool inTradeList = _tradeList.any((t) => t.inventoryIndex == i);
          if (!inTradeList) {
            sellableItems.add({'item': item, 'index': i});
          }
        }
      }

      return ListView.builder(
        itemCount: sellableItems.length,
        itemBuilder: (context, index) {
          final data = sellableItems[index];
          final item = data['item'] as Item;
          final invIndex = data['index'] as int;
          int qty = 1;
          if (item is Scroll) qty = item.quantity;
          return _ShopListItem(
            item: item,
            title: _getItemName(item),
            subtitle: 'Quantity: $qty | ${item.sellPrice} Gold',
            onTap: (layerLink) =>
                _handleItemTap(item, playerGold, invIndex, layerLink),
          );
        },
      );
    }
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

  void _handleItemTap(
      Item item, int playerGold, int? invIndex, LayerLink layerLink) async {
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
        // Check if already in trade list to stack
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
                        color: const Color.fromRGBO(30, 30, 30, 0.95),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color.fromRGBO(120, 120, 120, 1),
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
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor:
                                        const Color.fromRGBO(90, 90, 90, 1),
                                    thumbColor: Colors.white,
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
                                  size: 24, color: Colors.white),
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

  void _confirmTrade(CharacterBloc characterBloc, InventoryBloc inventoryBloc,
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
                item: trade.item)); // Need proper cloning if weapons/armor
          }
        }
      }
    } else {
      characterBloc.add(CharacterAddGold(totalSum));
      for (var trade in _tradeList) {
        if (trade.item is Scroll &&
            trade.quantity < (trade.item as Scroll).quantity) {
          // We sold partial stack, need to consume scroll or update inventory manually
          // The easiest way is to split/consume.
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
}

class _ShopListItem extends StatefulWidget {
  final Item item;
  final String title;
  final String subtitle;
  final void Function(LayerLink) onTap;

  const _ShopListItem({
    required this.item,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ShopListItem> createState() => _ShopListItemState();
}

class _ShopListItemState extends State<_ShopListItem> {
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ListTile(
        leading: Image.asset(widget.item.image, width: 40, height: 40),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        subtitle:
            Text(widget.subtitle, style: const TextStyle(color: Colors.grey)),
        onTap: () => widget.onTap(_layerLink),
      ),
    );
  }
}
