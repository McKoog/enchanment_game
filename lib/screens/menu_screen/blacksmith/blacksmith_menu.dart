import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

class BlacksmithMenu extends StatelessWidget {
  const BlacksmithMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Text(
          'Blacksmith menu will be added soon...',
          style: AppTypography.titleLargeSecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
