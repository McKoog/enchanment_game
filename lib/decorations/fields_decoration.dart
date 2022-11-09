import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Decoration enchantFieldDecoration =  BoxDecoration(
    color: const Color.fromRGBO(78, 78, 78, 1),
    border: const Border.fromBorderSide(
        BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1),
            width: 5)
    ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [BoxShadow(blurRadius: 15,spreadRadius: 0)]
);

Decoration attackFieldDecoration =  BoxDecoration(
    color: const Color.fromRGBO(78, 78, 78, 1),
    /*border: const Border.fromBorderSide(
        BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1),
            width: 5)
    ),*/
    shape: BoxShape.circle,
    boxShadow: const [BoxShadow(blurRadius: 30,spreadRadius: 15,color: Colors.grey)]
);