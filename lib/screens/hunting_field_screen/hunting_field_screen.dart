import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/decorations/zone_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/own_packages/HorizonalListWheelScrollView.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HuntingFieldScreen extends StatelessWidget {
  const HuntingFieldScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return HuntingFieldsMenu(constraints: constraints,);
            }
        )
    );
  }
}

class HuntingFieldsMenu extends ConsumerWidget {
  const HuntingFieldsMenu({Key? key,required this.constraints}) : super(key: key);
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var inv = ref.watch(inventory);
    print(inv.items);
    List<Weapon?> myWeapons = inv.getAllMyWeapons(true);
    Weapon? selectedWeapon = ref.watch(currentSelectedWeaponHuntingField);
    return Column(
      children: [
        SizedBox(height: 20,),
        Text("HuntingField",style: huntFieldNameTextDecoration,),
        SizedBox(height: 20,),
        Text("Welcome to hunting field!",textAlign:TextAlign.center,style: huntFieldDescriptionTextDecoration,),
        Text("At first, pick avaliable weapon to fight monsters with...",textAlign:TextAlign.center,style: huntFieldDescriptionTextDecoration,),
        SizedBox(height: 20,),
        Container(
          height: constraints.maxHeight/6,
          //color: Colors.red,
          child: HorizontalListWheelScrollView(
            childCount:myWeapons.length,
            scrollDirection:Axis.horizontal,
            itemExtent: 150,
            onSelectedItemChanged: (index){
              ref.read(currentSelectedWeaponHuntingField.notifier).update((state) => myWeapons[index]);
            },
            builder: (BuildContext context, int index) {
            return Container(margin: EdgeInsets.all(16),child: InventorySlot(index: 1000,item: myWeapons[index]));
          },),
        ),
        selectedWeapon != null
            ?Text(selectedWeapon.enchantLevel>0 ?selectedWeapon.name + " +" + selectedWeapon.enchantLevel.toString():selectedWeapon.name,style: huntFieldSelectedWeaponTextDecoration,)
            :SizedBox(),
      ],
    );
  }
}




class MonsterPage extends StatelessWidget {
  const MonsterPage({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text("Werewolf",style: mobNameTextDecoration),
          Text("show droplist",style: TextStyle(color: Colors.white),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/lvl_1_werewolf.png"),
          ),
          Container(height: 20,width:screenSize.width/1.2,color: Colors.red.shade800,),
          SizedBox(height: 8,),
          Text("1000 / 1000",style: TextStyle(fontSize: 22,color: Colors.white),),
          Expanded(child: Container(margin:EdgeInsets.all(50),decoration: attackFieldDecoration))
        ]);
  }
}
