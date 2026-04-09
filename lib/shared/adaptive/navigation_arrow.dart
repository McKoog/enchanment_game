import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_bloc.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ArrowDirection { left, right }

class NavigationArrow extends StatefulWidget {
  const NavigationArrow({
    super.key,
    required this.direction,
    required this.onTap,
    required this.visible,
  });

  final ArrowDirection direction;
  final VoidCallback onTap;
  final bool visible;

  @override
  State<NavigationArrow> createState() => _NavigationArrowState();
}

class _NavigationArrowState extends State<NavigationArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisualSettingsBloc, VisualSettingsState>(
      builder: (context, state) {
        final isVisible = widget.visible && state.showNavigationArrows;
        return AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: 30,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.overlayMedium,
                    borderRadius: widget.direction == ArrowDirection.left
                        ? const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                    border: Border.all(
                      color: AppColors.borderHighlight,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    widget.direction == ArrowDirection.left
                        ? Icons.chevron_left
                        : Icons.chevron_right,
                    color: AppColors.accentYellow,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
