import 'dart:math';

import 'package:enchantment_game/data_providers/all_monsters_list.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/components_decoration.dart';
import 'package:enchantment_game/decorations/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/decorations/zone_decorations.dart';
import 'package:enchantment_game/main.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/own_packages/HorizonalListWheelScrollView.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/base_main_zone_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/weapon_info_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class HuntingFieldScreen extends ConsumerWidget {
  const HuntingFieldScreen({Key? key, required this.width}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print(ref.read(currentSelectedWeaponHuntingField));
      print(ref.read(currentSelectedMonsterHuntingField));
      return ref.watch(showHuntMonsterPage)
          ? MonsterPage(
              width: width,
              monster: ref.read(currentSelectedMonsterHuntingField)!,
              weapon: ref.watch(currentSelectedWeaponHuntingField)!,
            )
          : HuntingFieldsMenu(constraints: constraints, width: width);
    }));
  }
}

class HuntingFieldsMenu extends ConsumerStatefulWidget {
  const HuntingFieldsMenu(
      {Key? key, required this.constraints, required this.width})
      : super(key: key);
  final BoxConstraints constraints;
  final double width;

  @override
  ConsumerState<HuntingFieldsMenu> createState() => _HuntingFieldsMenuState();
}

class _HuntingFieldsMenuState extends ConsumerState<HuntingFieldsMenu>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FixedExtentScrollController controllerWeapon;
  late final FixedExtentScrollController controllerMonster;

  @override
  void initState() {
    var inv = ref.read(inventory);
    List<Weapon?> myWeapons = inv.getAllMyWeapons(true);
    controllerWeapon =
        FixedExtentScrollController(initialItem: myWeapons.length > 2 ? 1 : 0);
    controllerMonster = FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var inv = ref.watch(inventory);
    List<Weapon?> myWeapons = inv.getAllMyWeapons(true);
    Weapon? selectedWeapon = ref.watch(currentSelectedWeaponHuntingField);
    Monster? selectedMonster = ref.watch(currentSelectedMonsterHuntingField);
    selectedWeapon ??
        SchedulerBinding.instance.addPostFrameCallback((_) => ref
            .read(currentSelectedWeaponHuntingField.notifier)
            .update((state) => myWeapons.length > 2
                ? myWeapons[1]
                : myWeapons[
                    0])); //myWeapons.length>2?myWeapons[1]:myWeapons[0];
    return SingleChildScrollView(
      child: Container(
        height: widget.constraints.maxHeight,
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //SizedBox(height: 20,),
            Text(
              "HuntingField",
              style: huntFieldNameTextDecoration,
            ),
            /*SizedBox(height: 20,),
            Text("Welcome to hunting field!",textAlign:TextAlign.center,style: huntFieldDescriptionTextDecoration,),*/
            //SizedBox(height: 8,),
            Text(
              "At first, pick avaliable weapon to fight monsters with...",
              textAlign: TextAlign.center,
              style: huntFieldDescriptionTextDecoration,
            ),
            //SizedBox(height: 20,),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      if (controllerWeapon.selectedItem > 0) {
                        controllerWeapon.animateToItem(
                            controllerWeapon.selectedItem - 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 80,
                      color: Colors.yellow,
                    )),
                Expanded(
                  child: Container(
                    height: widget.constraints.maxHeight / 4,
                    //color: Colors.grey.shade800,
                    child: HorizontalListWheelScrollView(
                      controller: controllerWeapon,
                      childCount: myWeapons.length,
                      scrollDirection: Axis.horizontal,
                      itemExtent: 200,
                      onSelectedItemChanged: (index) {
                        ref
                            .read(currentSelectedWeaponHuntingField.notifier)
                            .update((state) => myWeapons[index]);
                      },
                      builder: (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.all(16),
                            child: InventorySlot(
                                index: 1000, item: myWeapons[index]));
                      },
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      if (controllerWeapon.selectedItem <
                          myWeapons.length - 1) {
                        controllerWeapon.animateToItem(
                            controllerWeapon.selectedItem + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 80,
                      color: Colors.yellow,
                    )),
              ],
            ),
            //SizedBox(height: 8,),
            //if(selectedWeapon != null)Text(selectedWeapon.enchantLevel>0 ?selectedWeapon.name + " +" + selectedWeapon.enchantLevel.toString():selectedWeapon.name,style: huntFieldSelectedWeaponTextDecoration,),
            selectedWeapon != null
                ? Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //SvgPicture.asset("assets/hunt_button_icon.svg",height:50,color:Colors.yellow.shade800,),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: huntBeginButtonDecoration,
                          child: Text(
                            selectedWeapon.enchantLevel > 0
                                ? selectedWeapon.name +
                                    " +" +
                                    selectedWeapon.enchantLevel.toString()
                                : selectedWeapon.name,
                            style: huntFieldSelectedWeaponTextDecoration,
                          ),
                        )),
                        //SvgPicture.asset("assets/hunt_button_icon.svg",height: 50,color:Colors.yellow.shade800,),
                      ],
                    ),
                  )
                : Container(
                    height: 80, width: MediaQuery.of(context).size.width - 60),
            /*if(selectedWeapon != null)BaseMainZoneField(sideSize: MediaQuery.of(context).size.width,backgroundItem: Item(type: ItemType.weapon, image: selectedWeapon.image, isSvgAsset: selectedWeapon.isSvgAsset),
            child: WeaponInfoField(sideSize: MediaQuery.of(context).size.width, weapon: selectedWeapon)),*/
            //SizedBox(height: 20,),
            Text(
              "Then,select your enemy...",
              textAlign: TextAlign.center,
              style: huntFieldDescriptionTextDecoration,
            ),
            //SizedBox(height: 20,),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      if (controllerMonster.selectedItem > 0) {
                        controllerMonster.animateToItem(
                            controllerMonster.selectedItem - 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 80,
                      color: Colors.yellow,
                    )),
                Expanded(
                  child: Container(
                    height: widget.constraints.maxHeight / 4,
                    //color: Color.fromRGBO(85, 85, 85, 1).withOpacity(0.5),
                    child: HorizontalListWheelScrollView(
                      controller: controllerMonster,
                      childCount: 3,
                      //ref.read(allMonstersList).length,
                      scrollDirection: Axis.horizontal,
                      itemExtent: 200,
                      onSelectedItemChanged: (index) {
                        ref
                            .read(currentSelectedMonsterHuntingField.notifier)
                            .update((state) => index == 0
                                ? ref.read(allMonstersList)[0]
                                : null);
                      },
                      builder: (BuildContext context, int index) {
                        return Container(
                            height: widget.constraints.maxHeight / 4,
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(8),
                            decoration: inventorySlotDecoration,
                            child: index == 0
                                ? Image.asset(
                                    ref.read(allMonstersList)[index].image)
                                : SizedBox());
                      },
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      if (controllerMonster.selectedItem < 3) {
                        controllerMonster.animateToItem(
                            controllerMonster.selectedItem + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 80,
                      color: Colors.yellow,
                    )),
              ],
            ),
            //SizedBox(height: 20,),
            //if(selectedMonster != null)Text(selectedMonster.name,style: huntFieldSelectedMonsterTextDecoration,),
            //Expanded(child: SizedBox()),

            selectedMonster != null
                ? InkWell(
                    onTap: () {
                      ref
                          .read(showHuntMonsterPage.notifier)
                          .update((state) => true);
                    },
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 60,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            "assets/hunt_button_icon.svg",
                            height: 50,
                            color: Colors.yellow,
                          ),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: huntBeginButtonDecoration,
                                  child: Text(
                                    "Hunt " + selectedMonster.name,
                                    style: huntingBeginButtonTextDecoration,
                                  ))),
                          SvgPicture.asset(
                            "assets/hunt_button_icon.svg",
                            height: 50,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 80, width: MediaQuery.of(context).size.width - 60),
            //SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}

