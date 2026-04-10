import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DamageTextData {
  final String id;
  final double damage;
  final double randomX;
  final double randomY;
  final bool isHeal;
  final bool isBlock;
  final bool isCrit;

  DamageTextData({
    required this.id,
    required this.damage,
    required this.randomX,
    required this.randomY,
    this.isHeal = false,
    this.isBlock = false,
    this.isCrit = false,
  });
}

class DamageTextWidget extends StatefulWidget {
  final double damage;
  final VoidCallback onComplete;
  final bool flyUp;
  final bool isHeal;
  final bool isBlock;
  final bool isCrit;
  final double? flyDistance;
  final Duration? duration;

  const DamageTextWidget({
    super.key,
    required this.damage,
    required this.onComplete,
    this.flyUp = true,
    this.isHeal = false,
    this.isBlock = false,
    this.isCrit = false,
    this.flyDistance,
    this.duration,
  });

  @override
  State<DamageTextWidget> createState() => _DamageTextWidgetState();
}

class _DamageTextWidgetState extends State<DamageTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 2000),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.flyUp
          ? Offset(0, -(widget.flyDistance ?? 100.0))
          : Offset(0, (widget.flyDistance ?? 100.0)),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.isBlock
                        ? 'Blocked'
                        : widget.isHeal
                            ? '+ ${widget.damage.toStringAsFixed(2)}'
                            : '- ${widget.damage.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: widget.isBlock
                          ? Colors.grey
                          : widget.isHeal
                              ? AppColors.success
                              : AppColors.error,
                      fontSize: widget.isBlock ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PT Sans',
                      shadows: const [
                        Shadow(
                          color: AppColors.black,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                  if (widget.isCrit)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
                      child: Text(
                        'crit',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PT Sans',
                          fontStyle: FontStyle.italic,
                          shadows: const [
                            Shadow(
                              color: AppColors.black,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
