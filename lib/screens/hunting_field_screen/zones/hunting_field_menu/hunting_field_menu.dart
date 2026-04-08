import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/enemy_picker/enemy_picker.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/picked_enemy_field.dart';
import 'package:flutter/material.dart';

class HuntingFieldsMenu extends StatefulWidget {
  const HuntingFieldsMenu(
      {super.key, required this.constraints, required this.width});

  final BoxConstraints constraints;
  final double width;

  @override
  State<HuntingFieldsMenu> createState() => _HuntingFieldsMenuState();
}

class _HuntingFieldsMenuState extends State<HuntingFieldsMenu>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FixedExtentScrollController controllerEnemy;

  @override
  void initState() {
    controllerEnemy = FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  Widget title(String text) {
    return Text(
      text,
      style: huntFieldNameTextDecoration,
    );
  }

  Widget descriptionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: huntFieldDescriptionTextDecoration,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: SizedBox(
        height: widget.constraints.maxHeight,
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            title("HuntingField"),
            descriptionText("Select your enemy..."),
            SizedBox(
              height: 24,
            ),
            EnemyPicker(
                controllerEnemy: controllerEnemy,
                constraints: widget.constraints),
            SizedBox(
              height: 24,
            ),
            const PickedEnemyField(),
          ],
        ),
      ),
    );
  }
}