class MonsterPage extends ConsumerStatefulWidget {
  const MonsterPage(
      {super.key,
      required this.width,
      required this.monster,
      required this.weapon});

  final double width;
  final Monster monster;
  final Weapon weapon;

  @override
  ConsumerState<MonsterPage> createState() => _MonsterPageState();
}

class _MonsterPageState extends ConsumerState<MonsterPage> {
  late int currentHP;
  late double widthOfOneHP;

  @override
  void initState() {
    currentHP = widget.monster.hp;
    widthOfOneHP = (widget.width-160)/100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: () {
                  ref
                      .read(showHuntMonsterPage.notifier)
                      .update((state) => false);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Colors.yellow,
                )),
            Container(
              height: 80,
              width: widget.width - 100,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    "assets/hunt_button_icon.svg",
                    height: 50,
                    color: Colors.yellow,
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: monsterNameFieldDecoration,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.monster.name,
                                style: FarmMonsterNameTextDecoration,
                              ),
                              Text(
                                "show droplist",
                                style: TextStyle(color: Colors.yellow),
                              ),
                            ],
                          ))),
                  SvgPicture.asset("assets/hunt_button_icon.svg",
                      height: 50, color: Colors.yellow),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              size: 40,
              color: Colors.yellow,
            ),
          ],
        ),
        //Text(monster.name,style: mobNameTextDecoration),
        Container(
          height: widget.width - 200,
          width: widget.width - 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.43),
                  spreadRadius: 10,
                  blurRadius: 100)
            ],
          ),
          margin: const EdgeInsets.all(32.0),
          child: Image.asset("assets/lvl_1_werewolf.png"),
        ),
        Container(
          height: 80,
          width: widget.width - 60,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset("assets/monster_hp_icon.svg", height: 50),
              Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: widthOfOneHP*currentHP,
                      decoration: monsterHpBarDecoration,
                      /*child: Text(
                        "$currentHP / ${widget.monster.hp}",
                        style: FarmMonsterHpTextDecoration,
                      )*/),
                  Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: widthOfOneHP*100,
                      decoration: monsterHpBarDecoration,
                      child: Text(
                        "$currentHP / ${widget.monster.hp}",
                        style: FarmMonsterHpTextDecoration,
                      )),
                ],
              ),
              SvgPicture.asset(
                "assets/monster_hp_icon.svg",
                height: 50,
              ),
            ],
          ),
        ),
        //Container(height: 20,width:screenSize.width/1.2,color: Colors.red.shade800,),
        //SizedBox(height: 8,),
        //Text("1000 / 1000",style: TextStyle(fontSize: 22,color: Colors.white),),
        Expanded(
            child: InkWell(
              onTap: (){
                if(currentHP > widget.weapon.lowerDamage) {
                  currentHP = currentHP - widget.weapon.lowerDamage;
                  setState(() {

                  });
                }
                else{
                  currentHP = widget.monster.hp;
                  widget.monster.dropList.forEach((element) {
                    int rand = Random().nextInt(100);
                    if(rand <= element.chance){
                      Item item =
                      element.item.type == ItemType.weapon
                      ?Weapon(id:Uuid().v1().toString(),type: ItemType.weapon, image: "assets/sword.svg", name: "Basic Sword", lowerDamage: 2, higherDamage: 3, enchantLevel: 0)
                      :Scroll(id:Uuid().v1().toString(),type: ItemType.scroll, image: "assets/enchant_scroll.svg", name: "Scroll of enchant", description: "Increase power of the weapon, but be carefull, it's not garanteed");
                     // element.item.id = Uuid().v1().toString();
                      //print("ADD ITEM id = ${item.id}");
                      if(ref.read(inventory).isLastFiveSlots()){
                        if(item.type == ItemType.scroll)ref.read(inventory.notifier).update((state) => ref.read(inventory).putItem(item));
                      }else{
                        ref.read(inventory.notifier).update((state) => ref.read(inventory).putItem(item));
                      }
                    }
                  });
                  setState(() {

                  });
                }
              },
              child: Container(
                  margin: EdgeInsets.all(50),
                  decoration: widget.weapon.enchantLevel < 1
                      ? attackFieldDecoration
                      : BoxDecoration(
                          color: const Color.fromRGBO(85, 85, 85, 1),
                          border: Border.fromBorderSide(BorderSide(
                              color: widget.weapon.enchantLevel <= 15
                                  ? Color.fromRGBO(130, 130, 130, 1)
                                  : widget.weapon.enchantLevel <= 20
                                      ? enchantedWeaponsGlowColors[
                                              widget.weapon.enchantLevel]
                                          .withOpacity(0.6)
                                      : Color.fromRGBO(130, 130, 130, 1),
                              width: 2)),
                          shape: BoxShape.circle,
                          //borderRadius: BorderRadius.circular(15),
                          boxShadow: widget.weapon.enchantLevel == 0
                              ? null
                              : widget.weapon.enchantLevel > 20
                                  ? [
                                      BoxShadow(
                                          color: enchantedWeaponsGlowColors[21],
                                          blurRadius: 30,
                                          spreadRadius: 15)
                                    ]
                                  : [
                                      BoxShadow(
                                          color: enchantedWeaponsGlowColors[
                                              widget.weapon.enchantLevel],
                                          blurRadius: 30,
                                          spreadRadius: 15)
                                    ]),
                  child: Transform.scale(
                      scale: 0.7,
                      child: widget.weapon.isSvgAsset
                          ? SvgPicture.asset(
                              widget.weapon.image,
                              fit: BoxFit.fitHeight,
                            )
                          : Image.asset(
                              widget.weapon.image,
                              fit: BoxFit.scaleDown,
                            ))),
            ))
      ]),
    );
  }
}
