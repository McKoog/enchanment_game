import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_bloc.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_event.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_slot.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryField extends StatefulWidget {
  const InventoryField({super.key, required this.sideSize, required this.capacity});

  final double sideSize;
  final int capacity;

  @override
  State<InventoryField> createState() => _InventoryFieldState();
}

class _InventoryFieldState extends State<InventoryField> {
  int _currentPage = 0;

  void _changePage(int newPage) {
    if (_currentPage != newPage && newPage >= 0 && newPage < 7) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  void _sortCurrentPage() {
    final startIndex = 5 + _currentPage * 20;
    final endIndex = startIndex + 20;
    context.read<InventoryBloc>().add(InventoryEvent$SortRange(startIndex: startIndex, endIndex: endIndex));
  }

  Widget _buildPageIcon(int pageNum) {
    bool isSelected = _currentPage == (pageNum - 1);
    return GestureDetector(
      onTap: () => _changePage(pageNum - 1),
      child: Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentYellow.withValues(alpha: 0.25) : AppColors.overlayMedium,
          border: Border.all(color: AppColors.accentYellow, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '$pageNum',
          style: TextStyle(color: AppColors.accentYellow, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildSortIcon() {
    return GestureDetector(
      onTap: _sortCurrentPage,
      child: Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.overlayMedium,
          border: Border.all(color: AppColors.accentYellow, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.sort, color: AppColors.accentYellow, size: 16),
      ),
    );
  }

  Widget _buildPageSwitcher() {
    final gridWidth = widget.sideSize - 20;
    final slotWidth = (gridWidth - 20) / 5;
    final edgeOffset = slotWidth / 2;

    return SizedBox(
      width: gridWidth,
      child: Row(
        children: [
          SizedBox(width: edgeOffset),
          Expanded(child: _buildPageIcon(1)),
          Expanded(child: _buildPageIcon(2)),
          Expanded(child: _buildPageIcon(3)),
          Expanded(child: _buildPageIcon(4)),
          Expanded(child: _buildPageIcon(5)),
          Expanded(child: _buildPageIcon(6)),
          Expanded(child: _buildPageIcon(7)),
          Expanded(child: _buildSortIcon()),
          SizedBox(width: edgeOffset),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPageSwitcher(),
        const SizedBox(height: 5),
        SizedBox(
            height: widget.sideSize,
            width: widget.sideSize,
            child: BlocBuilder<InventoryBloc, InventoryState>(
                bloc: context.read<InventoryBloc>(),
                builder: (BuildContext context, state) {
                  return BlocBuilder<DraggableItemsBloc, DraggableItemsState>(
                      bloc: context.read<DraggableItemsBloc>(),
                      builder: (context, dragState) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 5, crossAxisSpacing: 5),
                                  itemBuilder: (BuildContext context, int index) {
                                    final item = state.inventory.items[index];
                                    return InventorySlot(
                                      index: index,
                                      item: item,
                                      isPersistent: true,
                                      onTap: () {
                                        if (item == null) {
                                          context.read<EquipOverlayBloc>().add(EquipOverlayEvent$Toggle(overlayType: OverlayType.all));
                                        }
                                      },
                                    );
                                  }),
                              const SizedBox(height: 5),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  switchInCurve: Curves.decelerate,
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    final isEntering = child.key == ValueKey<int>(_currentPage);

                                    if (isEntering) {
                                      final inTween = Tween<Offset>(begin: const Offset(0, 3.5), end: Offset.zero);
                                      return SlideTransition(
                                        position: inTween.animate(animation),
                                        child: child,
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                  child: GridView.builder(
                                      key: ValueKey<int>(_currentPage),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 20,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 5, crossAxisSpacing: 5),
                                      itemBuilder: (BuildContext context, int localIndex) {
                                        final index = 5 + _currentPage * 20 + localIndex;
                                        final item = index < state.inventory.items.length ? state.inventory.items[index] : null;
                                        return InventorySlot(
                                          index: index,
                                          item: item,
                                          isPersistent: false,
                                          onTap: () {
                                            if (item == null) {
                                              context.read<EquipOverlayBloc>().add(EquipOverlayEvent$Toggle(overlayType: OverlayType.all));
                                            }
                                          },
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                })),
      ],
    );
  }
}
