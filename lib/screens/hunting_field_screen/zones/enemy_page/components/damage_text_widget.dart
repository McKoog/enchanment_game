import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DamageTextData {
  final String id;
  final int damage;
  final double randomX;
  final double randomY;
  final bool isHeal;

  DamageTextData({
    required this.id,
    required this.damage,
    required this.randomX,
    required this.randomY,
    this.isHeal = false,
  });
}

class DamageTextWidget extends StatefulWidget {
  final int damage;
  final VoidCallback onComplete;
  final bool flyUp;
  final bool isHeal;

  const DamageTextWidget({
    super.key,
    required this.damage,
    required this.onComplete,
    this.flyUp = true,
    this.isHeal = false,
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
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.flyUp ? const Offset(0, -100) : const Offset(-100, 0),
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
            child: Text(
              widget.isHeal ? '+ ${widget.damage}' : '- ${widget.damage}',
              style: TextStyle(
                color: widget.isHeal ? AppColors.success : AppColors.error,
                fontSize: 28,
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
          ),
        );
      },
    );
  }
}
