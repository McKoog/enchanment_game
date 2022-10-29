import 'package:flutter/cupertino.dart';

Decoration inventoryZoneDecoration = BoxDecoration(
    color: const Color.fromRGBO(78, 78, 78, 1),
    border: const Border.fromBorderSide(
        BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1),
            width: 5)
    ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [BoxShadow(blurRadius: 15,spreadRadius: 0)]
);